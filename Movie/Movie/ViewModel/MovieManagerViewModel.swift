//
//  MovieManagerViewModel.swift
//  Movie
//
//  Created by MANAS VIJAYWARGIYA on 06/09/22.
//

import Foundation
import CoreData

// MARK: - Eigth step
class MovieManagerViewModel: NSObject, ObservableObject {
  @Published var movies: [Movie] = []
  @Published var sections: [String: [Movie]] = [:]
  
  private let _context: NSManagedObjectContext
  private let _fetchedResultController: NSFetchedResultsController<Movie>
  
  init(context: NSManagedObjectContext) {
    self._context = context
    
    let request: NSFetchRequest<Movie> = Movie.fetchRequest()
    request.sortDescriptors = [
      NSSortDescriptor(keyPath: \Movie.format, ascending: false),
      NSSortDescriptor(keyPath: \Movie.name, ascending: true)
    ]
    
    self._fetchedResultController = NSFetchedResultsController(fetchRequest: request,
                                                               managedObjectContext: self._context,
                                                               sectionNameKeyPath: #keyPath(Movie.format),
                                                               cacheName: "MovieList")
    // cacheName means when the core data loads it will take values from cche. This is helpful when large data set present. Otherwise we cab give nil
    
    
    super.init()
    
    self._fetchedResultController.delegate = self
    
    loadMovie()
  }
  
  // MARK: - Nineth step
  private func loadMovie() {
    do {
      try self._fetchedResultController.performFetch()
      
      if let sections = _fetchedResultController.sections, !sections.isEmpty {
        // self.sections = sections.map { $0.name }
        for section in sections {
          if let movies = section.objects as? [Movie] {
            self.sections[section.name] = movies
          }
        }
      }
      
      movies = self._fetchedResultController.fetchedObjects ?? []
    } catch  {
      print("Error fetching movies: \(error.localizedDescription)")
    }
  }
  
  // MARK: - Eleventh step
  func save() {
    if self._context.hasChanges {
      do {
        try self._context.save()
      } catch  {
        fatalError("Error Saving Data: \(error.localizedDescription)")
      }
    }
  }
  
  func update(_ movie: Movie) {
    save()
  }
  
  // MARK: - Reset Function
  func resetRating() {
    for movie in movies {
      movie.rating = 0
    }
    save()
  }
  
  // MARK: - Batch Reset Function
  func batchReset() {
    let request = NSBatchUpdateRequest(entityName: "Movie")
    request.propertiesToUpdate = [#keyPath(Movie.rating): 0]
    request.affectedStores = _context.persistentStoreCoordinator?.persistentStores
    request.resultType = .updatedObjectsCountResultType
    
    do {
      let batchResult = try _context.execute(request) as? NSBatchUpdateResult
      print("Batch Update: \(batchResult?.result ?? "")")
      
      _context.reset()
      loadMovie()
      
    } catch {
      print("Error Rating Batch Update: \(error.localizedDescription)")
    }
  }
}

// MARK: - Twelveth step - write NSObject and super.init() and self._fetchedResultController.delegate = self in init() {}
// then create delegate method

extension MovieManagerViewModel: NSFetchedResultsControllerDelegate {
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    guard let updatedMovies = controller.fetchedObjects as? [Movie] else { return }
    
    movies = updatedMovies
  }
}
