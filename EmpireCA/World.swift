//
//  World.swift
//  EmpireCA
//
//  Created by Andrius on 9/2/17.
//  Copyright © 2017 Andrius. All rights reserved.
//

import Foundation
import UIKit
class World {
    var colonyNumber = 0
    let width = 1280
    let height = 720
    let backgroundImage = UIImage(named: "world_map.png")!
    var people: [[Person?]]
    let bitmap: Bitmap
    var pixelData: CFData
    let imageData: UnsafePointer<UInt8>!
    var imageViewStored: UIImageView?
    
    init(colonyCount: Int) {
        bitmap = Bitmap(width: width, height: height)
        pixelData = backgroundImage.cgImage!.dataProvider!.data!
        imageData = CFDataGetBytePtr(pixelData)
        colonyNumber = colonyCount
        people = .init(repeating: .init(repeating: nil, count: height), count: width)
    }
    
    func startHumanity(view: UIView) {
        
        for id in 0..<colonyNumber {
            print(id)
            while true {
                let x = Int.randomValue(lessThan: width)
                let y = Int.randomValue(lessThan: height)
                
                if isLandAt(x: x, y: y) && personAt(x: x, y: y) == nil {
                    let person = Person(newColonyID: id, xNew: x, yNew: y)
                    let randomR: UInt8 = UInt8(0 + (person.colonyID * 20) + 125)
                    let randomG: UInt8 = UInt8(0 + (person.colonyID * 20) + 120)
                    let randomB: UInt8 = UInt8(0 + (person.colonyID * 20) + 110)
                    people[x][y] = person
                    bitmap[person.x, person.y] = Bitmap.Pixel(r: randomR, g: randomG, b: randomB, a: 255)
                    break // to get out of the while loop
                }
            }
        }
        let imageView = UIImageView(frame: view.frame)
        imageView.image = UIImage(cgImage: (bitmap.cgImage()))
        imageViewStored = imageView
        view.insertSubview(imageView, aboveSubview: view)
        print("all done!")
    }
    
    func update() {
        let everyone = people.flatMap { $0.flatMap { $0 } }
        for person in everyone {
            person.update(world: self, imageData: imageData)
            // let randomX = Int.randomValue(lessThan: width)
            // let randomY = Int.randomValue(lessThan: height)
            
            
            }
        }
    
    func render() {
        for x in 0...width - 1{
            for y in 0...height - 1 {
               // bitmap[x, y] = Bitmap.Pixel(r: UInt8(randomR), g: UInt8(randomG), b: UInt8(randomB), a: 255)
                if let person = people[x][y] {
                    if person.canMakeChild == true {
                        let randomR: UInt8 = UInt8(0 + (person.colonyID * 20) + 125)
                        let randomG: UInt8 = UInt8(0 + (person.colonyID * 20) + 120)
                        let randomB: UInt8 = UInt8(0 + (person.colonyID * 20) + 110)
                    bitmap[person.x, person.y] = Bitmap.Pixel(r: randomR, g: randomG, b: randomB, a: 255)
                    people[x][y] = person
                        print("Person with X \(person.x) made, Y is \(person.y)")
                    }
                }
            }
        }
        imageViewStored?.image = UIImage(cgImage: (bitmap.cgImage()))
        //view.insertSubview(imageView, aboveSubview: view)
     //   print("all done!")
    }
    func personAt(x: Int, y: Int) -> Person? {
        if x > width, x < 0, y > height, y < 0 {
            return nil
        } else {
            return people[x][y]
        }
    }
    
    func isLandAt(x: Int, y: Int) -> Bool {
        let pixelInfo = (width * y + x) * 4
        let g = imageData[pixelInfo + 1]
        return g > 100
    }
}

extension Int {
    static func randomValue(lessThan bound: Int) -> Int {
        return Int(arc4random_uniform(UInt32(bound)))
    }
}
