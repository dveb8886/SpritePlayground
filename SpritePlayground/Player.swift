//
//  Player.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/12/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit
import Carbon.HIToolbox.Events  // kVK

class Player  : Unit {
    
    
    
    init(){
        super.init(imageNamed: "Arrow", name: "player")
        self.speed = 3.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(keys: [Int: Bool], currentTime: TimeInterval){
        if !moving {
            if keys[kVK_ANSI_W] ?? false {
                move(dir: DIR_UP)
            } else if keys[kVK_ANSI_S] ?? false {
                move(dir: DIR_DOWN)
            } else if keys[kVK_ANSI_A] ?? false {
                move(dir: DIR_LEFT)
            } else if keys[kVK_ANSI_D] ?? false {
                move(dir: DIR_RIGHT)
            }
        }
        
        if !currentTime.isLess(than: shoot_delay) && keys[kVK_Space] ?? false {
            shoot_delay = currentTime + 1
            shoot()
        }
        
        updateMovement()
    }
    
}
