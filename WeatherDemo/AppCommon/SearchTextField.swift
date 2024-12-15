//
//  TextField.swift
//  WeatherDemo
//
//  Created by Maulik Shah on 12/14/24.
//

import SwiftUI

struct SearchTextField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack{
            TextField(placeholder, text: $text)
                .padding(.horizontal,15)
            Spacer()
            AppImageName.megnify.image
                .renderingMode(.template)
                .foregroundColor(.gray)
                .padding(.trailing,20)
        }
        .frame(height: 46)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}



#Preview {
    SearchTextField(
        placeholder: "Place holder",
        text: .constant("")
    )
}
