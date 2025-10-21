//
//  TrackView.swift
//  Music
//
//  Created by Fran on 17/10/25.
//

import SwiftUI

struct TrackView: View {
    let track: Track
    @EnvironmentObject var playerService: PlayerService
    @StateObject private var imageLoader: ImageLoaderService
    init(track: Track) {
        self.track = track
        _imageLoader = StateObject(wrappedValue: ImageLoaderService(urlString: track.imageURL ?? ""))
    }
    private var isCurrentTrack: Bool {
        playerService.currentTrack?.id == track.id
    }
    var body: some View {
        HStack(spacing: 12) {
            AlbumArtView(imageLoader: imageLoader)
            VStack(alignment: .leading) {
                Text(track.name)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundColor(isCurrentTrack ? .blue : .primary)
                Text("\(track.artistName) • \(track.albumName)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            Spacer()
            if isCurrentTrack && playerService.isPlaying {
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundColor(.blue)
                    .font(.title3)
            } else {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
        .onTapGesture {
            if isCurrentTrack && playerService.isPlaying {
                playerService.pause()
            } else {
                playerService.play(track: track)
            }
        }
    }
}

private struct AlbumArtView: View {
    @ObservedObject var imageLoader: ImageLoaderService
    private let size: CGFloat = 50
    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                    if imageLoader.image == nil {
                        Image(systemName: "music.note.list")
                            .foregroundColor(.gray)
                            .font(.title3)
                    } else {
                        ProgressView()
                    }
                }
            }
        }
        .frame(width: size, height: size)
        .cornerRadius(4)
    }
}
