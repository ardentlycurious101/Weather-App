//
//  FetchCityWeatherInteractor.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import Foundation

class FetchCityWeatherInteractor {
    let networking = WeatherNetworking()

    func perform(for location: (lat: String, lon: String), completion: @escaping (_ cityWeather: CityWeather?) -> Void) {
        self.networking.fetchWeather(for: location) { cityWeather, error in
            guard error == nil else {
                print(error!)
                return
            }
            
            completion(cityWeather ?? nil)
        }
    }
}

