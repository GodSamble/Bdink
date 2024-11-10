//
//  Date+.swift
//  Buttwink
//
//  Created by 고영민 on 11/11/24.
//

import UIKit

extension Date {
    func getTodayDateToString(_ format: String) -> String {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let today = dateFormatter.string(from: Date())
        return today
    }
}
