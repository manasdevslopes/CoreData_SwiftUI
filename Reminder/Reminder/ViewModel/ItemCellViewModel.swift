//
//  ItemCellViewModel.swift
//  Reminder
//
//  Created by MANAS VIJAYWARGIYA on 01/09/22.
//

import Foundation

class ItemCellViewModel: ObservableObject {
  @Published var item: Item
  
  private var _manager: ReminderManager
  
  init(manager: ReminderManager, item: Item) {
    self._manager = manager
    self.item = item
  }
  
  func saveItem() {
    _manager.saveItem()
  }
  
  func deleteItem() {
    _manager.deleteItem(item)
  }
}
