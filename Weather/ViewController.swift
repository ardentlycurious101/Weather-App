//
//  ViewController.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // Networking
    let fetchWeatherInteractor = FetchCityWeatherInteractor()
    let fetchSearchInputInteractor = DirectGeocodingInteractor()
    
    // Data
    var userCurrentCity: [CityWeather] = []
    var lastSearchedCity: [CityWeather] = []
    
    var cityHistory: [NSManagedObject] = []
    
    var searchInput: String = ""
    
    var searchBarResults: [SearchResultElement] = [] {
        didSet {
            searchResultsTable.isHidden = searchBarResults.isEmpty
        }
    }
    
    let mockData = [
        CityWeather(coord: Coord(lon: 122.2711, lat: 37.5585), weather: [Weather(id: 804, main: "Clouds", description: "overcast clouds", icon: "04n")], base: "stations", main: Main(temp: 289.82, feelsLike: 289.61, tempMin: 289.82, tempMax: 289.82, pressure: 1008, humidity: 79, seaLevel: 1008, grndLevel: 1008), visibility: 10000, wind: Wind(speed: 7.74, deg: 205, gust: 13.36), rain: nil, clouds: Clouds(all: 100), dt: 1684525829, sys: Sys(type: nil, id: nil, country: "CN", sunrise: 1684528707, sunset: 1684580198), timezone: 28800, id: 1791673, name: "Weihai", cod: 200),
        CityWeather(coord: Coord(lon: 122.2711, lat: 37.5585), weather: [Weather(id: 804, main: "Clouds", description: "overcast clouds", icon: "04n")], base: "stations", main: Main(temp: 289.82, feelsLike: 289.61, tempMin: 289.82, tempMax: 289.82, pressure: 1008, humidity: 79, seaLevel: 1008, grndLevel: 1008), visibility: 10000, wind: Wind(speed: 7.74, deg: 205, gust: 13.36), rain: nil, clouds: Clouds(all: 100), dt: 1684525829, sys: Sys(type: nil, id: nil, country: "CN", sunrise: 1684528707, sunset: 1684580198), timezone: 28800, id: 1791673, name: "Weihai", cod: 200)
    ]
    
    // View
    lazy var searchBar: UISearchBar = {
        let view = UISearchBar(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    lazy var citiesWeatherView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(CityWeatherCell.self, forCellWithReuseIdentifier: CityWeatherCell.identifier)
        return view
    }()
    
    lazy var searchResultsTable: UITableView = {
        let view = UITableView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
        view.isHidden = true
        
        return view
    }()
    
    lazy var searchModeDimmingView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.isHidden = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapDimmingView)))
        return view
    }()
    
    lazy var noteToUser: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.textColor = .white
        view.textAlignment = .center
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapDimmingView)))
        return view
    }()
    
    // Gesture
    
    @objc func onTapDimmingView() {
        self.searchBar.resignFirstResponder()
    }
    
    // Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchFromCoreData()
        
        // Fetch my location's weather
        self.fetchMyLocationWeather()
        self.fetchLastSearchedCity()
        
        // Set up view with autolayout
        self.setupViews()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate { [unowned self] _ in
            if let layout = citiesWeatherView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.invalidateLayout() // invalidate layout to support size class changes
            }
        }
    }
    
    // Methods
    
    func setupViews() {
        self.view.backgroundColor = .black

        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.citiesWeatherView)
        self.view.addSubview(self.searchModeDimmingView)
        self.view.addSubview(self.searchResultsTable)
        
        self.searchModeDimmingView.addSubview(noteToUser)
        
        NSLayoutConstraint.activate([
            self.searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            self.citiesWeatherView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 25),
            self.citiesWeatherView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.citiesWeatherView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            self.citiesWeatherView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            self.searchModeDimmingView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 25),
            self.searchModeDimmingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.searchModeDimmingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            self.searchModeDimmingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            self.searchResultsTable.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 25),
            self.searchResultsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.searchResultsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            self.searchResultsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            self.noteToUser.topAnchor.constraint(equalTo: searchModeDimmingView.safeAreaLayoutGuide.topAnchor),
            self.noteToUser.leadingAnchor.constraint(equalTo: searchModeDimmingView.safeAreaLayoutGuide.leadingAnchor),
            self.noteToUser.trailingAnchor.constraint(equalTo: searchModeDimmingView.safeAreaLayoutGuide.trailingAnchor),
            self.noteToUser.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func fetchMyLocationWeather() {
        // TODO: Request location with Core Location
        
        
        // Update collection view section 0
        self.fetchWeatherInteractor.perform(for: ("37.5585", "122.2711")) { cityWeather in
            
        }
    }
    
    func fetchLastSearchedCity() {
        // TODO: Check Core Data for city
        
    
    func retrieveLastSearchedCityFromCoreData() {
        // Retrieve last searched city from CoreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "City")
        
        do {
            cityHistory = try managedContext.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.citiesWeatherView.reloadData()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    func fetch(coordinates location: (lat: Double, lon: Double), completion: @escaping (CityWeather?) -> Void) {
        
        let latStr = String(location.lat)
        let lonStr = String(location.lon)
                      
        self.fetchWeatherInteractor.perform(for: (latStr, lonStr), completion: completion)
    }
    
    func showDataInModal(for city: SearchResultElement, completion: @escaping () -> Void) {
        guard let coordinates = city.coordinates else {
            // TODO: Show error
            return
        }
        
        self.fetch(coordinates: coordinates) { cityWeather in
            guard let cityWeather = cityWeather else {
                // TODO: Show error
                return
            }
            
            self.lastSearchedCityWeatherData = [cityWeather]
            
            self.present(SelectedCityWeatherViewController(cityWeather: cityWeather, cityName: city.fullName), animated: true, completion: completion)
        }
        
    }
    
    func saveLastSearchedCity(name: String, coord: (lat: Double, lon: Double)) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "City", in: managedContext)!
        
        let city = NSManagedObject(entity: entity, insertInto: managedContext)
        
        city.setValue(name, forKey: "name")
        city.setValue(coord.lat, forKey: "lat")
        city.setValue(coord.lon, forKey: "lon")
        
        do {
            // Delete since we're storing only one city in search history
            for history in cityHistory {
                managedContext.delete(history)
            }
            
            try managedContext.save()
            
            cityHistory = [city]
            
            print("Successfully saved city.")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
        
}
