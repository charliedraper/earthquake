//
//  Earthquake.swift
//  Earthquake
//
//  Created by Charlie Draper on 7/8/19.
//  Copyright © 2019 Charlie Draper. All rights reserved.
//

import UIKit
import CoreLocation

//A global date formatter object
let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .long
    df.timeStyle = .long
    return df
}()

//The main struct for storing all Earthquake data
struct Earthquake {
    
    //MARK: - Properties
    
    var id: String
    var place: String
    var magnitude: Float
    var time: Date
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var location: CLLocation
    var depth: Float
    var url: URL
    var level: UIImage
    
    //MARK: - Initialization
    
    init(earthquake: Feature) {
        id = earthquake.id
        place = earthquake.properties.place
        time = Date(timeIntervalSince1970: TimeInterval(earthquake.properties.time / 1000))
        magnitude = earthquake.properties.mag
        url = URL(string: earthquake.properties.url)!
        latitude = CLLocationDegrees(earthquake.geometry.coordinates[1])
        longitude = CLLocationDegrees(earthquake.geometry.coordinates[0])
        location = CLLocation(latitude: latitude, longitude: longitude)
        depth = earthquake.geometry.coordinates.count == 3 ? earthquake.geometry.coordinates[2] : -1
        switch magnitude {
        case 0..<3:
            level = UIImage(named: "2.0")!
        case 3..<4:
            level = UIImage(named: "3.0")!
        case 4..<5:
            level = UIImage(named: "4.0")!
        default:
            level = UIImage(named: "5.0")!
        }
    }
    
}

//Result struct that holds the original JSON information
struct Result: Codable {
    let type: String
    let features: [Feature]
}

//Feature struct that holds an earthquake's features
struct Feature: Codable {
    let type: String
    let properties: Property
    let geometry: Geometry
    let id: String
}

//Property struct that holds an earthquake's properties
struct Property: Codable {
    let mag: Float
    let place: String
    let time: Int
    let url: String
}

//Geometry struct that holds an earthquake's geometry
struct Geometry: Codable {
    let coordinates: [Float]
}
