//
//  EtherealEffect.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/28/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit

class EtherealEffect : Effect {
    
    let duration: Double
    
    init(duration: Double = 5.0){
        self.duration = duration
    }
    
    func start(attr: [EffectAttr : Any]) {
        let target = attr[.TARGET] as! Entity
        let tmp_categoryMask = target.physicsBody?.categoryBitMask
        let tmp_contactMask = target.physicsBody?.contactTestBitMask
        target.bool_attr["ethereal"] = true
        target.physicsBody?.categoryBitMask -= tmp_categoryMask!
        target.physicsBody?.contactTestBitMask -= tmp_contactMask!
//        target.physicsBody?.collisionBitMask -= GameScene.ColliderType.TERRAIN.rawValue
        // add code to detect if this collider bit is in use, so it doesn't get accidentally added later
        target.color = SKColor.init(red: 0.7, green: 0.7, blue: 1.0, alpha: 0.5)
        
        target.run(SKAction.sequence([
            SKAction.wait(forDuration: self.duration),
            SKAction.run {
                target.bool_attr["ethereal"] = false
                target.physicsBody?.categoryBitMask += tmp_categoryMask!
                target.physicsBody?.contactTestBitMask += tmp_contactMask!
//                target.physicsBody?.collisionBitMask += GameScene.ColliderType.TERRAIN.rawValue
                target.color = SKColor.white
            }
        ]))
        
        
    }
    
    
}
