//
//  EmptyStateView.swift
//  WallaMarvel
//
//  Created by Josue Hernandez on 6/2/25.
//

import SwiftUI

/// Empty state view when no heroes are found
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.3")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            VStack(spacing: 8) {
                Text("No Heroes Found")
                    .font(.headline)
                
                Text("There are no heroes to display at the moment.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}
