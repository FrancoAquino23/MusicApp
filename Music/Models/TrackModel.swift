//
//  TrackModel.swift
//  Music
//
//  Created by Fran on 17/10/25.
//

import Foundation

struct Track: Identifiable, Codable {
    let id: String
    let name: String
    let artistName: String
    
    init(id: String, name: String, artistName: String) {
        self.id = id
        self.name = name
        self.artistName = artistName
    }
}
