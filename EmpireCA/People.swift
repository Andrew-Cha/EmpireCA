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
    var strength: Double
    var reproductionValue: Int
    var colonyID: Int
    var isAlive: Bool
    var isDiseased: Bool
    var x: Int
    var y: Int
    var world: World
    
    init(newColonyID: Int, xNew: Int, yNew: Int, worldPassed: World) {
        self.world = worldPassed
        self.colonyID = newColonyID
        self.reproductionValue = 0
        self.x = xNew
        self.y = yNew
        self.isAlive = true
        self.strength = Double(arc4random_uniform(100))
        self.isDiseased = false
        let diseasedChance = arc4random_uniform(100)
        if diseasedChance == 99{
            self.isDiseased = true
        }
    }
    
    init(childOf parent: Person, xNew: Int, yNew: Int, newColonyID: Int) {
        self.world = parent.world
        colonyID = newColonyID
        reproductionValue = 0
        x = xNew
        y = yNew
        isAlive = true
        let randomNumberForStrength = arc4random_uniform(100)
        if randomNumberForStrength == 99 {
            strength = parent.strength * 0.7
        } else {
            strength = parent.strength
        }
        
        if randomNumberForStrength > 80 {
            strength = parent.strength * 0.9
        } else {
            strength = parent.strength
        }
        
        isDiseased = false
        let diseasedChance = arc4random_uniform(100)
        if diseasedChance > 80{
            isDiseased = true
        }
    }
    
    func die() {
        isAlive = false
        world.people[x][y] = nil
    }
    
    func fightDefended(defendant: Person, attacker: Person) -> Bool {
        if defendant.strength >= attacker.strength {
            return true
        } else {
            return false
        }
    }
    
    func moveTo(x: Int, y: Int) {
        self.x = x
        self.y = y
        world.people[x][y] = self
    }
    
    func update() {
        
        if age > Int(strength) {
            die()
            return
        }
        
        if isDiseased {
            let randomChanceToDie = Int(arc4random_uniform(100))
            if randomChanceToDie == 100 {
                die()
                return
            }
        }
        
        let randomX = Int(arc4random_uniform(2))
        let randomX2 = Int(arc4random_uniform(2))
        let randomY = Int(arc4random_uniform(2))
        let randomY2 = Int(arc4random_uniform(2))
        let generatedX = x + (randomX - randomX2)
        let generatedY = y + (randomY - randomY2)
        
        age = age + 1
        reproductionValue += 1
        
        if reproductionValue < 20 {
            if let defendingPerson = world.personAt(x: generatedX, y: generatedY) {
                // let defendingPerson = world.personAt(x: generatedX, y: generatedY)
                if defendingPerson.colonyID != colonyID {
                    if fightDefended(defendant: defendingPerson, attacker: self) {
                        die()
                        return
                    } else {
                        defendingPerson.die()
                        moveTo(x: generatedX, y: generatedY)
                    }
                }
                
            } else if world.isLandAt(x: generatedX, y: generatedY) {
                moveTo(x: generatedX, y: generatedY)
                return
            }
        }
        
        if reproductionValue >= 20 {
            if world.personAt(x: generatedX, y: generatedY) != nil {
                let defendingPerson = world.personAt(x: generatedX, y: generatedY)
                if defendingPerson?.colonyID != colonyID {
                    if fightDefended(defendant: defendingPerson!, attacker: self) {
                        die()
                        return
                    } else {
                        let child = Person(childOf: self, xNew: x, yNew: y, newColonyID: colonyID)
                        world.people[child.x][child.y] = child
                        
                        x = generatedX
                        y = generatedY
                        reproductionValue = 0
                        world.people[x][y] = self
                        return
                    }
                }
            } else if world.isLandAt(x: generatedX, y: generatedY) {
                let child = Person(childOf: self, xNew: x, yNew: y, newColonyID: colonyID)
                world.people[child.x][child.y] = child
                
                x = generatedX
                y = generatedY
                reproductionValue = 0
                world.people[x][y] = self
                return
            }
        }
    }
}


