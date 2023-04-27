//
//  SearchViewController.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/01/30.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var titles = [Title]()
    
    /*
    private let searchTableView: UITableView = {
        
        let tableView = UITableView()
        tableView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        
        return tableView
    }()
    */
    
    private let searchController: UISearchController = {
        
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchBarStyle = .minimal
        
        return searchController
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // view.addSubview(searchTableView)
        
        // searchTableView.delegate = self
        // searchTableView.dataSource = self
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        
        view.backgroundColor = .systemBackground
        
        // fetchDiscoverMovies()
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        // searchTableView.frame = view.bounds
        
    }
    
    /*
    func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { result in
            switch result {
            case .success(let titles):
                self.titles = titles
                DispatchQueue.main.async {
                    
                    // self.searchTableView.reloadData()
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    */
}

/*
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // tableView's dequeueReusableCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else {
            return UITableViewCell()
        }
        let image_url = titles[indexPath.row].poster_path ?? ""
        let title = titles[indexPath.row].original_title ?? "Unknown name"
        
        cell.configure(model: TitleViewModel(poster_url: image_url, titleName: title))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
*/

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        resultController.delegate = self
        
        APICaller.shared.searchMovies(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultController.titles = titles
                    resultController.searchResultscollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func searchResultsViewControllerDidTapped(_ model: DetailViewModel) {
        DispatchQueue.main.async {
            let vc = DetailViewController()
            vc.configure(with: model)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
