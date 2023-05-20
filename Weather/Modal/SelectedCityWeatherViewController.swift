//
//  SelectedCityWeatherViewController.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import UIKit

// In this implementation, we use imperial - for ideal user experience, should let user select the measurement unit

class SelectedCityWeatherViewController: UIViewController {
     
    // Data
    
    let cityName: String
    var details: [(field: String, description: String)] = []
    
    // View
    
    lazy var cityWeatherDetailsTable: UITableView = {
        let view = UITableView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(SelectedCityWeatherCell.self, forCellReuseIdentifier: SelectedCityWeatherCell.identifier)
        view.backgroundColor = .white
        return view
    }()
    
    lazy var doneButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Done", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.addTarget(self, action: #selector(onTapDone), for: .touchUpInside)
        return view
    }()
    
    // Lifecycle
    
    init(cityWeather: CityWeather, cityName: String) {
        self.cityName = cityName
        super.init(nibName: nil, bundle: nil)
        self.populateViewWithData(with: cityWeather)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    // Actions
    
    func populateViewWithData(with cityWeather: CityWeather?) {
        // Dynamically append to data source all the data that we wish to display.
        // Implementation below doesn't use all data, but most.
        
        details.append((field: "Name", description: cityName))
        
        guard let cityWeather = cityWeather else { return }
        
        if let mainTemp = cityWeather.main?.temp {
            details.append((field: "Temperature", description:  String(mainTemp) + "°"))
        }
        
        if let weatherDescription = cityWeather.weather?.first?.description {
            details.append((field: "Weather Description", description:  weatherDescription.capitalized))
        }
        
        if let maxTemp = cityWeather.main?.tempMax {
            details.append((field: "Maximum Temperature", description:  String(maxTemp) + "°"))
        }
        
        if let minTemp = cityWeather.main?.tempMin {
            details.append((field: "Minimum Temperature", description:  String(minTemp) + "°"))
        }
        
        if let sunrise = cityWeather.sys?.sunrise {
            details.append((field: "Sunrise", description:  String(sunrise)))
        }
        
        if let sunset = cityWeather.sys?.sunset {
            details.append((field: "Sunset", description:  String(sunset)))
        }
        
        if let pressure = cityWeather.main?.pressure {
            details.append((field: "Minimum Temperature", description:  String(pressure)))
        }
        
        if let feelsLikeTemp = cityWeather.main?.feelsLike {
            details.append((field: "Feels Like", description:  String(feelsLikeTemp)))
        }

        if let humidity = cityWeather.main?.humidity {
            details.append((field: "Humidity", description:  String(humidity)))
        }
        
        if let visibility = cityWeather.visibility {
            details.append((field: "Visibility", description:  String(visibility)))
        }
        
        if let windSpeed = cityWeather.wind?.speed {
            details.append((field: "Wind Speed", description:  String(windSpeed)))
        }

        if let pressure = cityWeather.main?.pressure {
            details.append((field: "Pressure", description:  String(pressure)))
        }
        
        cityWeatherDetailsTable.reloadData()
    }
    
    func setupView() {
        super.view.backgroundColor = .white

        self.view.addSubview(doneButton)
        self.view.addSubview(cityWeatherDetailsTable)
        

        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.widthAnchor.constraint(equalToConstant: 100),

            cityWeatherDetailsTable.topAnchor.constraint(equalTo: doneButton.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            cityWeatherDetailsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cityWeatherDetailsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            cityWeatherDetailsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    @objc func onTapDone() {
        self.dismiss(animated: true)
    }
}
