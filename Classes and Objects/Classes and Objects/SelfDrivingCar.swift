//
//  SelfDrivingCar.swift
//  Classes and Objects
//
//  Created by David Miguel on 15/05/2019.
//  Copyright © 2019 David Miguel. All rights reserved.
//

import Foundation

class SelfDrivenCar: Car {
    
    var destination = "1 Infinite Loop"
    
    override func drive() {
        super.drive()
        print("Driving towards \(destination)")
    }
}
