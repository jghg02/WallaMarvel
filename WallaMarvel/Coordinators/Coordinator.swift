//
//  Coordinator.swift
//  WallaMarvel
//
//  Created by Josue Hernandez on 6/2/25.
//

import UIKit
import SwiftUI

/// Base protocol for all coordinators
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func childDidFinish(_ child: Coordinator)
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }
}
