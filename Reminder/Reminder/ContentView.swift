  //
  //  ContentView.swift
  //  Reminder
  //
  //  Created by MANAS VIJAYWARGIYA on 31/08/22.
  //

import SwiftUI
import CoreData

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)],
    animation: .default)
  private var categories: FetchedResults<Category>
  
  var body: some View {
    NavigationView {
      List {
        ForEach(categories) { category in
          Text(category.name)
        }
        .onDelete(perform: deleteItems)
      }
      .toolbar {
          //                ToolbarItem(placement: .navigationBarTrailing) {
          //                    EditButton()
          //                }
        ToolbarItem {
          Button(action: addItem) {
            Label("Add Item", systemImage: "plus")
          }
        }
      }
      .navigationBarTitle("Category")
    }
  }
  
  private func addItem() {
    withAnimation {
      let newCategory = Category(context: viewContext)
      newCategory.id = UUID()
      newCategory.name = "Hello World!"
      do {
        try viewContext.save()
      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map { categories[$0] }.forEach(viewContext.delete)
      
      do {
        try viewContext.save()
      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
