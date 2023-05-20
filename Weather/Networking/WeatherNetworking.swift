//
//  WeatherNetworking.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import Foundation
import Moya

class WeatherNetworking {
    let provider = MoyaProvider<WeatherAPI>()
    
    func fetchWeather(for location: (lat: String, lon: String), completion: @escaping (_ cityWeather: CityWeather?, _ error: Error?) -> Void) {
        self.provider.request(.fetchWeather(location: location)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.filterSuccessfulStatusCodes()
                    let cityWeather = try response.map(CityWeather.self)
                    completion(cityWeather, nil)
                } catch let error {
                    print(error.localizedDescription)
                    completion(nil, error)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
    }
    
}
