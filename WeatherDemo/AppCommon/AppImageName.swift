//
//  AppImageName.swift
//  WeatherDemo
//
//  Created by Maulik Shah on 12/14/24.
//

import SwiftUI

// All App Images Name
enum AppImageName  : String{
    // system icon sf symbol
    case megnify          =  "magnifyingglass"
    case cityIcon         =  "ic_cityIcon"
    case location         = "ic_location"
    
    // SwiftUI Image Property
    var image: Image {
        switch self {
        case .megnify: // SF Symbols cases
            return Image(systemName: self.rawValue)
        default: // Custom asset images
            return Image(self.rawValue)
        }
    }
}
