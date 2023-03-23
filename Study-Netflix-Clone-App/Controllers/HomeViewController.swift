//
//  HomeViewController.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/01/30.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTvs = 1
    case PopularMovies = 2
    case UpcomingMovies = 3
    case TopRatedMovies = 4
}

class HomeViewController: UIViewController {
    
    let moviesTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top Rated"]
    
    private let homeFeedTable: UITableView = {
       
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
        return table
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(homeFeedTable)
        homeFeedTable.tableHeaderView = HeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func configureNavigationBar() {
        
        let image = UIImage(named: "NetflixLogo")?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil),
        ]
        navigationController?.navigationBar.tintColor = .black
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return moviesTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    // indexPath : [section, row]
    // 'cellForRowAt:' method는 화면에 cell이 나타날 때 실행된다.
    // 화면에서 사라지는 cell은 화면 -> queue로, 나타나는 cell은 queue -> 화면으로
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
            
        case Sections.TrendingMovies.rawValue:  // 0
            
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let data):
                    print("trending movies", data[0].original_title ?? "NONE")
                    cell.configure(with: data)
                case .failure(let err):
                    print(err)
                }
            }
        case Sections.TrendingTvs.rawValue: // 1
            
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let data):
                    print("trending tvs", data[0].original_title ?? "NONE")
                    cell.configure(with: data)
                case .failure(let err):
                    print(err)
                }
            }
        case Sections.PopularMovies.rawValue:   // 2
            
            APICaller.shared.getPopularMovies { result in
                switch result {
                case .success(let data):
                    print("popular movies", data[0].original_title ?? "NONE")
                    cell.configure(with: data)
                case .failure(let err):
                    print(err)
                }
            }
        case Sections.UpcomingMovies.rawValue:  // 3
            
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let data):
                    print("upcoming movies", data[0].original_title ?? "NONE")
                    cell.configure(with: data)
                case .failure(let err):
                    print(err)
                }
            }
        case Sections.TopRatedMovies.rawValue:
            
            APICaller.shared.getTopRatedMovies { result in
                switch result {
                case .success(let data):
                    print("top rated movies", data[0].original_title ?? "NONE")
                    cell.configure(with: data)
                case .failure(let err):
                    print(err)
                }
            }
        default:
            break
        }
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset // contentOffset : bounds 값 결정
        
        // print(defaultOffset, scrollView.contentOffset.y, offset)
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return moviesTitles[section]
    }
    
    // cell이 등장할 때 실행, view는 cell's header, section은 index
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        // view contain frame, text, autoresize, layer, textLabel
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .black
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: DetailViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = DetailViewController()
            vc.configure(with: viewModel)
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
