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
    let width = 1334
    let height = 750
    let backgroundImage = UIImage(named: "world_map.png")
    var people: [[Person?]]
    
    init(colonyCount: Int) {
        colonyNumber = colonyCount
        people = [[Person?]](repeating: [Person?](repeating: nil, count: height), count: width)
    }
    
    func startHumanity(view: UIView) {
        let bitmap = Bitmap(width: width, height: height)
        for id in 0..<colonyNumber {
            while true {
                let x = Int(arc4random_uniform(UInt32(height)))
                let y = Int(arc4random_uniform(UInt32(width)))
                if (backgroundImage?.isLand(at: CGPoint(x: x, y: y)))! && personAt(x: x, y: y) == nil {
                    let person = Person(colonyID: id, x: x, y: y)
                    bitmap[x, y] = Bitmap.Pixel(r: 40, g: 0, b: 0, a: 255)
                    let backgroundImage = UIImageView(frame: view.frame)
                    backgroundImage.image = UIImage(cgImage: bitmap.cgImage())
                    view.insertSubview(backgroundImage, aboveSubview: view)
                    // somehow add the person to the data structure
                    break // get out of the while loop
                }
            }
        }
    }
    
    
    func personAt(x: Int, y: Int) -> Person? {
        if x > width, x < 0, y > height, y < 0 {
            return nil
        } else {
            return people[x][y]
        }
    }
}

extension UIImage {
    func isLand(at pos: CGPoint) -> Bool {
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        //  let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = data[pixelInfo+1]
        let b = data[pixelInfo+2]
        // let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        if g > 150, b < 50{
            return true
        } else {
            return false
        }
    }
}
