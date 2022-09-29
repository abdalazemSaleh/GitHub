//
//  String+Ext.swift
//  GitHub
//
//  Created by Abdalazem Saleh on 2022-09-26.
//

import Foundation


extension String {
    func convertToDate() -> Date? {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale        = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone      = .current
        
        return dateFormatter.date(from: self)
    }
    
    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "No avilable date" }
        return date.convertToMonthYearFormat()
    }
}
