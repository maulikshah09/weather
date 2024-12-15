//
//  ContentView.swift
//  WeatherDemo
//
//  Created by Maulik Shah on 12/14/24.
//

import SwiftUI

struct SearchView: View {
    @AppStorage("cityname") private var cityname: String = ""
    @State private var searchText: String = ""
    @StateObject private var viewModel =  SearchViewModel(networkService: SearchNetworkService(), apiKey: SocialKey.apiKey.rawValue, baseURL: AppUrl.search.raw)
    @State private var selectedCity: String?
    @Environment(\.presentationMode) var presentationMode
   
    var body: some View {
        SearchTextField(placeholder: "Search Location", text: $searchText)
            .padding(.top,10)
            .padding(.horizontal,8)
            .onChange(of: searchText) { newValue in
                if !newValue.isEmpty {
                    viewModel.search = newValue
                }
            }
            
        List(viewModel.arrSearchList, id: \.self) { item in
            CityWeather(name: item.name ?? "")
            .listRowSeparator(.hidden)
            .onTapGesture {
                selectedCity = item.name
                cityname = self.selectedCity ?? ""
                presentationMode.wrappedValue.dismiss()
            }
        }.listStyle(.plain)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.message),dismissButton: .default(Text("OK")))
            }
    }
}

#Preview {
    SearchView()
}


struct CityWeather: View {
    var name: String
    var body: some View {
        HStack(alignment: .center){
            VStack(alignment: .leading, spacing: 1){
                Text(name)
                    .customFont(.semiBold, size: 20)
                Text("-")
                    .customFont(.medium, size: 60)
            }
            Spacer()
            AppImageName.cityIcon.image
                .resizable()
                .scaledToFit()
                .frame(width: 65, height: 65)
        }
        .padding(.top,16)
        .padding(.horizontal,16)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
        .padding(.all,8)
       
    }
}

