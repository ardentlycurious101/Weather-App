//
//  Networking.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/21/23.
//

import Foundation
import Moya

class Networking<T: TargetType> {
    let provider = MoyaProvider<T>()
    
    func fetch<R: Decodable>(api: T, completion: @escaping (_ results: R?, _ error: Error?) -> Void) {
        do {
            // Retryable up to 5 times if request fails with 3s retry interval.
            let _ = try Retry.perform(maximumTries: 5, retryInterval: 3.0) {
                self.provider.request(api) { result in
                    switch result {
                    case .success(let response):
                        do {
                            let decodedResult = try response.filterSuccessfulStatusCodes().map(R.self)
                            completion(decodedResult, nil)
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
