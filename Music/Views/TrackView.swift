//
//  TrackView.swift
//  Music
//
//  Created by Fran on 17/10/25.
//

import SwiftUI

struct TrackView: View {
    let track: Track

    var body: some View {
        HStack {
            Image(systemName: "music.note.list")
                .resizable()
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .foregroundColor(.green)
                .background(Color.gray.opacity(0.1))
            
            VStack(alignment: .leading) {
                Text(track.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(track.artistName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            Image(systemName: "ellipsis")
                .foregroundColor(.gray)
        }
        .contentShape(Rectangle())
    }
}
