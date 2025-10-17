//
//  AppViewModel.swift
//  Music
//
//  Created by Fran on 17/10/25.
//

import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {

    let spotifyAPI: APIService
    
    @Published var isAuthenticated: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.spotifyAPI = APIService()
        spotifyAPI.$accessToken
            .receive(on: DispatchQueue.main)
            .map { token in
                return token != nil
            }
            .assign(to: \.isAuthenticated, on: self)
            .store(in: &cancellables)
    }
    func authenticate() async {
        do {
            try await spotifyAPI.authenticate()
        } catch {
            print("Authentication Error: \(error.localizedDescription)")
        }
    }
}
