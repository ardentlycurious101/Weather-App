//
//  FetchCityWeatherInteractor.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import Foundation

class FetchCityWeatherInteractor {
    let networking = Networking<WeatherAPI>()

    func perform(for location: (lat: String, lon: String), completion: @escaping (_ cityWeather: CityWeather?, _ error: Error?) -> Void) {
        self.networking.fetch(api: .fetchWeather(location: location)) { (results: CityWeather?, error) in
            guard let results = results, error == nil else {
                completion(nil, error)
                return
            }
            
            completion(results, nil)
        }
    }
}

