//
//  World.swift
//  EmpireCA
//
//  Created by Andrius on 9/2/17.
//  Copyright © 2017 Andrius. All rights reserved.
//

import Foundation
import UIKit

let colonyColors = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)]
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
        
        for id in 1..<colonyNumber {
            print(id)
            while true {
                let x = Int.randomValue(lessThan: width)
                let y = Int.randomValue(lessThan: height)
                
                if isLandAt(x: x, y: y) && personAt(x: x, y: y) == nil {
                    let person = Person(newColonyID: id, xNew: x, yNew: y, worldPassed: self)
                    let randomR: UInt8 = UInt8(0 + (person.colonyID * 20) + 125)
                    let randomG: UInt8 = UInt8(0 + (person.colonyID * 20) + 120)
                    let randomB: UInt8 = UInt8(0 + (person.colonyID * 20) + 110)
                    people[x][y] = person
                    bitmap[person.x, person.y] = Pixel(r: randomR, g: randomG, b: randomB, a: 255)
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
            person.update()
        }
    }
    
    func render() {
        for x in 0..<width {
            for y in 0..<height {
                if let person = people[x][y] {
                    if person.isAlive == true {
                        bitmap[person.x, person.y] = Pixel(red: <#T##BinaryFloatingPoint#>, green: <#T##BinaryFloatingPoint#>, blue: <#T##BinaryFloatingPoint#>)
                    } else {
                        bitmap[x, y] = .clear
                    }
                }
            }
        }
        imageViewStored?.image = UIImage(cgImage: (bitmap.cgImage()))
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
