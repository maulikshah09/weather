//
//  StringExt.swift
//  WeatherDemo
//
//  Created by Maulik Shah on 12/14/24.
//

extension String {
    func roundto(_ places: Int) -> String {
        guard let doubleValue = Double(self) else { return self }
        let formatted = String(format: "%.\(places)f", doubleValue)
        
        // Check if the formatted string ends with ".00"
        if formatted.hasSuffix(".00") {
            return String(format: "%.0f", doubleValue) 
        }
        return formatted
    }
}
