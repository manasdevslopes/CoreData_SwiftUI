  //
  //  ContentView.swift
  //  Movie
  //
  //  Created by MANAS VIJAYWARGIYA on 06/09/22.
  //

import SwiftUI

struct ContentView: View {
  @EnvironmentObject private var _manager: MovieManagerViewModel
  
  var body: some View {
    NavigationView {
      List {
        ForEach(Array(_manager.sections.keys.sorted(by: >)), id: \.self) { section in
          Section {
            ForEach(_manager.sections[section] ?? [], id: \.id) { movie in
              HStack(alignment: .center, spacing: 20) {
                movie.pngImage
                
                VStack(alignment: .leading) {
                  Text(movie.name ?? "")
                    .font(.title3)
                    .fontWeight(.semibold)
                  
                  RatingView(movie: movie)
                }
              }
            }
          } header: {
            Text(section.uppercased())
          }

        }
      }
      .listStyle(InsetListStyle())
      .navigationBarItems(trailing: Button(action: { //_manager.resetRating()
        _manager.batchReset()
      },
                                           label: {
        HStack(spacing: 2) {
          Text("Reset")
          Image("yellowstar")
            .resizable()
            .frame(width: 15, height: 15, alignment: .center)
            .offset(y: -1)
        }
      }))
      .navigationBarTitle("Movie Library")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
