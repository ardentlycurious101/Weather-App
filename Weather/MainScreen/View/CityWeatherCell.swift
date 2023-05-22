//
//  CityWeatherCell.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import UIKit

class CityWeatherCell: UICollectionViewCell {
    static let identifier = "CityWeatherCell"
    
    lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        
        self.contentView.addSubview(containerView)
        self.containerView.addSubview(cityNameView)
        self.containerView.addSubview(descriptionView)
        self.containerView.addSubview(mainTempView)
        self.containerView.addSubview(maxTempView)
        self.containerView.addSubview(minTempView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            cityNameView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
            cityNameView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            cityNameView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
            
            descriptionView.topAnchor.constraint(equalTo: cityNameView.bottomAnchor, constant: 10),
            descriptionView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
            
            mainTempView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor),
            mainTempView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            mainTempView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
            
            maxTempView.topAnchor.constraint(equalTo: mainTempView.bottomAnchor),
            maxTempView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            maxTempView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
            
            minTempView.topAnchor.constraint(equalTo: maxTempView.bottomAnchor),
            minTempView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            minTempView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func setMetadata(with cityName: String?) {
        self.cityNameView.text = cityName
    }
    
    func setWeatherData(with cityWeather: CityWeather?) {
        
        guard let cityWeather = cityWeather else {
            descriptionView.text = "Loading ..."
            return
        }
        
        if let weatherDescription = cityWeather.weather?.first?.description {
            descriptionView.text = weatherDescription.capitalized
        }
        
        if let mainTemp = cityWeather.main?.temp {
            mainTempView.text = "Temperature: " + String(mainTemp) + "°F"
        }
        
        if let maxTemp = cityWeather.main?.tempMax {
            maxTempView.text = "Max Temperature: " + String(maxTemp) + "°F"
        }
        
        if let minTemp = cityWeather.main?.tempMin {
            minTempView.text = "Min Temperature: " + String(minTemp) + "°F"
        }
    }
}
