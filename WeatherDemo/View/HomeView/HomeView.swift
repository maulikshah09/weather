//
//  HomeView.swift
//  WeatherDemo
//
//  Created by Maulik Shah on 12/14/24.
//

import SwiftUI

struct HomeView: View {
    
    @AppStorage("cityname") private var cityname: String = ""
    @State private var searchText: String = ""
    @State private var navigateToSearch: Bool = false
    @StateObject private var viewModel = HomeViewModel(
        networkService: DefaultNetworkService(),
        apiKey: SocialKey.apiKey.rawValue,
        baseURL: AppUrl.current.raw
    )
    
  
    var body: some View {
        NavigationStack {
            SearchTextField(placeholder: "Search Location", text: $searchText)
                .padding(.top,10)
                .padding(.horizontal,8)
                .disabled(true)
                .onTapGesture {
                    navigateToSearch = true
                }
        
            Spacer()
            
            if let city = viewModel.city, !city.isEmpty {
                ViewWeather(viewModel: viewModel)
                    .padding(.bottom, 100)
            } else {
                NoCitySelected()
            }
            
            Spacer()
                .onAppear(){
                    Task{
                        viewModel.city = cityname
                        print(cityname)
                        if let city = viewModel.city, !city.isEmpty {
                            searchText = cityname
                            await viewModel.featchWaterInfo()
                        }
                    }
                }
                .navigationDestination(isPresented: $navigateToSearch) {
                    SearchView()
                }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.message),dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    HomeView()
}

