//
//  SearchView.swift
//  Music
//
//  Created by Fran on 17/10/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Searching...")
                        .padding(.top, 50)
                } else if viewModel.searchText.isEmpty {
                    Text("Search songs, artists or albums.")
                        .foregroundColor(.gray)
                        .padding(.top, 50)
                } else if viewModel.searchResults.isEmpty {
                    Text("No results found for '\(viewModel.searchText)'.")
                        .foregroundColor(.gray)
                        .padding(.top, 50)
                } else {
                    List {
                        ForEach(viewModel.searchResults) { track in
                            TrackView(track: track)
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Songs, artists or podcasts")
            .onChange(of: viewModel.searchText) { _, _ in
                Task {
                    await viewModel.performSearch()
                }
            }
        }
    }
}
