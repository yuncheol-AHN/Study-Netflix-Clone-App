//
//  SearchTableViewCell.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/03/12.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    static let identifier = "SearchTableViewCell"
    
    private let searchImage: UIImageView = {
        
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError()
    }
}
