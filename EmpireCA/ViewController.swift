//
//  ViewController.swift
//  EmpireCA
//
//  Created by Andrius on 9/1/17.
//  Copyright © 2017 Andrius. All rights reserved.
//


// TODO List - note that this isn't written in a priority manner.
// FIX THE TIMER! (this is important, others are just ideas)
// 1) Make the pixel the new person is moving to - 1 cleared. THEN draw onto as it makes this weird color.
// 2) Make people die
// 3) Make people check around 4 directions if movement possible, if not then simply wait until there is a spot. (store the max reproduction value as a variable)
// and if it reaches that and cant move - just wait as I said.
// 5) Fighting next?
// 6) When updating a persons coordinates, if they cant move DO NOT update them!
// 7) Add unique colors for the colony
// 8) Make so pixels cant cross max view frame

import UIKit
var timer: Timer!
var timerinterval = 0
class ViewController: UIViewController {
    var world = World(colonyCount: 6)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBackgroundImage()
        world.startHumanity(view: self.view)
        
        timer = .scheduledTimer(withTimeInterval: 1/60, repeats: true) { (timer) in
            self.update()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createBackgroundImage() {
        let backgroundImage = UIImageView(frame: view.frame)
        backgroundImage.image = UIImage(named: "world_map.png")
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func update() {
        world.update()
        world.render()
        //World(colonyCount: 3).lifeTick(view: self.view)
    }
}

