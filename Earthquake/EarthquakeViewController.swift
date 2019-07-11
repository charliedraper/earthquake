//
//  EarthquakeViewController.swift
//  Earthquake
//
//  Created by Charlie Draper on 7/8/19.
//  Copyright © 2019 Charlie Draper. All rights reserved.
//

import UIKit
import MapKit

class EarthquakeViewController: UIViewController {
    
    var earthquake: Earthquake!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLabels()
        self.setMap()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func didTapMoreInfo(sender: AnyObject) {
        UIApplication.shared.open(URL(string: earthquake.url)!)
    }

    private func setLabels() {
        
        timeLabel.text = earthquake.time
        locationLabel.text = earthquake.place
        magnitudeLabel.text = earthquake.magnitude
        depthLabel.text = earthquake.depth
        
    }
    
    private func setMap() {
        
        let lat = CLLocationDegrees(exactly: earthquake.coords[1])!
        let lon = CLLocationDegrees(exactly: earthquake.coords[0])!
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        let span = MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        mapView.addAnnotation(annotation)
        
    }

}

