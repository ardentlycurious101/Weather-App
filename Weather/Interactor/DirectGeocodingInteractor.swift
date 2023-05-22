//
//  DirectGeocodingInteractor.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import Foundation

class DirectGeocodingInteractor {
    
    let networking = Networking<WeatherAPI>()
    let debouncer = Debouncer(debounceTime: 0.2) // 200 ms debounce

    func perform(for input: String, completion: @escaping (_ result: [SearchResultElement]?, _ error: Error?) -> Void) {
        // Debounce input by 200 ms, so that we're not refetching with every new character typed to avoid making too many unnecessary API calls
        debouncer.call {
            self.networking.fetch(api: .fetchCityList(input: input)) { (results: [SearchResultElement]?, error) in
                guard let results = results, error == nil else {
                    completion(nil, error)
                    return
                }
                
                completion(results, nil)
            }
        }
    }
    
}
