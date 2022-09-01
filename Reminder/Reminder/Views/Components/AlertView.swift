  //
  //  AlertView.swift
  //  Reminder
  //
  //  Created by MANAS VIJAYWARGIYA on 31/08/22.
  //

import SwiftUI

struct AlertView: View {
  @Binding var textEntered: String
  @Binding var showAlert: Bool
  
  @State private var _editedText: String = ""
  
  var body: some View {
    VStack(alignment: .center) {
      Text("Add Category")
        .font(.title3)
        .fontWeight(.semibold)
        .foregroundColor(.black)
        .padding(.top, 15)
      
      HStack {
        TextField("Enter text", text: $_editedText,
                  onEditingChanged: {_ in },
                  onCommit: {
          textEntered = _editedText
          _editedText = ""
          self.showAlert.toggle()
        })
        .padding(5)
        .background(Color(.lightGray).opacity(0.2))
        .cornerRadius(8)
      }
      .padding(10)
      
      Divider()
      
      HStack {
        // cancel
        Spacer()
        Button("Cancel"){
          _editedText = ""
          textEntered = ""
          showAlert.toggle()
        }
        Spacer()
        
        Divider()
        
        // done
        Spacer()
        Button("Done") {
          textEntered = _editedText
          _editedText = ""
          self.showAlert.toggle()
        }
        
        Spacer()
      }
    }
    .frame(width: 300, height: 150)
    .background(Color.white)
    .cornerRadius(20)
    .shadow(radius: 10)
  }
}

struct AlertView_Previews: PreviewProvider {
  static var previews: some View {
    AlertView(textEntered: .constant(""), showAlert: .constant(true))
  }
}
