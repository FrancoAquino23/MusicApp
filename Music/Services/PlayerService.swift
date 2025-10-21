//
//  PlayerService.swift
//  Music
//
//  Created by Fran on 20/10/25.
//

import Foundation
import Combine
import AVFoundation

class PlayerService: ObservableObject {
    private var player: AVPlayer?
    @Published var isPlaying: Bool = false
    @Published var currentTrack: Track?

    init() {
        setupAudioSession()
    }
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            print("AVAudioSession configured")
        } catch {
            print("(Error) - AVAudioSession configuration: \(error.localizedDescription)")
        }
    }
    
    func play(track: Track) {
        stop()
        try? AVAudioSession.sharedInstance().setActive(true)
        guard let urlString = track.previewURL, let url = URL(string: urlString) else {
            print("(Error) - No URL preview")
            self.isPlaying = false
            self.currentTrack = nil
            return
        }
        self.player = AVPlayer(url: url)
        self.player?.play()
        self.isPlaying = true
        self.currentTrack = track
        print("Playing preview \(track.name) - \(track.artistName) from \(urlString)")
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: self.player?.currentItem
        )
    }
    
    func pause() {
        self.player?.pause()
        self.isPlaying = false
        print("Playback paused")
    }
    
    func stop() {
        self.player?.pause()
        self.player = nil
        self.isPlaying = false
        self.currentTrack = nil
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        print("Playback stopped")
    }
    @objc private func playerDidFinishPlaying(note: Notification) {
        print("End of track preview")
        stop()
    }
}
