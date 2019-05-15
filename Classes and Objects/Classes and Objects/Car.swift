//
//  Car.swift
//  Classes and Objects
//
//  Created by David Miguel on 15/05/2019.
//  Copyright © 2019 David Miguel. All rights reserved.
//

import Foundation

class Car {
    
    var colour = "Black"
    var numberOfSeats = 5
    var typeOfCar : CarType = .Coupe
    
    init() {
        // Main constructor
    }
    
    convenience init(customerChosenColour: String) {
        self.init()
        colour = customerChosenColour
    }
    
    func drive() {
        print("Car is moving...")
    }
}

enum CarType{
    case Sedan
    case Coupe
    case Hatchback
}
