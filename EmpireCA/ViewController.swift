//
//  ViewController.swift
//  EmpireCA
//
//  Created by Andrius on 9/1/17.
//  Copyright © 2017 Andrius. All rights reserved.
//

import UIKit
var timer: Timer!
var timerinterval = 0
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBackgroundImage()
        World(colonyCount: 275826).startHumanity(view: self.view)
        timer = .scheduledTimer(withTimeInterval: 1/60, repeats: true) { (timer) in
            self.update()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createBackgroundImage(){
        let backgroundImage = UIImageView(frame: view.frame)
        backgroundImage.image = UIImage(named: "world_map.png")
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func update(){
        print("The current time of the timer is  \(timerinterval)")
        timerinterval = timerinterval + 1
        if timerinterval == 0 {
            timerinterval = 0
        }
    }
}

