//
//  Bitmap.swift
//  EmpireCA
//
//  Created by Andrius on 9/1/17.
//  Copyright © 2017 Andrius. All rights reserved.
//

import Foundation
import UIKit

class Bitmap {
    struct Pixel {
        var r, g, b, a: UInt8
        
        static let clear = Pixel(r: 0, g: 0, b: 0, a: 0)
    }
    
    static let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    static let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue) // TODO .premultipliedLast instead?
    
    var width, height: Int
    var data: [Pixel]
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        data = [Pixel](repeating: .clear, count: width * height)
    }
    
    subscript(x: Int, y: Int) -> Pixel {
        get {
            return data[x + y * width]
        }
        set {
            data[x + y * width] = newValue
        }
    }
    
    func cgImage() -> CGImage {
        let pixelSize = MemoryLayout<Pixel>.size
        let provider = CGDataProvider(data: NSData(bytes: &data, length: data.count * pixelSize))!
        return CGImage(width: width,
                       height: height,
                       bitsPerComponent: 8,
                       bitsPerPixel: 32,
                       bytesPerRow: width * pixelSize,
                       space: Bitmap.rgbColorSpace,
                       bitmapInfo: Bitmap.bitmapInfo,
                       provider: provider,
                       decode: nil,
                       shouldInterpolate: false,
                       intent: .defaultIntent)!
    }
}
