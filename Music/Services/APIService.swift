//
//  APIService.swift
//  Music
//
//  Created by Fran on 17/10/25.
//

import Foundation
import Combine
import SwiftUI

class APIService: ObservableObject {
    private let clientID = ""
    private let clientSecret = ""
    private let testAudioURL = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
    @Published private(set) var accessToken: String?
    private var tokenExpirationDate: Date?
    
    func authenticate() async throws {
        if let token = accessToken, let expiration = tokenExpirationDate, expiration > Date() {
            print("Valid Token")
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
        var receivedData: Data? = nil
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            receivedData = data
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw ErrorService.authenticationFailed
            }
            let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
            await MainActor.run {
                self.accessToken = tokenResponse.accessToken
                self.tokenExpirationDate = Date().addingTimeInterval(Double(tokenResponse.expiresIn) - 300)
                print("Token successfully obtained")
            }
            
        } catch {
            if let data = receivedData, let jsonString = String(data: data, encoding: .utf8) {
                 print("RAW data recieved - (Error): \(jsonString)")
            }
            throw error
        }
    }
        
    func searchTracks(query: String) async -> [Track] {
        guard let token = accessToken else {
            print("(Error) - No access token")
            return []
        }
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return [] }
        let urlString = "https://api.spotify.com/v1/search?q=\(encodedQuery)&type=track&limit=20"
        guard let url = URL(string: urlString) else { return [] }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("\n--- RAW JSON RESPONSE ---\n\(jsonString)\n-------------------------\n")
            }
            let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
            let tracks: [Track] = searchResponse.tracks.items.map { item in
                let artistName = item.artists.first?.name ?? "Unknown artist"
                let imageUrl = item.album.images.first(where: { $0.width == 64 })?.url
                ?? item.album.images.first?.url
                let finalPreviewURL = item.preview_url ?? self.testAudioURL
                return Track(id: item.id, name: item.name, artistName: artistName,
                    albumName: item.album.name, imageURL: imageUrl, previewURL: finalPreviewURL)
            }
            return tracks
        } catch {
            print("(Error) - Searching on Spotify: \(error.localizedDescription)")
            return []
        }
    }
}
