//
//  HeroesListView.swift
//  WallaMarvel
//
//  Created by Josue Hernandez on 6/2/25.
//

import SwiftUI

/// List view displaying the heroes with pagination support
struct HeroesListView: View {
    @ObservedObject var viewModel: ListHeroesViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            SearchBar(text: $viewModel.searchText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            // Heroes Content
            HeroesContentView(viewModel: viewModel)
        }
    }
}

/// Content view for the heroes list without search bar
struct HeroesContentView: View {
    @ObservedObject var viewModel: ListHeroesViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.heroes, id: \.id) { hero in
                HeroRowView(hero: hero)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .onTapGesture {
                        print("Selected hero: \(hero.name)")
                        viewModel.didSelectHero(hero)
                    }
                    .onAppear {
                        // KEY PAGINATION TRIGGER: Load more when this item appears and we're near the end
                        if viewModel.shouldLoadMore(currentItem: hero) {
                            viewModel.loadMoreHeroes()
                        }
                    }
            }
            
            // Loading more indicator at the bottom
            if viewModel.isLoadingMore {
                LoadingMoreView()
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
            }
            
            // End of list detector - Alternative pagination trigger
            Color.clear
                .frame(height: 1)
                .onAppear {
                    if !viewModel.isLoadingMore && !viewModel.isLoading {
                        print("Reached end of list, checking if should load more...")
                        viewModel.loadMoreHeroes()
                    }
                }
        }
        .listStyle(PlainListStyle())
        }
    }
