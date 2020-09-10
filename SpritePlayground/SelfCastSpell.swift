//
//  MakeEthereal.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/28/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit

class SelfCast : Spell {
    var channeling: Bool = false // not used here
    
    
    let cooldown: Double
    var cooling: Bool = false
    
    var startEffect: Effect
    
    init(cooldown: Double = 15.0, startEffect: Effect){
        self.cooldown = cooldown
        self.startEffect = startEffect
    }
    
    func cast(attr: [EffectAttr : Any]) {
        if !cooling {
            let clonedSpell = self.startEffect.clone()
            let success = clonedSpell.start(attr: attr)
            if success {
                let target = attr[.TARGET] as! Unit
                
                if self.cooldown > 0 {
                    self.cooling = true
                    target.run(SKAction.sequence([
                        SKAction.wait(forDuration: self.cooldown),
                        SKAction.run {
                            self.cooling = false
                        }
                    ]))
                }
            }
        }
    }
    
    
}
