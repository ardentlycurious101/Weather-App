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
        do {
            // Retryable up to 5 times if request fails with 3s retry interval.
            let _ = try Retry.perform(maximumTries: 5, retryInterval: 3.0) {
                self.provider.request(.fetchCityList(input: input)) { result in
                    switch result {
                    case .success(let response):
                        do {
                            let results = try response.filterSuccessfulStatusCodes().map([SearchResultElement].self)
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
        } catch {
            completion(nil, CustomError.general) // Can be more specific here by adding more cases to the CustomError enum
        }
        
    }
    
}
