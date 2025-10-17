//
//  MainView.swift
//  Music
//
//  Created by Fran on 17/10/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        TabView {
            SearchView(viewModel: SearchViewModel(apiService: appViewModel.spotifyAPI))
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            Text("Library")
                .tabItem {
                    Label("Library", systemImage: "music.note.list")
                }
            Text("Profile")
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
        .accentColor(.green)
    }
}
