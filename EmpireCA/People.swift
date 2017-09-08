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
    
    init(newColonyID: Int, xNew: Int, yNew: Int) {
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
        colonyID = newColonyID
        reproductionValue = 0
        x = xNew
        y = yNew
        isAlive = true
        strength = parent.strength + .randomValue(lessThan: 20)
        isDiseased = false
        canMakeChild = false
        let diseasedChance = arc4random_uniform(100)
        if diseasedChance == 99{
            isDiseased = true
        }
    }
    
    func leftDirection(changee: Person) -> Int{
        let leftDirection = changee.x - 1
        return leftDirection
    }
    func rightDirection(changee: Person) -> Int {
        let rightDirection = changee.x + 1
        return rightDirection
    }
    func upDirection(changee: Person) -> Int{
        let upDirection = changee.y + 1
        return upDirection
    }
    func downDirection(changee: Person) -> Int{
        let downDirection = changee.y - 1
        return downDirection
    }
    
    func makeChild(childOf: Person, xNew: Int, yNew: Int, newColonyID: Int) {
        let child = childOf
        child.age = 0
        child.reproductionValue = 0
        child.isAlive = true
        child.isDiseased = false
        child.canMakeChild = false
        child.strength = childOf.strength + .randomValue(lessThan: 200)
        child.x = xNew
        child.y = yNew
    }
    
    func fightDefended(defendant: Person, attacker: Person) -> Bool {
        if defendant.strength >= attacker.strength {
            return true
        } else {
            return false
        }
    }
    func update(world: World) {
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
        let randomX = Int(arc4random_uniform(2))
        let randomX2 = Int(arc4random_uniform(2))
        let randomY = Int(arc4random_uniform(2))
        let randomY2 = Int(arc4random_uniform(2))
        let generatedX = x + (randomX - randomX2)
        let generatedY = y + (randomY - randomY2)
        /*
         var generatedNumbersInput = [0,1,2,3]
         generatedNumbersInput.shuffle()
         generatedNumbersInput = generatedNumbersInput.shuffled()
         var generatedX = 0
         var generatedY = 0
         */
        //here I should cycle through the array of numbers above in an incremented order, make a variable and if generatedNumbersInput.first isnt good then simply +1 the variable and try the second array element if it passes - continue baby creation or fighting.
        
        /* switch generatedNumbersInput.first{
         case 0:
         generatedX = leftDirection(changee: self)
         case 1:
         generatedX = rightDirection(changee: self)
         case 2:
         generatedY = downDirection(changee: self)
         case 3:
         generatedY = upDirection(changee: self)
         default:
         print("ded end")
         }
         */
        
        age = age + 1
        reproductionValue += 1
        if reproductionValue < 10 {
            canMakeChild = false
        }
        if reproductionValue >= 10 {
            
            if world.personAt(x: generatedX, y: generatedY) != nil {
                let defendingPerson = world.personAt(x: generatedX, y: generatedY)
                if defendingPerson?.colonyID != self.colonyID {
                    if fightDefended(defendant: defendingPerson!, attacker: self) {
                        self.isAlive = false
                        defendingPerson?.x = self.x
                        defendingPerson?.y = self.y
                        world.people[(defendingPerson?.x)!][(defendingPerson?.y)!] = defendingPerson
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

