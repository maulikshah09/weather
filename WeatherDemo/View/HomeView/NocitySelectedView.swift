//
//  NocitySelected.swift
//  WeatherDemo
//
//  Created by Maulik Shah on 12/14/24.
//

import SwiftUI

// NO City Selected
struct NoCitySelected: View {
    var body: some View {
        VStack {
            Text("No City Selected")
                .customFont(.semiBold, size: 30)
            Text("Please Search For A City")
                .customFont(.semiBold, size: 15)
         }
        .padding(.bottom,100)
    }
}


#Preview {
    NoCitySelected()
}
