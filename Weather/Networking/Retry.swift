//
//  Retry.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/20/23.
//

import Foundation


class Retry {
    static func perform<T>(maximumTries: Int, retryInterval: TimeInterval, block: @escaping () throws -> T) throws -> T {
        var currentTry = 1
        var lastError: NSError?
        
        while currentTry <= maximumTries {
            do {
                return try block()
            } catch {
                currentTry += 1
                lastError = NSError(domain: "logging.retry", code: 200)
                
                if currentTry <= maximumTries {
                    Thread.sleep(forTimeInterval: retryInterval)
                }
            }
        }
        
        throw lastError!
    }
}
