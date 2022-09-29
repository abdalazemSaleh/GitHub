//
//  Date+Ext.swift
//  GitHub
//
//  Created by Abdalazem Saleh on 2022-09-26.
//

import Foundation


extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "MMM YYYY"
        return dateFormatter.string(from: self)
    }
}
