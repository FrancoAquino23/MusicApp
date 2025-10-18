//
//  ArtistModel.swift
//  Music
//
//  Created by Fran on 17/10/25.
//

import Foundation

struct ArtistModel: Identifiable, Decodable {
    let id: String
    let name: String
    let imageURL: String?
    let genres: [String]
    let followers: Int?
    
    init(id: String, name: String, imageURL: String?, genres: [String], followers: Int?) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.genres = genres
        self.followers = followers
    }
}
