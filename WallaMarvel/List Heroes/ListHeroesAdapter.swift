import Foundation
import UIKit

protocol ListHeroesAdapterDelegate: AnyObject {
    func shouldLoadMoreHeroes()
}

final class ListHeroesAdapter: NSObject, UITableViewDataSource {
    var heroes: [CharacterDataModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var isLoadingMore: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    private let tableView: UITableView
    weak var delegate: ListHeroesAdapterDelegate?

    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return isLoadingMore ? 2 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return heroes.count
        } else {
            return isLoadingMore ? 1 : 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListHeroesTableViewCell", for: indexPath) as! ListHeroesTableViewCell
            let model = heroes[indexPath.row]
            cell.configure(model: model)
            
            // Check if we should load more when near the end
            if indexPath.row >= heroes.count - 3 {
                delegate?.shouldLoadMoreHeroes()
            }
            
            return cell
        } else {
            // Loading more cell
            let cell = UITableViewCell(style: .default, reuseIdentifier: "LoadingCell")
            cell.textLabel?.text = "Loading more heroes..."
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.textColor = .secondaryLabel
            
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.startAnimating()
            cell.accessoryView = activityIndicator
            cell.selectionStyle = .none
            
            return cell
        }
    }
}
