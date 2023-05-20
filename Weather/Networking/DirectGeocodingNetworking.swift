//
//  DirectGeocodingNetworking.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import Foundation
import Moya

class DirectGeocodingNetworking {
    
    let provider = MoyaProvider<WeatherAPI>()
    
    func fetchResult(for input: String, completion: @escaping (_ result: [SearchResultElement]?, _ error: Error?) -> Void) {
        print("fetch Result")
        self.provider.request(.fetchCityList(input: input)) { result in
            switch result {
            case .success(let response):
                do {
                    print("success. Now decoding. \(response.statusCode)")

                    let response = try response.filterSuccessfulStatusCodes()
                    let results = try response.map([SearchResultElement].self)
                    completion(results, nil)
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
