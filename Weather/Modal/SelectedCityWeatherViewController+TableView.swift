//
//  SelectedCityWeatherViewController+TableView.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import UIKit

extension SelectedCityWeatherViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectedCityWeatherCell.identifier) as! SelectedCityWeatherCell
        let detail = details[indexPath.row]
        cell.setUpView(field: detail.field, description: detail.description)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
