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
var imageName = "world_map_full.png"
class ViewController: UIViewController {
    var world = World(with: "\(imageName)")
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
        backgroundImage.image = UIImage(named: "\(imageName)")
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func update() {
        world.update()
        world.render()
        //World(colonyCount: 3).lifeTick(view: self.view)
    }
}

