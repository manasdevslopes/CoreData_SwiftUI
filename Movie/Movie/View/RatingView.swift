//
//  RatingView.swift
//  Movie
//
//  Created by MANAS VIJAYWARGIYA on 06/09/22.
//

import SwiftUI

struct RatingView: View {
  @EnvironmentObject private var movieManager: MovieManagerViewModel
  
  var movie: Movie
  
    var body: some View {
      HStack(spacing: 0) {
        ForEach(0..<5) {idx in
          Image(idx < movie.rating ? "yellowstar" : "blackstar")
            .resizable()
            .frame(width: 20, height: 20, alignment: .center)
            .onTapGesture {
              movie.rating = Int16(idx + 1)
              movieManager.update(movie)
            }
        }
      }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(movie: Movie())
    }
}
