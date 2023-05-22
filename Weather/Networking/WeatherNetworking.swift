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
        do {
            // Retryable up to 5 times if request fails with 3s retry interval.
            let _ = try Retry.perform(maximumTries: 5, retryInterval: 3.0) {
                self.provider.request(.fetchWeather(location: location)) { result in
                    switch result {
                    case .success(let response):
                        do {
                            let cityWeather = try response.filterSuccessfulStatusCodes().map(CityWeather.self)
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
        } catch {
            completion(nil, CustomError.general) // Can be more specific here by adding more cases to the CustomError enum
        }
    }
    
}
