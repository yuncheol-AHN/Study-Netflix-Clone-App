//
//  HeaderUIView.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/02/01.
//

import UIKit

class HeaderUIView: UIView {
    
    private let playBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("play", for: .normal)
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private let downloadBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("download", for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private let card: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        // imageView.image = UIImage(named: "Avengers")
        
        return imageView
    }()
    
    private func applyConstraint() {
        let playBtnConstraint = [
            playBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80),
            playBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playBtn.widthAnchor.constraint(equalToConstant: 100),
        ]
        
        let downloadBtnConstraint = [
            downloadBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            downloadBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadBtn.widthAnchor.constraint(equalToConstant: 100)
            
        ]
        
        NSLayoutConstraint.activate(playBtnConstraint)
        NSLayoutConstraint.activate(downloadBtnConstraint)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addSubview(card)
        
        addSubview(playBtn)
        addSubview(downloadBtn)
        
        applyConstraint()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        card.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        
        fatalError()
    }
    
    public func configure(with model: TitleViewModel) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.poster_url)") else { return }
        
        card.sd_setImage(with: url)
    }
}
