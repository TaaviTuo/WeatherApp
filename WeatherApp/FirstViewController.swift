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
        
        
        func fetchUrl(url : String) {
            let config = URLSessionConfiguration.default
            
            let session = URLSession(configuration: config)
            
            let url : URL? = URL(string:"https://api.openweathermap.org/data/2.5/weather?q=tampere&appid=87036b970b2794be14435c5af1d69ee7")
            
            let task = session.dataTask(with: url!, completionHandler: doneFetching);
            
            // Starts the task, spawns a new thread and calls the callback function
            task.resume();
        }
        
        func doneFetching(data: Data?, response: URLResponse?, error: Error?) {
            let resstr = String(data: data!, encoding: String.Encoding.utf8)
            
            // Execute stuff in UI thread
            DispatchQueue.main.async(execute: {() in
                NSLog(resstr!)
                
            })
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

