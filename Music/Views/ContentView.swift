//
//  ContentView.swift
//  Music
//
//  Created by Fran on 17/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appViewModel = AppViewModel()

    var body: some View {
        if appViewModel.isAuthenticated {
            MainTabView()
                .environmentObject(appViewModel)
        } else {
            LoadingView()
                .task {
                    await appViewModel.authenticate()
                }
        }
    }
}
