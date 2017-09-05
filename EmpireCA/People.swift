//
//  People.swift
//  EmpireCA
//
//  Created by Andrius on 9/1/17.
//  Copyright © 2017 Andrius. All rights reserved.
//

import Foundation
import UIKit

class Person {
    var age = 0
    var strength = 0
    var reproductionValue = 0
    var colonyID: Int?
    var isAlive = false
    var isDiseased = false
    var x: Int = 0
    var y: Int = 0
    init(colonyID: Int, x: Int, y: Int, world: World) {
        isAlive = true
        strength = Int(arc4random_uniform(20))
        reproductionValue = Int(arc4random_uniform(5))
        isDiseased = false
        let diseasedChance = arc4random_uniform(100)
        if diseasedChance == 99{
            isDiseased = true
        }
    }
    func update() {
        if age > strength {
            isAlive = false
            return
        }
        if isDiseased {
            let randomChanceToDie = Int(arc4random_uniform(100))
            if randomChanceToDie == 100 {
                isAlive = false
                return
            }
        }
        age = age + 1
        reproductionValue = reproductionValue + 1
        let randomX = Int(arc4random_uniform(2))
        let randomX2 = Int(arc4random_uniform(2))
        let randomY = Int(arc4random_uniform(2))
        let randomY2 = Int(arc4random_uniform(2))
        x = x + 1
        y = y + 1
        
    }
}
