//
//  Extensions.swift
//  TMDBApp
//
//  Created by Sümeyye Kazancı on 1.09.2022.
//

import Foundation

extension String {
    var formatDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.date(from: self) ?? Date()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: date)
    }
}
