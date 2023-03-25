//
//  UpcomingTableViewCell.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/03/06.
//

import UIKit

protocol UpcomingTableViewCellDelegate: AnyObject {
    
    func UpcomingTableViewCellDidTapped(_ model: DetailViewModel)
}

class UpcomingTableViewCell: UITableViewCell {
    
    static let identifier = "UpcomingTableViewCell"
    
    private let posterImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let posterLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let playButton: UIButton = {
        
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(posterLabel)
        contentView.addSubview(playButton)
        
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    private func configureConstraint() {
        
        let posterImageViewConstraints = [
            
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),   // 15
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
        ]
        
        let posterLabelConstraints = [
            
            posterLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            // posterLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor),
            // posterLabel.widthAnchor.constraint(equalToConstant: contentView.),
            posterLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
        
        let playButtonConstraints = [
            
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
        
        NSLayoutConstraint.activate(posterImageViewConstraints)
        NSLayoutConstraint.activate(posterLabelConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
    }
    
    public func configure(model: TitleViewModel) -> Void {
        
        guard let poster_url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.poster_url)") else { return }
        posterImageView.sd_setImage(with: poster_url)
        
        posterLabel.text = model.titleName
    }
}
