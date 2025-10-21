//
//  PlayerView.swift
//  Music
//
//  Created by Fran on 17/10/25.
//

import SwiftUI
import Combine

struct PlayerView: View {
    @EnvironmentObject var playerService: PlayerService
    var body: some View {
        if let track = playerService.currentTrack {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(height: 1)
                HStack(spacing: 15) {
                    AlbumArtMiniView(track: track)
                    VStack(alignment: .leading) {
                        Text(track.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        Text(track.artistName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    Spacer()
                    PlaybackButton(playerService: playerService)
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(UIColor.systemBackground))
            }
        }
    }
}

private struct PlaybackButton: View {
    @ObservedObject var playerService: PlayerService
    var body: some View {
        Button {
            if playerService.isPlaying {
                playerService.pause()
            } else {
                if let track = playerService.currentTrack, let urlString = track.previewURL {
                    playerService.play(track: track)
                }
            }
        } label: {
            Image(systemName: playerService.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.blue)
        }
    }
}

private struct AlbumArtMiniView: View {
    let track: Track
    @StateObject private var imageLoader: ImageLoaderService
    init(track: Track) {
        self.track = track
        _imageLoader = StateObject(wrappedValue: ImageLoaderService(urlString: track.imageURL ?? ""))
    }
    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "music.note")
                            .foregroundColor(.gray)
                    )
            }
        }
        .frame(width: 40, height: 40)
        .cornerRadius(4)
        .onChange(of: track.id) {
            imageLoader.load()
        }
    }
}
