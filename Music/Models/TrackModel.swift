//
//  TrackModel.swift
//  Music
//
//  Created by Fran on 17/10/25.
//

import Foundation

struct Track: Identifiable, Decodable {
    let id: String
    let name: String
    let artistName: String
    let albumName: String
    let imageURL: String?

    init(id: String, name: String, artistName: String, albumName: String, imageURL: String?) {
        self.id = id
        self.name = name
        self.artistName = artistName
        self.albumName = albumName
        self.imageURL = imageURL
    }
}
