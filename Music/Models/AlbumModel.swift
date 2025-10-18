//
//  AlbumModel.swift
//  Music
//
//  Created by Fran on 17/10/25.
//

import Foundation

struct AlbumModel: Identifiable, Decodable {
    let id: String
    let name: String
    let releaseDate: String
    let albumType: String
    let imageURL: String?
    let artistNames: String
    
    init(id: String, name: String, releaseDate: String, albumType: String, imageURL: String?, artistNames: String) {
        self.id = id
        self.name = name
        self.releaseDate = releaseDate
        self.albumType = albumType
        self.imageURL = imageURL
        self.artistNames = artistNames
    }
}
