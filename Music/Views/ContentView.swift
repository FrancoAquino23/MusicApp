//
//  ContentView.swift
//  Music
//
//  Created by Fran on 17/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appViewModel = AppViewModel()
    @StateObject private var playerService = PlayerService()
    var body: some View {
        if appViewModel.isAuthenticated {
            ZStack(alignment: .bottom) {
                MainTabView()
                    .environmentObject(appViewModel)
                    .environmentObject(playerService)
                PlayerView()
                    .environmentObject(playerService)
            }
        } else {
            LoadingView()
                .task {
                    await appViewModel.authenticate()
                }
        }
    }
}
