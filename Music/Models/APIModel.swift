//
//  APIModel.swift
//  Music
//
//  Created by Fran on 18/10/25.
//

import Foundation

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
    let album: SpotifyAlbum
    let preview_url: String?
}

struct SpotifyAlbum: Decodable {
    let name: String
    let images: [ImageObject]
}

struct ImageObject: Decodable {
    let url: String
    let height: Int?
    let width: Int?
}

struct SpotifyArtist: Decodable, Identifiable {
    let id: String
    let name: String
}
