//
//  CollectionViewTableViewCell.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/01/31.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: DetailViewModel)
}

// cell을 만들 때, init(), layoutSubviews() 생성
class CollectionViewTableViewCell: UITableViewCell {
    
    // 인스턴스 프로퍼티 vs 스태틱(타입) 프로퍼티 : 인스턴스 생성후 사용가능 vs 인스턴스 생성없이 사용가능
    // static(오버라이딩 불가) -> class(오버라이딩 가능) 대체 가능
    // 인스턴스 위에서 타입 프로퍼티 사용불가
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles: [Title] = [Title]()
    
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init(coder: NSCoder) {
        
        fatalError()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with titles: [Title]) {
        
        self.titles = titles
        
        DispatchQueue.main.async { [weak self] in
            // reloadData() call 'cellForItemAt:', 'numberOfItemsInSection:' methods
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexPaths: [IndexPath]) {
        
        DataPersistenceManager.shared.downloadTitleWith(model: titles[indexPaths[0][1]]) { result in
            switch result {
            case .success():
                print("download success")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .systemGreen
        
        
        guard let poster_url = titles[indexPath.row].poster_path else { return UICollectionViewCell() }
        cell.configure(with: "https://image.tmdb.org/t/p/w500/\(poster_url)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] result in
            
            switch result {
            case .success(let videoElement):
                
                let title = self?.titles[indexPath.row].original_title ?? self?.titles[indexPath.row].original_name
                guard let titleOverview = self?.titles[indexPath.row].overview else { return }
                let viewModel = DetailViewModel(title: title ?? " ", titleOverview: titleOverview, youtubeView: videoElement)
                guard let strongSelf = self else { return }
                
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // indexPaths : row, col
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download") { [weak self] _ in
                self?.downloadTitleAt(indexPaths: indexPaths)
            }
            
            return UIMenu(title: "", children: [downloadAction])
        }
        
        return config
    }
}
