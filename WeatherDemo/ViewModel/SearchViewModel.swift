//
//  SearchViewModel.swift
//  WeatherDemo
//
//  Created by Maulik Shah on 12/14/24.
//

import Foundation

protocol NetworkSerchService {
    func fetchCityList(for url: URL) async throws -> [CityList]
}

struct SearchNetworkService: NetworkSerchService {
    func fetchCityList(for url: URL) async throws -> [CityList] {
        let parms = RequestParameters(url: url)
        return try await URLSession.shared.request(
            parms,
            successModel: [CityList].self,
            failureModel: ErrorResponseModel.self
        )
    }
}

class SearchViewModel: ObservableObject {
   
    @Published var search: String? {
        didSet {
            debounceSearch()
        }
    }
    
    @Published var message: String = ""
    @Published var showAlert: Bool = false
    @Published var arrSearchList : [CityList] = []
 
    private let networkService: NetworkSerchService
    private let apiKey: String
    private let baseURL: String
    private var searchDebounceTimer: Timer?

    
    init(networkService: NetworkSerchService, apiKey: String, baseURL: String) {
        self.networkService = networkService
        self.apiKey = apiKey
        self.baseURL = baseURL
    }
  
    private func debounceSearch() {
        searchDebounceTimer?.invalidate()
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            Task {
                await self.featchSeachList()
            }
        }
    }

    func featchSeachList() async{
        guard let search = search, !search.isEmpty,
              var components = URLComponents(string: baseURL) else { return }
        
        components.queryItems = [
            URLQueryItem(name: "q", value: search),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        guard let url = components.url else { return }
        DispatchQueue.main.async { [weak self] in
            Task{
                do {
                    if  let searchData = try await self?.networkService.fetchCityList(for: url){
                             self?.arrSearchList = searchData
                    }
                    self?.message = ""
                    self?.showAlert = false
                } catch let NetworkError.errorResponse(errorResponse as ErrorResponseModel) {
                    self?.message = errorResponse.error?.message ?? ""
                    self?.showAlert = true
        //            print("API Error: \(errorResponse.error?.message ?? "") (Code: \(String(describing: errorResponse.error?.code)))")
                } catch {
                //    print("Unexpected error: \(error.localizedDescription)")
                    self?.message = "Unexpected error: \(error.localizedDescription)"
                    self?.showAlert = true
                }
            }
        }
    }
}
