  //
  //  CategoryListView.swift
  //  Reminder
  //
  //  Created by MANAS VIJAYWARGIYA on 31/08/22.
  //

import SwiftUI
import AwesomeToast

struct CategoryListView: View {
  @EnvironmentObject private var _manager: ReminderManager
  
  @State private var _showingAlert = false
  @State private var _textEntered = ""
  @State private var _showNoDelete = false
  
  
  var body: some View {
    NavigationView {
      ZStack {
        VStack(alignment: .leading, spacing: 10) {
          List {
            ForEach(_manager.categories, id: \.id) { category in
              NavigationLink {
                ItemListView(category: category)
              } label: {
                Text("\(category.name) - \(_manager.itemsCountPerCategory[category] ?? 0)")
              }

            }
            .onDelete(perform: removeCategoryRow)
          }
          .listStyle(InsetGroupedListStyle())
          
          HStack {
            Button {
              self._showingAlert.toggle()
            } label: {
              if !_showingAlert {
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
        
        if _showingAlert {
          AlertView(textEntered: $_textEntered, showAlert: $_showingAlert)
            .onDisappear {
              if !_textEntered.isEmpty {
                _manager.newCategoryName = _textEntered
              }
            }
        }
      }
      .navigationBarTitle("Category")
      .showToast(title: "Delete Failed!", "There are items currently attached to this category", isPresented: $_showNoDelete, color: Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)), duration: 4, alignment: .bottom, toastType: .offsetToast)
    }
  }
}

extension CategoryListView {
  private func removeCategoryRow(indexSet: IndexSet) {
    guard let index = indexSet.first else { return }
    let category = _manager.categories[index]
    if _manager.canDelete(category) {
      _manager.delete(category)
    } else {
      _showNoDelete = true
    }
  }
}
struct CategoryListView_Previews: PreviewProvider {
  static var previews: some View {
    CategoryListView()
  }
}
