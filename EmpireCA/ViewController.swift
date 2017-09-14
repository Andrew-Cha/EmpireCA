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

class ViewController: UIViewController {
    @IBOutlet weak var backgroundMap: UIScrollView!
    var world = World()
    override func viewDidLoad() {
        super.viewDidLoad()
        world.startHumanity()
        
        timer = .scheduledTimer(withTimeInterval: 1/60, repeats: true) { (timer) in
            self.update()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func update() {
        world.update()
        world.render()
        //World(colonyCount: 3).lifeTick(view: self.view)
    }
}

