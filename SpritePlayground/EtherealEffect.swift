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
    var channelingSpell: Spell? = nil
    var endEffect: Effect?
    
    init(duration: Double = 5.0){
        self.duration = duration
    }
    
    func start(attr: [EffectAttr : Any]) -> Bool {
        let target = attr[.TARGET] as! Entity
        let tmp_categoryMask = target.physicsBody?.categoryBitMask
        let tmp_contactMask = target.physicsBody?.contactTestBitMask
        let tmp_collideMask = target.physicsBody?.collisionBitMask
        target.bool_attr["ethereal"] = true
        target.physicsBody?.categoryBitMask -= tmp_categoryMask!
        target.physicsBody?.contactTestBitMask -= tmp_contactMask!
        target.physicsBody?.collisionBitMask -= tmp_collideMask!
        target.color = SKColor.init(red: 0.7, green: 0.7, blue: 1.0, alpha: 0.5)
        
        var sequence: SKAction?
        sequence = SKAction.sequence([
            SKAction.wait(forDuration: self.duration),
            SKAction.run {
                if self.channelingSpell?.channeling ?? false {
                    print("ethereal refresh")
                    target.run(sequence!)
                } else {
                    print("ethereal end")
                    target.bool_attr["ethereal"] = false
                    target.physicsBody?.categoryBitMask += tmp_categoryMask!
                    target.physicsBody?.contactTestBitMask += tmp_contactMask!
                    target.physicsBody?.collisionBitMask += tmp_contactMask!
                    target.color = SKColor.white
                    var _ = self.endEffect?.start(attr: attr)
                }
            }
        ])
        
        target.run(sequence!)
        
        return true
    }
    
    func clone() -> Effect {
        let result = EtherealEffect(duration: self.duration)
        result.channelingSpell = self.channelingSpell
        result.endEffect = self.endEffect?.clone()
        return result
    }
    
    
}
