//
//  ThirdViewController.swift
//  WeatherApp
//
//  Created by Taavi Tuomela on 03/10/2018.
//  Copyright © 2018 Taavi Tuomela. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var data: [String] = ["Use GPS", "Tampere", "Helsinki", "London", "Paris", "Madrid", "Tokyo", "Sydney", "Seattle"]
    
    let defaults = UserDefaults.standard
    var cityToAdd: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        if self.defaults.array(forKey: "cityArray") != nil {
            
            self.data = self.defaults.array(forKey: "cityArray") as! [String]
        } else {
            
            self.defaults.set(data, forKey: "cityArray")
        }

        if self.defaults.integer(forKey: "row") != 0 {
            
            tableView.selectRow(at: IndexPath(row: self.defaults.integer(forKey: "row"), section: 0), animated: true, scrollPosition: .top)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        } else {
            
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "someID")
        cell.textLabel?.text = self.data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            
            self.data.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.defaults.set(data, forKey: "cityArray")
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.data[sourceIndexPath.row]
        data.remove(at: sourceIndexPath.row)
        data.insert(movedObject, at: destinationIndexPath.row)
        self.defaults.set(data, forKey: "cityArray")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let escapedString = data[indexPath.row].addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        if data[indexPath.row] != "Use GPS" {
            
            CityToFetch.city.toFetch = escapedString!
            CityToFetch.city.toShow = data[indexPath.row]
        } else {
            
            CityToFetch.city.toShow = "Current location"
        }
        
        self.defaults.set(CityToFetch.city.toFetch, forKey: "CityToFetch")
        self.defaults.set(CityToFetch.city.toShow, forKey: "CityToShow")
        self.defaults.set(indexPath.row, forKey: "row")
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == 0 {
            
            return sourceIndexPath
        }
        
        return proposedDestinationIndexPath
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func isEditing(_ sender: Any) {
        
        if(self.tableView.isEditing == true)
        {
            self.tableView.isEditing = false
            self.navigationItem.rightBarButtonItem?.title = "Done"
        }
        else
        {
            self.tableView.isEditing = true
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }
    
    @IBAction func addLocation(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add a city", message: "Enter city name", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "City to add"
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            
            if textField.text! != "" {
                
                print("Text field: \(textField.text!)")
                self.cityToAdd = textField.text!
                self.data.append(self.cityToAdd!)
                self.defaults.set(self.data, forKey: "cityArray")
                self.tableView.reloadData()
            } else {
                
                print("Invalid input")
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
           
            print("Alert canceled")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
