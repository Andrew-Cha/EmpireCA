//
//  Colonies.swift
//  EmpireCA
//
//  Created by Andrius on 9/1/17.
//  Copyright © 2017 Andrius. All rights reserved.
//

import Foundation
import UIKit

let colors: [UIColor] = [.red, .blue, .brown]

struct Colony {
    var citizens: [Person] = []
    let colonyID: Int
    let color: UIColor
    
    init(withID id: Int) {
        colonyID = id
        color = colors[id]
    }
}
