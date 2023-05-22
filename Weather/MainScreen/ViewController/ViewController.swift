//
//  ViewController.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import UIKit
import CoreData
import CoreLocation


class ViewController: UIViewController {
    
    // Business Logic
    var coreLocationManager: LocationDataManager?
    
    // Networking
    let fetchWeatherInteractor = FetchCityWeatherInteractor()
    let fetchSearchInputInteractor = DirectGeocodingInteractor()
    
    // Storage
    let numberOfSections: Int = 2
    var userCurrentCityWeatherData: [CityWeather] = []
    var lastSearchedCityWeatherData: [CityWeather] = []
    
    // Entity contains city name, lat, and lon
    var cityHistory: [NSManagedObject] = [] // array for extensibility. In the future case if we want to store multiple last searched cities.
    
    var searchInput: String = ""
    
    var searchBarResults: [SearchResultElement] = [] {
        didSet {
            searchResultsTable.isHidden = searchBarResults.isEmpty
        }
    }
    
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
        layout.sectionInset = .init(top: 10, left: .zero, bottom: 10, right: .zero)
        
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

        self.coreLocationManager = LocationDataManager(locationUpdated: self.userLocationUpdated)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetch `last searched city` coordinates from CoreData. Then make a request to get that city's current weather data
        self.fetchLastSearchedCityWeatherData()
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
    
    // This implementation assumes that we only attain user location once, when the app is launched.
    // Not implemented: Ideally, we also obtain user location when the app enters foreground from background, to cover the case where user moves to a different city while app is in background (i.e. after a flight)
    func userLocationUpdated(userCoordinates: (lat: Double, lon: Double)?) {
        if let coord = userCoordinates {
            self.fetch(coordinates: (coord.lat, coord.lon)) { weatherData in
                // Update first section of collection view with user location's weather
                if let weatherData = weatherData {
                    self.userCurrentCityWeatherData = [weatherData]
                    DispatchQueue.main.async {
                        self.citiesWeatherView.reloadData()
                    }
                }
            }
        }
    }
    
    func fetchLastSearchedCityWeatherData() {
        self.retrieveLastSearchedCityFromCoreData()
        
        // If there's city, fetch weather data
        if let lat = cityHistory.first?.value(forKey: "lat") as? Double,
           let lon = cityHistory.first?.value(forKey: "lon") as? Double {
            self.fetch(coordinates: (lat, lon)) { weatherData in
                if let weatherData = weatherData {
                    self.lastSearchedCityWeatherData = [weatherData]
                    DispatchQueue.main.async {
                        self.citiesWeatherView.reloadData()
                    }
                }
            }
        }
    }
    
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
                      
        self.fetchWeatherInteractor.perform(for: (latStr, lonStr)) { cityWeather, error in
            guard let cityWeather = cityWeather, error == nil else {
                // Show alert for failure
                self.displayFailureAlert()
                return
            }
            
            completion(cityWeather)
        }
    }
    
    func showDataInModal(for city: SearchResultElement, completion: @escaping () -> Void) {
        guard let coordinates = city.coordinates else {
            // Show alert for failure
            self.displayFailureAlert()
            return
        }
        
        self.fetch(coordinates: coordinates) { cityWeather in
            guard let cityWeather = cityWeather else {
                // Show alert for failure
                self.displayFailureAlert()
                return
            }
            
            self.lastSearchedCityWeatherData = [cityWeather]
            
            // Here, we're relying on a view controller to present another view controller. Ideally, we have a router to coordinate the presentation.
            let viewModel = SelectedCityWeatherViewControllerViewModel(cityName: city.fullName, cityWeather: cityWeather)
            self.present(SelectedCityWeatherViewController(viewModel: viewModel), animated: true, completion: completion)
        }
        
    }
    
    func saveLastSearchedCity(name: String, coord: (lat: Double, lon: Double)) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "City", in: managedContext)!
        
        let city = NSManagedObject(entity: entity, insertInto: managedContext)
        
        print("this is saved name: \(name)")
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
    
    func displayFailureAlert() {
        // Ideally we create a custom enum `CustomError: Error` where we can specify all the different error types in the app.
        // We then pass this along based on the different error sources and reasons. This way we can make it clearer to the end user.

        let alertAction = UIAlertAction(title: "OK", style: .cancel)
        let alert = UIAlertController(title: "Request Failed", message: "We're sorry. Please make sure your device is connected to the internet or try again later.", preferredStyle: .alert)
        alert.addAction(alertAction)
        alert.overrideUserInterfaceStyle = .dark

        self.present(alert, animated: true)
    }
        
}
