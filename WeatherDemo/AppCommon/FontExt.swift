//
//  FontExtension.swift
//  WeatherDemo
//
//  Created by Maulik Shah on 12/14/24.
//


import SwiftUI

// MARK: - Font Declaration for SwiftUI
enum AppFont: String {
    case regular        = "Poppins-Regular"
    case medium         = "Poppins-Medium"
    case semiBold       = "Poppins-SemiBold"
    
    func of(_ size: CGFloat) -> Font {
         return Font.custom(self.rawValue, size: size)
    }
}

extension View {
    func customFont(_ font: AppFont, size: CGFloat) -> some View {
        self.font(font.of(size))
    }
}

// how to use
//  Text("Please Search For A City")
//    .customFont(.semiBold, size: 15)
