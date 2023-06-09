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
            if let authorizationStatus = self.coreLocationManager?.authorizationStatus {
                switch authorizationStatus {
                case .authorizedAlways, .authorizedWhenInUse:
                    return 1
                default:
                    return userCurrentCityWeatherData.count
                }
            }
            
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
            if let city = cityHistory.first {
                if let name = city.value(forKey: "name") as? String {
                    cell.setMetadata(with: "Last Searched City: " + name)
                }
                
                if let weatherData = lastSearchedCityWeatherData.first {
                    cell.contentView.backgroundColor = .systemPink
                    cell.setWeatherData(with: weatherData)
                }
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
        var cityWeather: CityWeather?
        var cityName: String = ""
        
        switch indexPath.section {
        case MainScreenSection.userLocation.rawValue:
            if let weatherData = userCurrentCityWeatherData.first {
                cityWeather = weatherData
            }
            cityName = cityWeather?.name ?? "My Location"
        default:
            if let weatherData = lastSearchedCityWeatherData.first {
                cityWeather = weatherData
            }
            
            if let city = cityHistory.first {
                if let name = city.value(forKey: "name") as? String {
                    cityName = name
                }
            }
        }
        
        // Here, we're relying on a view controller to present another view controller. Ideally, we have a router to coordinate the presentation.
        
        if let cityWeather = cityWeather {
            let viewModel = SelectedCityWeatherViewControllerViewModel(cityName: cityName, cityWeather: cityWeather)
            self.present(SelectedCityWeatherViewController(viewModel: viewModel), animated: true)
        }
    }
}
