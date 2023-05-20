//
//  Debouncer.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import Foundation


class Debouncer {
    private let debounceTime: TimeInterval
    private var timer: Timer? = nil
    
    init(debounceTime: TimeInterval) {
        self.debounceTime = debounceTime
    }
    
    func call(perform: @escaping (() -> Void)) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: debounceTime, repeats: false) { _ in
            perform()
        }
    }
}
