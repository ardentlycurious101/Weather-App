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
        cell.setupView()
        
        let city = cityHistory[indexPath.row]
        
        // Retrieve data from `NSManagedObject` instance in array
        
        if let name = city.value(forKey: "name") as? String {
            cell.setMetadata(with: name)
        }
        
//        if let lat = city.value(forKey: "lat") as? Double, let lon = city.value(forKey: "lon") as? Double {
//            self.fetch(coordinates: (lat: lat, lon: lon), completion: { cityWeather in
//                if let cityWeather = cityWeather {
//                    cell.setWeatherData(with: cityWeather)
//                    collectionView.reloadData()
//                }
//            })
//        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalPadding: CGFloat = 20
        let width = view.frame.width - view.safeAreaInsets.left - view.safeAreaInsets.right - horizontalPadding
        return CGSize(width: width, height: 160)
    }
}
