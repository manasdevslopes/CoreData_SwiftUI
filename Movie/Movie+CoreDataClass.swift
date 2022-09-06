//
//  Movie+CoreDataClass.swift
//  Movie
//
//  Created by MANAS VIJAYWARGIYA on 06/09/22.
//
//

import UIKit
import CoreData
import SwiftUI

@objc(Movie)
public class Movie: NSManagedObject, Decodable {
  // MARK: - Third step
  enum CodingKeys: CodingKey {
    case name, rating, image, format
  }
  
  // MARK: - Tenth step - Compute Property
  var pngImage: Image? {
    if let imageData = self.image,
       let image = UIImage(data: imageData) {
      return Image(uiImage: image)
    }
    return nil
  }
  
  // MARK: - Fourth step
  required convenience public init(from decoder: Decoder) throws {
    guard let userInfoContext = CodingUserInfoKey.codingUserKeyContext,
          let context = decoder.userInfo[userInfoContext] as? NSManagedObjectContext
    else { fatalError("Failed to get NSManagedObjectContext") }
    
    self.init(context: context)
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = UUID()
    self.name = try container.decode(String.self, forKey: .name)
    self.format = try container.decode(String.self, forKey: .format)
    self.rating = try container.decode(Int16.self, forKey: .rating)
    
    // MARK: - Fifth step - check image and convert it into Data
    if let imageName = try container.decodeIfPresent(String.self, forKey: .image),
       let image = UIImage(named: imageName),
       let imageData = image.pngData() {
      // This self.image is CoreData Movie Entity's Attribute
      self.image = imageData
    }
  }
}
