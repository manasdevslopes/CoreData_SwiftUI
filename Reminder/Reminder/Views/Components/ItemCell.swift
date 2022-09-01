  //
  //  ItemCell.swift
  //  Reminder
  //
  //  Created by MANAS VIJAYWARGIYA on 01/09/22.
  //

import SwiftUI

struct ItemCell: View {
  @ObservedObject var itemCellVM: ItemCellViewModel
  
  var body: some View {
    HStack {
      Image(systemName: itemCellVM.item.completed ? "checkmark.circle.fill" : "circle")
        .resizable()
        .frame(width: 25, height: 25)
        .foregroundColor(itemCellVM.item.completed ? .red : Color(.lightGray))
        .onTapGesture {
          itemCellVM.item.completed.toggle()
          itemCellVM.saveItem()
        }
      
      TextField("Enter Item Name",
                text: $itemCellVM.item.name,
                onEditingChanged: { editing in
        if !editing, itemCellVM.item.name.isEmpty {
          itemCellVM.deleteItem()
        }
      },
                onCommit: {
        update(itemCellVM.item)
      })
    }
    .onDisappear {
      update(itemCellVM.item)
    }
  }
}

extension ItemCell {
  private func update(_ item: Item) {
    item.name.isEmpty ? itemCellVM.deleteItem() : itemCellVM.saveItem()
  }
}
struct ItemCell_Previews: PreviewProvider {
  static var previews: some View {
    let manager = ReminderManager(context: PersistenceController.preview.container.viewContext)
    ItemCell(itemCellVM: ItemCellViewModel(manager: manager, item: manager.newItem()))
  }
}
