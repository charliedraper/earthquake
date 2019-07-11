//
//  EarthquakeTableViewController.swift
//  Earthquake
//
//  Created by Charlie Draper on 7/8/19.
//  Copyright © 2019 Charlie Draper. All rights reserved.
//

import UIKit

class EarthquakeTableViewController: UITableViewController {
    
    //MARK: Properties
    
    //Array of earthquake objects
    private var earthquakes = [Earthquake]()

    //Load earthquakes once the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadEarthquakes()
        
        //Implement a refresh control when the user swipes up
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    // MARK: - Table view data source

    //Our table will have one section, displaying all of the earthquakes
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

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
        
        cell.timeLabel.text = earthquake.time
        cell.magLabel.text = earthquake.magnitude
        cell.locLabel.text = earthquake.place
        cell.magImageView.image = earthquake.level
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //Function allows us to pass an earthquake's data to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextVC = segue.destination as! EarthquakeViewController
        
        let selectedRow = tableView.indexPathForSelectedRow!.row
        let selectedEarthquake = self.earthquakes[selectedRow]
        
        nextVC.earthquake = selectedEarthquake
    }
    
    
    //MARK: Private Methods
    
    private func loadEarthquakes() {
        
        //Fetches earthquake data from
        let url = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_month.geojson")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                
            if let data = data {
                do {
                    //Decode the JSON and use it to build our earthquake array
                    let result = try JSONDecoder().decode(Result.self, from: data)
                    self.buildArray(earthquakes: result.features)
                    
                    //Once the array has been built, reload our table data and stop refreshing if need be
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
    
    private func buildArray(earthquakes: [Feature]) {
        for earthquake in earthquakes {
            self.earthquakes.append(Earthquake(earthquake: earthquake))
        }
    }
    
    @objc func refreshPage() {
        self.loadEarthquakes()
    }
}

