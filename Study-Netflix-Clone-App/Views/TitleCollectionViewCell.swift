//
//  TitleCollectionViewCell.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/02/28.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        contentView.addSubview(posterImageView)
        
    }
    
    // 지정 생성자를 직접 구현했을 때만 필수적, NSCoding Protocol에 구현되어 있음, UIView: NSCodig임
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with model: String) {
        
        guard let url = URL(string: model) else { return }
        posterImageView.sd_setImage(with: url)
    }
}
