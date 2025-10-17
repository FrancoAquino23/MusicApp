//
//  APIService.swift
//  Music
//
//  Created by Fran on 17/10/25.
//

import Foundation
import Combine

class APIService: ObservableObject {

    private let clientID = ""
    private let clientSecret = ""
    
    @Published private(set) var accessToken: String?
    private var tokenExpirationDate: Date?
    
    func authenticate() async throws {
        if let token = accessToken, let expiration = tokenExpirationDate, expiration > Date() {
            print("Valid Token. No authentication required.")
            return
        }
        print("Starting authentication...")
        let credentials = "\(clientID):\(clientSecret)"
        guard let credentialData = credentials.data(using: .utf8) else {
            throw ErrorService.invalidCredentials
        }
        let base64Credentials = credentialData.base64EncodedString()
        guard let url = URL(string: "https://accounts.spotify.com/api/token") else {
            throw ErrorService.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body = "grant_type=client_credentials"
        request.httpBody = body.data(using: .utf8)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ErrorService.authenticationFailed
        }
        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
        DispatchQueue.main.async {
            self.accessToken = tokenResponse.accessToken
            self.tokenExpirationDate = Date().addingTimeInterval(Double(tokenResponse.expiresIn) - 300)
            print("Spotify token successfully obtained.")
        }
    }
    func searchTracks(query: String) async -> [Track] {
        guard let token = accessToken else {
            print("Error: No access token.")
            return []
        }
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return [] }
        let urlString = "https://api.spotify.com/v1/search?q=\(encodedQuery)&type=track&limit=20"
        guard let url = URL(string: urlString) else { return [] }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
            let tracks: [Track] = searchResponse.tracks.items.map { item in
                let artistName = item.artists.first?.name ?? "Unknown artist"
                return Track(id: item.id, name: item.name, artistName: artistName)
            }
            return tracks
        } catch {
            print("Error searching on Spotify: \(error.localizedDescription)")
            return []
        }
    }
}

struct SearchResponse: Decodable {
    let tracks: TracksContainer
}

struct TracksContainer: Decodable {
    let items: [SpotifyTrack]
}

struct SpotifyTrack: Decodable, Identifiable {
    let id: String
    let name: String
    let artists: [SpotifyArtist]
}

struct SpotifyArtist: Decodable, Identifiable {
    let id: String
    let name: String
}
