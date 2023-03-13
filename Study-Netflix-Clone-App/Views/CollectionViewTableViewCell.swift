//
//  CollectionViewTableViewCell.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/01/31.
//

import UIKit

// cell을 만들 때, init을 생성해야함
class CollectionViewTableViewCell: UITableViewCell {
    
    // 인스턴스 프로퍼티 vs 스태틱(타입) 프로퍼티 : 인스턴스 생성후 사용가능 vs 인스턴스 생성없이 사용가능
    // static(오버라이딩 불가) -> class(오버라이딩 가능) 대체 가능
    // 인스턴스 위에서 타입 프로퍼티 사용불가
    static let identifier = "CollectionViewTableViewCell"
    
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
            self?.collectionView.reloadData()
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
}
