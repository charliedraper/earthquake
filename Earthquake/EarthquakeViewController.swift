//
//  EarthquakeViewController.swift
//  Earthquake
//
//  Created by Charlie Draper on 7/8/19.
//  Copyright © 2019 Charlie Draper. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EarthquakeViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: - Properties
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var earthquake: Earthquake!
    
    //MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
        setMap()
    }
    
    @IBAction func didTapMoreInfo(sender: AnyObject) {
        UIApplication.shared.open(earthquake.url)
    }
    
    //MARK: - Private Methods

    private func setLabels() {
        locationLabel.text = earthquake.place
        timeLabel.text = dateFormatter.string(from: earthquake.time)
        magnitudeLabel.text = String(earthquake.magnitude).padding(toLength: 4, withPad: "0", startingAt: 0)
        depthLabel.text = earthquake.depth > 0 ? "\(String(earthquake.depth)) km" : "Unavailable"
        distanceLabel.text = "\(String(Int((earthquake.location.distance(from: userLocation) / 1000).rounded()))) km"
    }
    
    private func setMap() {
        let center = CLLocationCoordinate2D(latitude: earthquake.latitude, longitude: earthquake.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 8.0, longitudeDelta: 8.0)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        mapView.addAnnotation(annotation)
    }
    
}

