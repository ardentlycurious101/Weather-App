//
//  WeatherAPI.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import Foundation
import Moya

enum WeatherAPI {
    case fetchWeather(location: (lat: String, lon: String))
    case fetchCityList(input: String)
}

extension WeatherAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org")!
    }
    
    var path: String {
        switch self {
        case .fetchCityList:
            return "/geo/1.0/direct"
        case .fetchWeather:
            return "/data/2.5/weather"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchWeather(let location):
            let urlParameters: [String: Any] = [
                "lat": location.lat,
                "lon": location.lon,
                "appid": appId,
                "units": "imperial"
            ]
            
            return .requestParameters(parameters: urlParameters, encoding: URLEncoding.queryString)
        case .fetchCityList(let input):
            let urlParameters: [String: Any] = [
                "q": input,
                "limit": 20,
                "appid": appId
            ]
            
            return .requestParameters(parameters: urlParameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var appId: String {
        /*
         Here we're using info.plist to store the API key, but this is not a secured way.
         
         Ideally - We should set up a secured server-side component that stores the API key and create endpoints that only authorized/authenticated users can access this. Upon successful authentication on the client, user will send a request to the server to fetch the API key with a valid access token in the request header. The server will validate the token and respond with the API key. Then client stores it securely using keychain.
         */
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPEN_WEATHER_MAP_API_KEY") as? String else {
            fatalError("OPEN_WEATHER_MAP_API_KEY not found")
        }
        
        return apiKey
    }
    
}
