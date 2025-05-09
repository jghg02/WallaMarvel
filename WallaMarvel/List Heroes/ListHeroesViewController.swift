import UIKit
import SwiftUI
import Combine

final class ListHeroesViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: ListHeroesViewModel!
    private var hostingController: UIHostingController<ListHeroesSwiftUIView>?
    
    // MARK: - Initialization
    convenience init(viewModel: ListHeroesViewModel = ListHeroesViewModel()) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ListHeroesViewModel()
        setupSwiftUIView()
    }
    
    // MARK: - Setup
    private func setupSwiftUIView() {
        // Create SwiftUI view with the ViewModel
        let swiftUIView = ListHeroesSwiftUIView(viewModel: viewModel)
        
        // Create hosting controller
        let hostingController = UIHostingController(rootView: swiftUIView)
        self.hostingController = hostingController
        
        // Add as child view controller
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        // Setup constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    // MARK: - Deinitialization
    deinit {
        hostingController?.removeFromParent()
    }
}
