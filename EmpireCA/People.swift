//
//  People.swift
//  EmpireCA
//
//  Created by Andrius on 9/1/17.
//  Copyright © 2017 Andrius. All rights reserved.
//

import Foundation
import UIKit

struct Person {
    var age = 0
    var strength = 0
    var reproductionValue = 0
    var colonyID: Int?
    var isAlive = false
    var isDiseased = false
    var x: Int?
    var y: Int?
    init(colonyID: Int, x: Int, y: Int) {
        
        isAlive = true
        strength = Int(arc4random_uniform(20))
        reproductionValue = Int(arc4random_uniform(5))
        isDiseased = false
        let diseasedChance = arc4random_uniform(100)
        if diseasedChance == 99{
            isDiseased = true
        }
    }
}
