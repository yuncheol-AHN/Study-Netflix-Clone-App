//
//  DownloadsViewController.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/01/30.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var titles: [TitleItem] = [TitleItem]()
    
    private let tableView: UITableView = {
        
        let table = UITableView()
        table.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    
        title = "Download"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchingFromLocalStorage()
    }
    
    // 탭 이동 시 data reload
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        viewDidLoad()
    }
    
    private func fetchingFromLocalStorage() {
        
        DataPersistenceManager.shared.fetchingTitleFromDatabase { [weak self] result in
            
            switch result {
            case.success(let titles):
                
                self?.titles = titles
                self?.tableView.reloadData()
            case.failure(let error):
                
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension DownloadsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else { return UITableViewCell() }
        
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? title.original_name ?? "NONE"
        cell.configure(model: TitleViewModel(poster_url: title.poster_path ?? "", titleName: titleName))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            
            DataPersistenceManager.shared.deleteTitleFromDatabase(model: titles[indexPath.row]) { [weak self] result in
                
                switch result {
                case .success():
                    print("delete success")
                case .failure(let err):
                    print(err.localizedDescription)
                }
                
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
}
