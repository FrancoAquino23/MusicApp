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
    let previewURL: String?
    
    init(id: String, name: String, artistName: String, albumName: String, imageURL: String?, previewURL: String?) {
        self.id = id
        self.name = name
        self.artistName = artistName
        self.albumName = albumName
        self.imageURL = imageURL
        self.previewURL = previewURL
    }
}
