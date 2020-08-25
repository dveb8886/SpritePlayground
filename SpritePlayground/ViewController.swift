//
//  ViewController.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/11/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size: view.frame.size)
//        let scene = IssuePhysics(size: view.frame.size)
        let skView = view as! SKView
        skView.presentScene(scene)
    }
}

