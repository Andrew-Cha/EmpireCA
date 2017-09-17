//
//  ViewController.swift
//  EmpireCA
//
//  Created by Andrius on 9/1/17.
//  Copyright © 2017 Andrius. All rights reserved.
//


// Make so pixels cant cross max view frame
import UIKit

var timer: Timer!
var timerUpdate: Timer!
class SimulationViewController: UIViewController {
    
    @IBOutlet weak var backgroundMap: UIImageView!
    @IBOutlet weak var mapScrollView: UIScrollView!

    var world = World()
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundMap.image = world.startHumanity()
        backgroundMap.image = world.render()
        
        timer = .scheduledTimer(withTimeInterval: 1/60, repeats: true) { (timer) in
            self.update()
        }
        timer = .scheduledTimer(withTimeInterval: 1/60, repeats: true) { (timer) in
            self.updateMap()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func update() {
        world.update()
    
    }
    func updateMap() {
        backgroundMap.image = world.render()
    }
}

