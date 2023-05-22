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
        // Ideally we should also implement this to be retryable if request fails.
        // Can use something like Combine's retry(_:)- https://developer.apple.com/documentation/combine/record/retry(_:)
        
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
    
}
