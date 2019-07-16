//
//  EarthquakeTableViewController.swift
//  Earthquake
//
//  Created by Charlie Draper on 7/8/19.
//  Copyright © 2019 Charlie Draper. All rights reserved.
//

import UIKit
import CoreLocation

let earthquakeURL = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_month.geojson"
var userLocation = CLLocation(latitude: 0.0, longitude: 0.0)

class EarthquakeTableViewController: UITableViewController, CLLocationManagerDelegate {

    //MARK: - Properties
    
    private var earthquakes = [Earthquake]()
    let locationManager = CLLocationManager()
    
    //MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadEarthquakes()
        
        //Obtain the user's location if they consent
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        //Refresh the page when the user swipes up
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadEarthquakes), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        userLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    }

    // MARK: - Table view data source

    //The number of rows in the section will equal the number of earthquakes we fetch
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earthquakes.count
    }

    //Sets the cell's visuals for every earthquake in our array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EarthquakeTableViewCell", for: indexPath) as? EarthquakeTableViewCell else {
            fatalError("Dequed cell is not an instance of ETVC")
        }
        let earthquake = earthquakes[indexPath.row]
        
        cell.buildCell(from: earthquake)
        return cell
    }

    // MARK: - Navigation

    //Function allows us to pass an earthquake's data to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! EarthquakeViewController
        
        let selectedRow = tableView.indexPathForSelectedRow!.row
        let selectedEarthquake = self.earthquakes[selectedRow]
        
        nextVC.earthquake = selectedEarthquake
    }
    
    
    //MARK: - Private Methods
    
    @objc private func loadEarthquakes() {
        //Fetches earthquake data from URL
        let url = URL(string: earthquakeURL)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                
            if let data = data {
                do {
                    //Decode the JSON and use it to build our earthquake array
                    let result = try JSONDecoder().decode(Result.self, from: data)
                    self.buildArray(earthquakes: result.features)
                    
                    //Once the array has been built, reload our table data and stop refreshing the data
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    //Appends all earthquake features to a new array of Earthquake objects
    private func buildArray(earthquakes: [Feature]) {
        for earthquake in earthquakes {
            self.earthquakes.append(Earthquake(earthquake: earthquake))
        }
    }
    
}

//Extension to build an Earthquake Table View Cell's labels
extension EarthquakeTableViewCell {
    
    func buildCell(from earthquake: Earthquake) {
        self.timeLabel.text = dateFormatter.string(from: earthquake.time)
        self.magLabel.text = String(earthquake.magnitude).padding(toLength: 4, withPad: "0", startingAt: 0)
        self.locLabel.text = earthquake.place
        self.magImageView.image = earthquake.level
    }
    
}
