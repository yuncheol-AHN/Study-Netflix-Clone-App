//
//  UpcomingViewController.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/01/30.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    private let tableView: UITableView = {
        
        let table = UITableView()
        table.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(tableView)
    
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchData() {
        
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    
                    self?.tableView.reloadData()
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // UpcomingTableViewCell의 메소드를 사용하기 위한 다운캐스팅
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else { return UpcomingTableViewCell() }
        
        let image_url = titles[indexPath.row].poster_path ?? "EMPTY"
        let title = titles[indexPath.row].original_title ?? "EMPTY"
        
        cell.configure(model: TitleViewModel(poster_url: image_url, titleName: title))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        APICaller.shared.getTrailerVideo(with: titleName + " trailer") { [weak self] result in
            
            switch result {
            case .success(let videoElement):
                
                DispatchQueue.main.async {
                    let vc = DetailViewController()
                    vc.configure(with: DetailViewModel(title: titleName, titleOverview: title.overview ?? "nothing", youtubeView: videoElement))
                    
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
