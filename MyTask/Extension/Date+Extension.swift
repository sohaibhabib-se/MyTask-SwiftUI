//
//  Date+Extension.swift
//  MyTask
//
//  Created by Muhammad Sohaib on 20/06/2024.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        let result = dateFormatter.string(from: self)
        return result
    }
}
