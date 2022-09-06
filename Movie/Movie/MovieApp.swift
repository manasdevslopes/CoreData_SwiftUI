  //
  //  MovieApp.swift
  //  Movie
  //
  //  Created by MANAS VIJAYWARGIYA on 06/09/22.
  //

import SwiftUI

@main
struct MovieApp: App {
  // MARK: - Seventh step
//  let context = PersistenceManager().container.viewContext
  let movieManager = MovieManagerViewModel(context: PersistenceManager().container.viewContext)
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(movieManager)
    }
  }
}
