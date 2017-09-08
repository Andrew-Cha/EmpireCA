//
//  ViewController.swift
//  EmpireCA
//
//  Created by Andrius on 9/1/17.
//  Copyright © 2017 Andrius. All rights reserved.
//


// TODO List - note that this isn't written in a priority manner.
// 3) Make people check around 4 directions if movement possible, if not then simply wait until there is a spot. (store the max reproduction value as a variable)
// same as #9
// and if it reaches that and cant move - just wait as I said.
// 7) Add unique colors for the colony instaed of generating them like a goober
// 8) Make so pixels cant cross max view frame
// 9) If cant move in one direction, check the other 3.
// 10) When a fight is won the defendant moves into the attackers position AND makes a baby instantly. Kinda done? Recheck!
import UIKit
var timer: Timer!
var timerinterval = 0
class ViewController: UIViewController {
    var world = World(colonyCount: 6)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBackgroundImage()
        world.startHumanity(view: self.view)
        
        timer = .scheduledTimer(withTimeInterval: 1/180, repeats: true) { (timer) in
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

