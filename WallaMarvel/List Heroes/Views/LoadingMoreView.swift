//
//  LoadingMoreView.swift
//  WallaMarvel
//
//  Created by Josue Hernandez on 6/2/25.
//

import SwiftUI

/// Loading more view at the bottom of the list
struct LoadingMoreView: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
                .scaleEffect(0.8)
            Text("Loading more heroes...")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}
