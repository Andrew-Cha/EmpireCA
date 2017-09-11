//
//  World.swift
//  EmpireCA
//
//  Created by Andrius on 9/2/17.
//  Copyright © 2017 Andrius. All rights reserved.
//

import Foundation
import UIKit

let colors: [UIColor] = [.white, .black, .cyan, .magenta, .red]
class World {
    let width = 1280
    let height = 720
    var backgroundImage = UIImage(named: "")!
    var people: [[Person?]]
    let bitmap: Bitmap
    var pixelData: CFData
    let imageData: UnsafePointer<UInt8>!
    var imageViewStored: UIImageView?
    
    init(with image: String) {
        backgroundImage = UIImage(named: "\(image)")!
        bitmap = Bitmap(width: width, height: height)
        pixelData = backgroundImage.cgImage!.dataProvider!.data!
        imageData = CFDataGetBytePtr(pixelData)
        people = .init(repeating: .init(repeating: nil, count: height), count: width)
    }
    
    func startHumanity(view: UIView) {
        
        for id in 0..<colors.count{
            print(id)
            while true {
                let x = Int.randomValue(lessThan: width)
                let y = Int.randomValue(lessThan: height)
                
                if isLandAt(x: x, y: y) && personAt(x: x, y: y) == nil {
                    let uiColor = colors[id]
                    let person = Person(newColonyID: id, xNew: x, yNew: y, worldPassed: self)
                    people[x][y] = person
                    bitmap[person.x, person.y] = Pixel(uiColor)
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
                    let uiColor = colors[person.colonyID]
                    bitmap[x, y] = Pixel(uiColor)
                } else {
                    bitmap[x, y] = Pixel.clear
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
        return g > 95
    }
}

struct RandomChance{
    var probability: Double
    
    init(of probability: Double) {
        self.probability = probability
    }
    
    func isFulfilled() -> Bool {
        return .randomValueForProbability() < probability
    }
}
extension BinaryFloatingPoint {
    static func randomValueForProbability(in bounds: (lo: Self, hi: Self)? = nil) -> Self {
        let random = Self(arc4random()) / Self(UInt32.max)
        if let (lo, hi) = bounds {
            return lo + (hi - lo) * random
        } else {
            return random
        }
    }
}

extension Int {
    static func randomValue(lessThan bound: Int) -> Int {
        return Int(arc4random_uniform(UInt32(bound)))
    }
}
