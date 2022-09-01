  //
  //  ReminderManager.swift
  //  Reminder
  //
  //  Created by MANAS VIJAYWARGIYA on 31/08/22.
  //

import SwiftUI
import CoreData

class ReminderManager: ObservableObject {
  @Published var categories: [Category] = []
  @Published var items: [Item] = []
  @Published var itemsCountPerCategory: [Category: Int] = [:]
  
  
  private var _context: NSManagedObjectContext
  
  var newCategoryName: String = "" {
    didSet {
      if !newCategoryName.isEmpty {
        addCategory(name: newCategoryName)
      }
    }
  }
  
  var category: Category? {
    didSet {
      fetchItems()
    }
  }
  
  init(context: NSManagedObjectContext) {
    self._context = context
    
    fetchCategories()
  }
  
  private func save() {
    do {
      if _context.hasChanges {
        try _context.save()
      }
    } catch let error {
      print("Error saving. \(error.localizedDescription)")
      _context.rollback()
    }
    fetchCategories()
  }
}

  // MARK: - Category
extension ReminderManager {
  private func fetchCategories() {
    let request: NSFetchRequest<Category> = Category.fetchRequest()
    do {
      categories = try _context.fetch(request)
      showItemCountPerCategory()
    } catch let error {
      print("Error fetching Categories: \(error.localizedDescription)")
      assertionFailure()
    }
  }
  
  private func addCategory(name: String) {
    let newCategory = Category(context: _context)
    newCategory.id = UUID()
    newCategory.name = name
    save()
  }
  
  func delete(_ category: Category) {
    _context.delete(category)
    save()
  }
  
  func canDelete(_ category: Category) -> Bool {
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    request.predicate = NSPredicate(format: "%K = %@", #keyPath(Item.category), category)
    do {
      return try _context.fetch(request).count == 0
    } catch {
      assertionFailure()
    }
    return false
  }
  
  func showItemCountPerCategory() {
    for category in categories {
      let request: NSFetchRequest<Item> = Item.fetchRequest()
      request.predicate = NSPredicate(format: "%K = %@", #keyPath(Item.category), category)
      
      let count = try? _context.fetch(request).count
      
      itemsCountPerCategory[category] = count ?? 0
    }
  }
}

  // MARK: - Item
extension ReminderManager {
  private func fetchItems() {
    guard let category = category else {
      assertionFailure("Category can't be nil")
      return
    }
    let request: NSFetchRequest<Item> = Item.fetchRequest()
      // %K means Keypath; %@ means its value
    request.predicate = NSPredicate(format: "%K = %@", #keyPath(Item.category), category)
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.name, ascending: true)]
    do {
      items = try _context.fetch(request)
    } catch let error {
      print("Error fetching Items: \(category.name): \(error.localizedDescription)")
      assertionFailure()
    }
  }
  
  // Empty Item
  func newItem() -> Item {
    guard let category = category else {
      assertionFailure("Category can't be nil")
      return Item()
    }
    let item = Item(context: _context)
    item.id = UUID()
    item.completed = false
    item.category = category
    return item
  }
  
  func saveItem() {
    _context.performAndWait {
      save()
    }
    fetchItems()
  }
  
  func deleteItem(_ item: Item) {
    _context.performAndWait {
      _context.delete(item)
      save()
    }
    fetchItems()
  }
}
