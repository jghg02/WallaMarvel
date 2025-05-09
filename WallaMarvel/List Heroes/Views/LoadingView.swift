//
//  LoadingView.swift
//  WallaMarvel
//
//  Created by Josue Hernandez on 6/2/25.
//

import SwiftUI

/// Loading state view with activity indicator
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading Heroes...")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
    }
}
