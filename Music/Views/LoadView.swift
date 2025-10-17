//
//  LoadView.swift
//  Music
//
//  Created by Fran on 17/10/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .green))
                .scaleEffect(2.0)
            Text("Connecting with Spotify...")
                .font(.headline)
                .padding()
        }
    }
}
