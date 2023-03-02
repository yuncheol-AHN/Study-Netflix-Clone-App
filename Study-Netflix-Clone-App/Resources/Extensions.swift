//
//  Extensions.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/02/23.
//

import Foundation

extension String {
    
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.dropFirst(1).lowercased()
    }
}
