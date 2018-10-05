//
//  SecondViewController.swift
//  WeatherApp
//
//  Created by Taavi Tuomela on 03/10/2018.
//  Copyright © 2018 Taavi Tuomela. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var forecast = ForecastModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fetchUrl(url: "https://api.openweathermap.org/data/2.5/forecast/?q=Tampere&units=metric&APPID=87036b970b2794be14435c5af1d69ee7")
    }
    
    func fetchUrl(url : String) {
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let url : URL? = URL(string: url)
        
        let task = session.dataTask(with: url!, completionHandler: doneFetching)
        
        // Starts the task, spawns a new thread and calls the callback function
        task.resume();
    }
    
    func doneFetching(data: Data?, response: URLResponse?, error: Error?) {
        let resstr = String(data: data!, encoding: String.Encoding.utf8)
        print(resstr!)
        guard let fetchedForecast = try? JSONDecoder().decode(ForecastModel.self, from: data!) else {
            print("Error: Couldn't decode data into forecast")
            return
        }
        
        // Execute stuff in UI thread
        DispatchQueue.main.async(execute: {() in
            
            self.forecast = fetchedForecast
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CustomTableCell(style: .default, reuseIdentifier: "weatherCell")
        cell.weatherLabel.text = self.forecast.list[indexPath.row].name
        cell.timeLabel.text = self.forecast.list[indexPath.row].dt_txt!
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

