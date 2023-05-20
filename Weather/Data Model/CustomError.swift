//
//  CustomError.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import Foundation

// Can add more error types to something more specific for each point of failure

public enum CustomError: Error {
    case general
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .general:
            return NSLocalizedString("Error: There's a problem and we're very sorry. Please try again later.", comment: "General error")
        }
    }
}
