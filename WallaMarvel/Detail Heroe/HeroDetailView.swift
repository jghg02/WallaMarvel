//
//  HeroDetailView.swift
//  WallaMarvel
//
//  Created by Josue Hernandez on 6/2/25.
//

import SwiftUI

struct HeroDetailView: View {
    @StateObject private var viewModel: HeroDetailViewModel
    
    init(viewModel: HeroDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                // Loading state
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Loading hero details...")
                        .padding(.top)
                        .foregroundColor(.secondary)
                }
            } else if let errorMessage = viewModel.errorMessage {
                // Error state
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                    
                    Text("Error")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    Button("Retry") {
                        viewModel.retryLoading()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            } else {
                // Content state
                heroContentView
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var heroContentView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Hero Image
                AsyncImage(url: viewModel.heroImageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            ProgressView()
                        )
                }
                .frame(height: 300)
                .clipped()
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                
                VStack(alignment: .leading, spacing: 16) {
                    // Hero Name
                    Text(viewModel.heroName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    // Hero Description
                    if !viewModel.hero.description.isEmpty {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(viewModel.hero.description)
                            .font(.body)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                // Hero Stats
                VStack(alignment: .leading, spacing: 8) {
                    Text("Character Information")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("ID:")
                            .fontWeight(.medium)
                        Text("#\(viewModel.hero.id)")
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    
                    // Add more details from the full hero data
                    if let comics = viewModel.hero.comics, comics.available > 0 {
                        HStack {
                            Text("Comics:")
                                .fontWeight(.medium)
                            Text("\(comics.available) available")
                                .foregroundColor(.green)
                            Spacer()
                        }
                    }
                    
                    if let series = viewModel.hero.series, series.available > 0 {
                        HStack {
                            Text("Series:")
                                .fontWeight(.medium)
                            Text("\(series.available) available")
                                .foregroundColor(.orange)
                            Spacer()
                        }
                    }
                    
                    if let events = viewModel.hero.events, events.available > 0 {
                        HStack {
                            Text("Events:")
                                .fontWeight(.medium)
                            Text("\(events.available) available")
                                .foregroundColor(.purple)
                            Spacer()
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}


// MARK: - Preview
struct HeroDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleHero = CharacterDataModel(
            id: 1009610,
            name: "Spider-Man",
            description: "Bitten by a radioactive spider, high school student Peter Parker gained the speed, strength and powers of a spider. Adopting the name Spider-Man, Peter hoped to start a career using his new abilities. Taught that with great power comes great responsibility, Spidey has vowed to use his powers to help people.",
            thumbnail: Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/3/50/526548a343e4b", extension: "jpg")
        )
        
        let viewModel = HeroDetailViewModel(hero: sampleHero)
        HeroDetailView(viewModel: viewModel)
    }
}
