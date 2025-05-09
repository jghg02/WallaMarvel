//
//  SearchEmptyStateView.swift
//  WallaMarvel
//
//  Created by Josue Hernandez on 6/2/25.
//

import SwiftUI

/// Empty state view when no search results are found
struct SearchEmptyStateView: View {
    let searchTerm: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            VStack(spacing: 8) {
                Text("No Results Found")
                    .font(.headline)
                
                Text("No heroes found for \"\(searchTerm)\"")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text("Try adjusting your search terms")
                    .font(.caption)
            }
        }
        .padding()
    }
}

// MARK: - Preview
struct SearchEmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        SearchEmptyStateView(searchTerm: "Spider")
    }
}
