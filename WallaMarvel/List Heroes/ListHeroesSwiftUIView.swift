//
//  ListHeroesSwiftUIView.swift
//  WallaMarvel
//
//  Created by Josue Hernandez on 6/2/25.
//

import SwiftUI
import Combine

struct ListHeroesSwiftUIView: View {
    
    @StateObject private var viewModel: ListHeroesViewModel
    
    init(viewModel: ListHeroesViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar - Always visible at the top
            SearchBar(text: $viewModel.searchText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            // Main Content Area
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                if viewModel.isLoading && viewModel.heroes.isEmpty && viewModel.searchText.isEmpty {
                    LoadingView()
                } else if let errorMessage = viewModel.errorMessage, viewModel.heroes.isEmpty && viewModel.searchText.isEmpty {
                    ErrorStateView(
                        message: errorMessage,
                        onRetry: viewModel.retryFetchHeroes
                    )
                } else if viewModel.heroes.isEmpty && !viewModel.isLoading {
                    if !viewModel.searchText.isEmpty {
                        SearchEmptyStateView(searchTerm: viewModel.searchText)
                    } else {
                        EmptyStateView()
                    }
                } else {
                    HeroesContentView(viewModel: viewModel)
                }
            }
        }
        .onAppear {
            if viewModel.heroes.isEmpty && viewModel.searchText.isEmpty {
                viewModel.fetchHeroes()
            }
        }
        .refreshable {
            viewModel.fetchHeroes()
        }
    }
}


/// UIViewControllerRepresentable wrapper for UIKit integration
struct ListHeroesSwiftUIWrapper: UIViewControllerRepresentable {
    let viewModel: ListHeroesViewModel
    
    func makeUIViewController(context: Context) -> UIHostingController<ListHeroesSwiftUIView> {
        let swiftUIView = ListHeroesSwiftUIView(viewModel: viewModel)
        return UIHostingController(rootView: swiftUIView)
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<ListHeroesSwiftUIView>, context: Context) {
        // No updates needed for now
    }
}

