//
//  CityWeatherCell.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import UIKit

class CityWeatherCell: UICollectionViewCell {
    static let identifier = "CityWeatherCell"
    
    lazy var cityNameView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.numberOfLines = 1
        view.textColor = .black
        view.lineBreakMode = .byTruncatingTail
        return view
    }()
    
    lazy var mainTempView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.numberOfLines = 1
        view.textColor = .black
        view.lineBreakMode = .byTruncatingTail
        return view
    }()
    
    lazy var minTempView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.numberOfLines = 1
        view.textColor = .black
        view.lineBreakMode = .byTruncatingTail
        return view
    }()
    
    lazy var maxTempView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.numberOfLines = 1
        view.textColor = .black
        view.lineBreakMode = .byTruncatingTail
        return view
    }()
    
    lazy var descriptionView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.numberOfLines = 1
        view.textColor = .black
        view.lineBreakMode = .byTruncatingTail
        return view
    }()
    
    func setupView() {
        self.contentView.backgroundColor = .lightGray
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.cornerCurve = .continuous
        self.contentView.clipsToBounds = true
        
        self.contentView.addSubview(cityNameView)
        self.contentView.addSubview(descriptionView)
        self.contentView.addSubview(mainTempView)
        self.contentView.addSubview(maxTempView)
        self.contentView.addSubview(minTempView)
        
        NSLayoutConstraint.activate([
            cityNameView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            cityNameView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            cityNameView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            
            descriptionView.topAnchor.constraint(equalTo: cityNameView.bottomAnchor),
            descriptionView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            
            mainTempView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor),
            mainTempView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            mainTempView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            
            maxTempView.topAnchor.constraint(equalTo: mainTempView.bottomAnchor),
            maxTempView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            maxTempView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            
            minTempView.topAnchor.constraint(equalTo: maxTempView.bottomAnchor),
            minTempView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            minTempView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func setMetadata(with cityName: String?) {
        self.cityNameView.text = cityName
    }
    
    func setWeatherData(with cityWeather: CityWeather) {
        
        if let weatherDescription = cityWeather.weather?.first?.description {
            descriptionView.text = weatherDescription.capitalized
        }
        
        if let mainTemp = cityWeather.main?.temp {
            mainTempView.text = String(mainTemp) + "°"
        }
        
        if let maxTemp = cityWeather.main?.tempMax {
            maxTempView.text = String(maxTemp) + "°"
        }
        
        if let minTemp = cityWeather.main?.tempMin {
            minTempView.text = String(minTemp) + "°"
        }
    }
}
