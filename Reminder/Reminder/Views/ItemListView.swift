  //
  //  ItemListView.swift
  //  Reminder
  //
  //  Created by MANAS VIJAYWARGIYA on 01/09/22.
  //

import SwiftUI

struct ItemListView: View {
  @EnvironmentObject private var _manager: ReminderManager
  @State private var _showAddItem = false
  @State private var _hideCompleted = false
  
  private var _category: Category
  init(category: Category) {
    self._category = category
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      List {
        Toggle("Hide Completed", isOn: $_hideCompleted)
        
        ForEach(_manager.items, id: \.id) { item in
          if !_hideCompleted || !item.completed {
            ItemCell(itemCellVM: ItemCellViewModel(manager: _manager, item: item))
          }
        }
        .onDelete(perform: removeRow)
        
        if _showAddItem {
          ItemCell(itemCellVM: ItemCellViewModel(manager: _manager, item: _manager.newItem()))
        }
      }
      .listStyle(InsetGroupedListStyle())
      
      HStack {
        Button(action: {_showAddItem.toggle()}) {
          if _showAddItem {
            Button(action: {_showAddItem.toggle()}) {
              Text("Done")
            }
            .padding()
          }
          else {
            HStack {
              Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 25, height: 25, alignment: .center)
              Text("New Category")
            }
            .padding()
          }
        }
      }
    }
    .navigationBarTitle(_category.name)
    .onAppear {
      _manager.category = _category
    }
  }
}

extension ItemListView {
  private func removeRow(indexSet: IndexSet) {
    guard let index = indexSet.first else { return }
    let item = _manager.items[index]
    _manager.deleteItem(item)
  }
}
struct ItemListView_Previews: PreviewProvider {
  static var previews: some View {
    ItemListView(category: Category())
  }
}
