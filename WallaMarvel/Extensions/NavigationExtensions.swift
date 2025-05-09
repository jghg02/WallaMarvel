//
//  NavigationController.swift
//  WallaMarvel
//
//  Created by Josue Hernandez on 6/2/25.
//

import UIKit

extension UINavigationController {
    /// Convenience method to set up navigation appearance
    func setupMarvelAppearance() {
        navigationBar.prefersLargeTitles = true
        navigationBar.tintColor = .systemRed
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
}
