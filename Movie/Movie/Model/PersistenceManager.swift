  //
  //  PersistenceManager.swift
  //  Movie
  //
  //  Created by MANAS VIJAYWARGIYA on 06/09/22.
  //

import Foundation
import CoreData

struct PersistenceManager {
  let container : NSPersistentContainer
  
  init() {
    container = NSPersistentContainer(name: "Movie")
    container.loadPersistentStores { store, error in
      if let error = error as NSError? {
        fatalError("Error load \(store): \(error.localizedDescription)")
      }
    }
    checkData()
  }
  
  // MARK: - First step
  private func checkData() {
    let context = container.viewContext
    let request : NSFetchRequest<Movie> = Movie.fetchRequest()
    
    if let movieCount = try? context.count(for: request), movieCount > 0 {
      return
    }
    
    uploadSampleData()
  }
  
  // MARK: - Sixth step
  private func uploadSampleData() {
    guard let url = Bundle.main.url(forResource: "movies", withExtension: "json"),
    let data = try? Data(contentsOf: url),
    let codingUserKeyContext = CodingUserInfoKey.codingUserKeyContext else { return }
    
    do {
      let context = container.viewContext
      let decoder = JSONDecoder()
      
      decoder.userInfo[codingUserKeyContext] = context
      
      let _ = try decoder.decode([Movie].self, from: data)
      
      try context.save()
    } catch let error {
      print("Error parsing: \(error.localizedDescription)")
    }
  }
}
