  //
  //  ReminderApp.swift
  //  Reminder
  //
  //  Created by MANAS VIJAYWARGIYA on 31/08/22.
  //

import SwiftUI

@main
struct ReminderApp: App {
  let persistenceController = PersistenceController.shared
  
  var body: some Scene {
    WindowGroup {
      CategoryListView()
        .environmentObject(ReminderManager(context: persistenceController.container.viewContext))
    }
  }
}
