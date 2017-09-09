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
    var strength: Int
    var reproductionValue: Int
    var colonyID: Int
    var isAlive: Bool
    var isDiseased: Bool
    var x: Int
    var y: Int
    var canMakeChild: Bool
    var world: World
    
    init(newColonyID: Int, xNew: Int, yNew: Int, worldPassed: World) {
        world = worldPassed
        colonyID = newColonyID
        reproductionValue = 0
        x = xNew
        y = yNew
        isAlive = true
        strength = Int(arc4random_uniform(100))
        isDiseased = false
        canMakeChild = false
        let diseasedChance = arc4random_uniform(100)
        if diseasedChance == 99{
            isDiseased = true
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
        strength = parent.strength + 20
        } else {
            strength = parent.strength
        }
        
        if randomNumberForStrength > 80 {
            strength = parent.strength + 5
        } else {
           strength = parent.strength
        }
        
        isDiseased = false
        canMakeChild = false
        let diseasedChance = arc4random_uniform(100)
        if diseasedChance == 99{
            isDiseased = true
        }
    }
    
    func fightDefended(defendant: Person, attacker: Person) -> Bool {
        if defendant.strength >= attacker.strength {
            return true
        } else {
            return false
        }
    }
    
    func update() {
        if age > strength {
            self.die()
            return
        }
        if isDiseased {
            let randomChanceToDie = Int(arc4random_uniform(100))
            if randomChanceToDie == 100 {
                self.die()
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
        if reproductionValue < 2 {
            canMakeChild = false
        }
        if reproductionValue >= 2 {
            
            if world.personAt(x: generatedX, y: generatedY) != nil {
                let defendingPerson = world.personAt(x: generatedX, y: generatedY)
                if defendingPerson?.colonyID != self.colonyID {
                    if fightDefended(defendant: defendingPerson!, attacker: self) {
                        self.die()
                    } else {
                        canMakeChild = true
                        let child = Person(childOf: self, xNew: self.x, yNew: self.y, newColonyID: self.colonyID)
                        world.people[child.x][child.y] = child
                        
                        x = generatedX
                        y = generatedY
                        reproductionValue = 0
                        world.people[x][y] = self
                        
                    }
                }
            } else if world.isLandAt(x: generatedX, y: generatedY) {
                
                canMakeChild = true
                let child = Person(childOf: self, xNew: self.x, yNew: self.y, newColonyID: self.colonyID)
                world.people[child.x][child.y] = child
                
                x = generatedX
                y = generatedY
                reproductionValue = 0
                world.people[x][y] = self
            }
        }
        
    }
    
    func die() {
        self.isAlive = false
        world.people[self.x][self.y] = nil
    }
}
extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

