//
//  FirstViewController.swift
//  WeatherApp
//
//  Created by Taavi Tuomela on 03/10/2018.
//  Copyright © 2018 Taavi Tuomela. All rights reserved.
//

import UIKit
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    let geocoder = CLGeocoder()
    var urlToFetch: String = "https://api.openweathermap.org/data/2.5/weather?q=Tampere&units=metric&APPID=87036b970b2794be14435c5af1d69ee7"
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myActivityIndicator.center = self.view.center;
        view.addSubview(myActivityIndicator)
        myActivityIndicator.startAnimating()
        if CityToFetch.city.toFetch != "Use GPS" {
            
            urlToFetch = "https://api.openweathermap.org/data/2.5/weather?q=\(CityToFetch.city.toFetch)&units=metric&APPID=87036b970b2794be14435c5af1d69ee7"
            fetchUrl(url: urlToFetch)
            
        } else if CityToFetch.city.toFetch == "Use GPS" {
            
            locationManager.requestAlwaysAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestLocation()
            }
            
        } else {
            
            print("Something went wrong!")
        }
    }
    
    func fetchUrl(url : String) {
        myActivityIndicator.startAnimating()
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let url : URL? = URL(string: url)
        
        let task = session.dataTask(with: url!, completionHandler: doneFetching);
        
        // Starts the task, spawns a new thread and calls the callback function
        task.resume();
    }
    
    func doneFetching(data: Data?, response: URLResponse?, error: Error?) {
        //print("Given error: ", error)
        //let resstr = String(data: data!, encoding: String.Encoding.utf8)
        //print(resstr!)
        guard let weather = try? JSONDecoder().decode(WeatherObject.self, from: data!) else {
            print("Error: Couldn't decode data into weather")
            return
        }
        
        // Execute stuff in UI thread
        DispatchQueue.main.async(execute: {() in
            
            self.cityName.text = CityToFetch.city.toShow
            self.temperature.text = String(weather.main.temp) + "C"
            self.fetchImageUrl(url: "https://openweathermap.org/img/w/\(weather.weather[0].icon).png")
        })
    }
    
    func fetchImageUrl(url : String) {
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let url : URL? = URL(string: url)
        
        let task = session.dataTask(with: url!, completionHandler: doneFetchingImage);
        
        // Starts the task, spawns a new thread and calls the callback function
        task.resume();
    }
    
    func doneFetchingImage(data: Data?, response: URLResponse?, error: Error?) {
        
        guard let image = data else {
            print("NO PICPICS")
            return
        }
        
        // Execute stuff in UI thread
        DispatchQueue.main.async(execute: {() in
            
            self.weatherImage.image = UIImage(data: image)
            self.weatherImage.contentMode = .scaleAspectFit
            self.myActivityIndicator.stopAnimating()
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myActivityIndicator.startAnimating()
        if CityToFetch.city.toFetch != "Use GPS" {
            
            urlToFetch = "https://api.openweathermap.org/data/2.5/weather?q=\(CityToFetch.city.toFetch)&units=metric&APPID=87036b970b2794be14435c5af1d69ee7"
            fetchUrl(url: urlToFetch)

        } else if CityToFetch.city.toFetch == "Use GPS" {

            locationManager.requestAlwaysAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestLocation()
            }
            
        } else {
            
            print("Something went wrong!")
        }
        
        myActivityIndicator.stopAnimating()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let latestLocation : CLLocation = locations[locations.count-1]
        let lat = String(latestLocation.coordinate.latitude)
        let lon = String(latestLocation.coordinate.longitude)
        print("Lat: \(lat), long: \(lon)")
        currentLocation = latestLocation
        urlToFetch = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&APPID=87036b970b2794be14435c5af1d69ee7"
        print(urlToFetch)
        fetchUrl(url: urlToFetch)
        
        geocoder.reverseGeocodeLocation(currentLocation!, completionHandler: { (placemarks, error) -> Void in
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Location name
            if let locationName = placeMark.location {
                print(locationName)
            }
            // Street address
            if let street = placeMark.thoroughfare {
                print(street)
            }
            // City
            if let city = placeMark.subAdministrativeArea {
                let escapedString = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                print(escapedString!)
                CityToFetch.city.toShow = city
                CityToFetch.city.toFetch = escapedString!
                self.cityName.text = CityToFetch.city.toShow
                print(city)
            }
            // Zip code
            if let zip = placeMark.isoCountryCode {
                print(zip)
            }
            // Country
            if let country = placeMark.country {
                print(country)
            }
            self.myActivityIndicator.stopAnimating()
        })
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

