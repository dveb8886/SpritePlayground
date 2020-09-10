//
//  SelfChannelSpell.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/29/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit

// === Ideas
// Upgrade to be able to send keystrokes to the channeled spell (to possibly control a remote entity)
class SelfChannel : Spell {
    var channeling: Bool = false
    
    
    var startEffect: Effect
    var channeling_periods = 0
    var period = 0.01
    
    var cooldown: Double
    var cooling = false
    
    init(cooldown: Double, startEffect: Effect){
        self.cooldown = cooldown
        self.startEffect = startEffect
    }
    
    func cast(attr: [EffectAttr : Any]) {
        if !self.channeling {
            let cloned = self.startEffect.clone()
            let success = cloned.start(attr: attr)
            if success {  // we apply channel flag only if the effect actually activated
                let target = attr[.TARGET] as! Unit
                var sequence: SKAction?
                
                self.channeling = true
                sequence = SKAction.sequence([
                    SKAction.wait(forDuration: self.period),
                    SKAction.run {
                        self.channeling_periods += 1
                        if self.channeling_periods > 1 {
                            self.channeling = false
                        } else {
                            target.run(sequence!)
                        }
                    }
                ])
                
                target.run(sequence!)
            }
        }
        self.channeling_periods = 0
    }
    
    
    

}
