//
//  ViewController+TableView.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBarResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier) as! SearchResultCell
        cell.setUpView(content: searchBarResults[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select row: \(indexPath.row)")
        
        let row = searchBarResults[indexPath.row]
        
        // Show data in modal
        self.showData(for: row)
        
        // Cache data and update collection view
        if let coordinates = row.coordinates {
            self.saveCity(name: row.fullName, coord: coordinates)
            self.citiesWeatherView.reloadData()
        }
    }
    
}

