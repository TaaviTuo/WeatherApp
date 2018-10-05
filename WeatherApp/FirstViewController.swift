//
//  FirstViewController.swift
//  WeatherApp
//
//  Created by Taavi Tuomela on 03/10/2018.
//  Copyright © 2018 Taavi Tuomela. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fetchUrl(url: "https://api.openweathermap.org/data/2.5/weather?q=Tampere&units=metric&APPID=87036b970b2794be14435c5af1d69ee7")
    }
    
    func fetchUrl(url : String) {
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let url : URL? = URL(string: url)
        
        let task = session.dataTask(with: url!, completionHandler: doneFetching);
        
        // Starts the task, spawns a new thread and calls the callback function
        task.resume();
    }
    
    func doneFetching(data: Data?, response: URLResponse?, error: Error?) {
        //let resstr = String(data: data!, encoding: String.Encoding.utf8)
        guard let weather = try? JSONDecoder().decode(WeatherObject.self, from: data!) else {
            print("Error: Couldn't decode data into weather")
            return
        }
        
        // Execute stuff in UI thread
        DispatchQueue.main.async(execute: {() in
            //print(resstr!)
            self.cityName.text = weather.name
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
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if CityToFetch.city.toFetch != "Use GPS" {
            
            fetchUrl(url: "https://api.openweathermap.org/data/2.5/weather?q=\(CityToFetch.city.toFetch)&units=metric&APPID=87036b970b2794be14435c5af1d69ee7")
        } else if CityToFetch.city.toFetch == "Use GPS" {
            
            //TODO implement location fetching
        } else {
            
            print("Something went wrong!")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

