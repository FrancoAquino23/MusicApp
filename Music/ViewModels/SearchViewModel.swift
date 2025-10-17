//
//  SearchViewModel.swift
//  Music
//
//  Created by Fran on 17/10/25.
//

import Foundation
import Combine
import SwiftUI

class SearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published private(set) var searchResults: [Track] = []
    @Published private(set) var isLoading: Bool = false
    
    private let apiService: APIService
    private var cancellables = Set<AnyCancellable>()

    init(apiService: APIService) {
        self.apiService = apiService
        
        $searchText
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .filter { !$0.isEmpty }
            .sink { [weak self] _ in
                self?.performSearch()
            }
            .store(in: &cancellables)
    }
    
    public func performSearch() {
        let query = self.searchText
        guard !query.isEmpty else {
            self.searchResults = []
            return
        }
        Task {
            await MainActor.run {
                self.isLoading = true
                self.searchResults = []
            }
            let results = await apiService.searchTracks(query: query)
            await MainActor.run {
                self.searchResults = results
                self.isLoading = false
            }
        }
    }
}
