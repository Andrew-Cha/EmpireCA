//
//  ViewController.swift
//  EmpireCA
//
//  Created by Andrius on 9/1/17.
//  Copyright © 2017 Andrius. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBackgroundImage()
        World(colonyCount: 275826).startHumanity(view: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createBackgroundImage(){
        let backgroundImage = UIImageView(frame: view.frame)
        backgroundImage.image = UIImage(named: "world_map.png")
        self.view.insertSubview(backgroundImage, at: 0)
    }

}

