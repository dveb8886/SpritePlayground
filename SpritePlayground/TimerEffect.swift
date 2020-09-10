//
//  TimerEffect.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/30/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit

class TimerEffect : Effect {
    
    let duration: Double
    var channelingSpell: Spell? = nil
    var endEffect: Effect?
    
    init(duration: Double = 5.0){
        self.duration = duration
    }
    
    func start(attr: [EffectAttr : Any]) -> Bool {
        let target = attr[.TARGET] as! Entity
        
        var sequence: SKAction?
        sequence = SKAction.sequence([
            SKAction.wait(forDuration: self.duration),
            SKAction.run {
                if self.channelingSpell?.channeling ?? false {
                    target.run(sequence!)
                } else {
                    var _ = self.endEffect?.start(attr: attr)
                }
            }
        ])
        
        target.run(sequence!)
        
        return true
    }
    
    func clone() -> Effect {
        let result = TimerEffect(duration: self.duration)
        result.channelingSpell = self.channelingSpell
        result.endEffect = self.endEffect?.clone()
        return result
    }
    
    
}
