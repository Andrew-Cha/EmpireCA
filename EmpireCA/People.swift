//
//  People.swift
//  EmpireCA
//
//  Created by Andrius on 9/1/17.
//  Copyright © 2017 Andrius. All rights reserved.
//

import Foundation
import UIKit

let strengthDecreaseChance = RandomChance(of: 0.25)
let diseaseCureChance = RandomChance(of: 0.2)
let diseaseHeredityChance = RandomChance(of: 0.2)
let diseaseMutationChance = RandomChance(of: 0.0001)
let diseaseSpreadChance = RandomChance(of: 0.5)
let reproductionThreshold = 20
class Person {
    var age = 0
    var strength: Int
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
        self.strength = Int(arc4random_uniform(100))
        self.isDiseased = false
    }
    
   @discardableResult init(childOf parent: Person, xNew: Int, yNew: Int, newColonyID: Int) {
        self.world = parent.world
        self.x = parent.x
        self.y = parent.y
        self.colonyID = parent.colonyID
        self.strength = parent.strength
        self.reproductionValue = .randomValue(lessThan: reproductionThreshold)
        isAlive = true
        
        let diseasedChance = parent.isDiseased ? diseaseHeredityChance : diseaseMutationChance
        isDiseased = diseasedChance.isFulfilled()
        if strengthDecreaseChance.isFulfilled(){
            strength = .randomValue(lessThan: strength)
        }
        world.people[self.x][self.y] = self
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
        world.people[self.x][self.y] = nil
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
        strength -= 1
        }
        
        let randomX = Int(arc4random_uniform(2))
        let randomX2 = Int(arc4random_uniform(2))
        let randomY = Int(arc4random_uniform(2))
        let randomY2 = Int(arc4random_uniform(2))
        let generatedX = x + (randomX - randomX2)
        let generatedY = y + (randomY - randomY2)
        
        age = age + 1
        reproductionValue += 1
        
        if reproductionValue < reproductionThreshold {
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
                } else {
                    if defendingPerson.isDiseased == false{
                       let chanceToSpreadDisease = Int.randomValue(lessThan: 99)
                        if chanceToSpreadDisease > 50 {
                            defendingPerson.isDiseased = true
                        }
                    }
                }
                
            } else if world.isLandAt(x: generatedX, y: generatedY) {
                moveTo(x: generatedX, y: generatedY)
                return
            }
        }
        
        if reproductionValue >= reproductionThreshold {
            if world.personAt(x: generatedX, y: generatedY) != nil {
                let defendingPerson = world.personAt(x: generatedX, y: generatedY)
                if defendingPerson?.colonyID != colonyID {
                    if fightDefended(defendant: defendingPerson!, attacker: self) {
                        die()
                        return
                    } else {
                        _ = Person(childOf: self, xNew: x, yNew: y, newColonyID: colonyID)
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


