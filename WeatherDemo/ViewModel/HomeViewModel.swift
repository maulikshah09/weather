//
//  HomeViewModel.swift
//  WeatherDemo
//
//  Created by Maulik Shah on 12/14/24.
//

import Foundation

protocol NetworkService {
    func fetchWeatherData(for url: URL) async throws -> WeatherResponseModel
}

struct DefaultNetworkService: NetworkService {
    func fetchWeatherData(for url: URL) async throws -> WeatherResponseModel {
        let parms = RequestParameters(url: url)
        return try await URLSession.shared.request(
            parms,
            successModel: WeatherResponseModel.self,
            failureModel: ErrorResponseModel.self
        )
    }
}

class HomeViewModel: ObservableObject {
    @Published var city: String? = "Himatnagar"
    @Published var currentInfo : Current?
    @Published var message: String = ""
    @Published var showAlert: Bool = false
    
    private let networkService: NetworkService
    private let apiKey: String
    private let baseURL: String
    
    init(networkService: NetworkService, apiKey: String, baseURL: String) {
        self.networkService = networkService
        self.apiKey = apiKey
        self.baseURL = baseURL
    }
  
    func featchWaterInfo() async{
        guard let city = city, !city.isEmpty,
              var components = URLComponents(string: baseURL) else { return }
        
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        guard let url = components.url else { return }
        DispatchQueue.main.async { [weak self] in
            Task{
                do {
                    let weatherData = try await self?.networkService.fetchWeatherData(for: url)
                        self?.currentInfo = weatherData?.current
                        self?.showAlert = false
                  
                } catch let NetworkError.errorResponse(errorResponse as ErrorResponseModel) {
                    self?.message = errorResponse.error?.message ?? ""
                    self?.showAlert = true
                    // print("API Error: \(errorResponse.error?.message ?? "") (Code: \(String(describing: errorResponse.error?.code)))")
                } catch {
                    self?.message = "Unexpected error: \(error.localizedDescription)"
                    self?.showAlert = true
                }
            }
        }

    }
}
