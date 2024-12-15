//
//  AppUrls.swift
//  WeatherDemo
//
//  Created by Maulik Shah on 12/14/24.
//

let MAIN_URL: String = {
        return "https://api.weatherapi.com/v1/"
}()
 
//MARK:- api key
enum AppUrl : String {
    case current              = "current.json"
    case search               = "search.json"
    
   
    var raw: String {
        return  MAIN_URL + self.rawValue
    }
}

//MARK:- Social Info
enum SocialKey : String {
    case apiKey = "56b989ddf8d6411b86a121029241412"
}
