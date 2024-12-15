//
//  Untitled.swift
//  WeatherDemo
//
//  Created by Maulik Shah on 12/14/24.
//

import SwiftUI

struct ViewWeather: View {
    @ObservedObject var viewModel: HomeViewModel
 
    var body: some View {
        
        VStack (spacing: 24){

            AsyncImage(url:  viewModel.currentInfo?.condition?.url) { phase in
                switch phase {
                case .empty:
                    ProgressView() // Show a loading indicator
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit() // Display the image
                case .failure:
                    Image(systemName: "photo") // Placeholder for failure
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 124,height: 124)
            
            HStack {
                Text(viewModel.city ?? "")
                    .customFont(.semiBold, size: 30)
                AppImageName.location.image
                    .resizable()
                    .frame(width: 21,height: 21)
            }
            
            Text("\(viewModel.currentInfo?.temp_c ?? 0.0)".roundto(2) + "°")
                .customFont(.medium, size: 70)
         
            HStack(spacing: 56){
                WeatherInfoItem(title: "Humidity", value: "\(viewModel.currentInfo?.humidity ?? 0.0)".roundto(2) + "%")
                WeatherInfoItem(title: "UV", value:  "\(viewModel.currentInfo?.uv ?? 0.0)".roundto(2))
                WeatherInfoItem(title: "Feels Like", value: "\(viewModel.currentInfo?.feelslike_c ?? 0.0)".roundto(2) + "°")
            }
            .foregroundColor(.gray)
            .frame(width: 274,height: 74)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(16)
        }.padding(.all,20)
    }
}

struct WeatherInfoItem: View {
    var title : String
    var value : String
    
    var body: some View {
        VStack(spacing: 4){
            Text(title)
                .customFont(.medium, size: 12)
            Text(value)
                .customFont(.medium, size: 15)
        }
    }
}




