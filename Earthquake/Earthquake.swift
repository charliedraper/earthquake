//
//  Earthquake.swift
//  Earthquake
//
//  Created by Charlie Draper on 7/8/19.
//  Copyright © 2019 Charlie Draper. All rights reserved.
//

import UIKit

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

//Feature struct that holds an earthquake's features
struct Feature: Codable {
    let type: String
    let properties: Property
    let geometry: Geometry
    let id: String
}

//Result struct that holds the original JSON information
struct Result: Codable {
    let type: String
    let features: [Feature]
}

//The main struct for storing all Earthquake data
struct Earthquake {
    
    //MARK: Properties
    var id: String
    var place: String
    var magnitude: String
    var time: String
    var coords: [Float] = []
    var depth: String
    var url: String
    var level: UIImage
    
    //MARK: Initialization
    init(earthquake: Feature) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        let timeInterval = TimeInterval(earthquake.properties.time / 1000)
        
        self.time = String(dateFormatter.string(from: Date(timeIntervalSince1970: timeInterval)))
        self.id = earthquake.id
        self.place = earthquake.properties.place
        self.magnitude = String(earthquake.properties.mag).padding(toLength: 4, withPad: "0", startingAt: 0)
        self.url = earthquake.properties.url
        self.coords.append(earthquake.geometry.coordinates[0])
        self.coords.append(earthquake.geometry.coordinates[1])
        self.depth = earthquake.geometry.coordinates.count == 3 ? String(earthquake.geometry.coordinates[2]) : "Unavailable"
        self.level =
            earthquake.properties.mag > 5.0 ? UIImage(named: "5.0")! :
            earthquake.properties.mag > 4.0 ? UIImage(named: "4.0")! :
            earthquake.properties.mag > 3.0 ? UIImage(named: "3.0")! :
            UIImage(named: "2.0")!
    }
    
}
