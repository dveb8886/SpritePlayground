//
//  Enemy.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/13/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit
import Carbon.HIToolbox.Events  // kVK

class Enemy  : Unit {
    
    init(){
        super.init(imageNamed: "Circle", name: "enemy")
        self.speed = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func update(keys: [Int: Bool], currentTime: TimeInterval){
        if !moving {
            move(dir: Int.random(in: 0...3))
        }
        
        updateMovement()
    }
    
    
}
