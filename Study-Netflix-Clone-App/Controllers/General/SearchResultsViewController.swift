//
//  SearchResultsViewController.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/03/13.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    
    func searchResultsViewControllerDidTapped(_ model: DetailViewModel)
}

class SearchResultsViewController: UIViewController {
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    public var titles: [Title] = [Title]()
    
    public let searchResultscollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchResultscollectionView)
        
        searchResultscollectionView.delegate = self
        searchResultscollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        searchResultscollectionView.frame = view.bounds
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return TitleCollectionViewCell() }
        
        let path = titles[indexPath.row].poster_path ?? ""
        let image_url = "https://image.tmdb.org/t/p/w500/\(path)"
        cell.configure(with: image_url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        APICaller.shared.getTrailerVideo(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                
                self?.delegate?.searchResultsViewControllerDidTapped(DetailViewModel(title: titleName, titleOverview: title.overview ?? "nothing", youtubeView: videoElement))
            case.failure(let error):
                print(error)
            }
        }
    }
}
