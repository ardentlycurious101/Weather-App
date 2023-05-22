//
//  ViewController+CollectionView.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import UIKit

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case MainScreenSection.userLocation.rawValue:
            return userCurrentCityWeatherData.count
        default:
            return cityHistory.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityWeatherCell.identifier, for: indexPath) as! CityWeatherCell
        cell.prepareForReuse()
        cell.setupView()
        
        switch indexPath.section {
        case MainScreenSection.userLocation.rawValue:
            cell.setMetadata(with: "My Location")
            
            cell.contentView.backgroundColor = .cyan
            cell.setWeatherData(with: userCurrentCityWeatherData.first)
            
        default:
            let city = cityHistory[indexPath.row]
            
            if let name = city.value(forKey: "name") as? String {
                cell.setMetadata(with: name)
            }
            
            if let weatherData = lastSearchedCityWeatherData.first {
                cell.contentView.backgroundColor = .systemPink
                cell.setWeatherData(with: weatherData)
            }
            
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Ideally this should use intrinsic content size of the cell based on the content to ensure dynamic size.
        let horizontalPadding: CGFloat = 20
        let width = view.frame.width - view.safeAreaInsets.left - view.safeAreaInsets.right - horizontalPadding
        return CGSize(width: width, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cityWeather: CityWeather
        let cityName: String
        
        switch indexPath.section {
        case MainScreenSection.userLocation.rawValue:
            cityWeather = userCurrentCityWeatherData[indexPath.item]
            cityName = cityWeather.name ?? "My Location"
        default:
            cityWeather = lastSearchedCityWeatherData[indexPath.item]
            cityName = cityWeather.name ?? "Last Searched City"
        }
        
        self.present(SelectedCityWeatherViewController(cityWeather: cityWeather, cityName: cityName), animated: true)
    }
}
