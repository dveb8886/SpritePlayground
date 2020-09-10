//
//  RepeatingEffect.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/30/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit

// ==== Ideas
// upgrade to be able to alternate from a list
class RepeatingEffect : Effect {
    var channelingSpell: Spell? = nil
    var startEffect: Effect?
    var repeatingEffect: Effect
    var endEffect: Effect?
    var period: Double
    var count: Int
    
    init(repeatingEffect: Effect, count: Int = 5, period: Double = 1.0){
        self.repeatingEffect = repeatingEffect
        self.period = period
        self.count = count
    }
    
    func start(attr: [EffectAttr : Any]) -> Bool {
        let target = attr[.TARGET] as! Entity
        
        var sequence: SKAction?
        var executed_times = 0
        var _ = self.startEffect?.start(attr: attr)
        sequence = SKAction.sequence([
            SKAction.wait(forDuration: self.period),
            SKAction.run {
                var _ = self.repeatingEffect.start(attr: attr)
                executed_times += 1
                print(executed_times)
                if executed_times < self.count {  // if there are still counts, left, repeat it
                    print("repeating bc count")
                    target.run(sequence!)
                } else { // if no counts left, then we channel (assuming player is still channeling)
                    if self.channelingSpell?.channeling ?? false {
                        print("repeating channeling")
                        target.run(sequence!)
                    } else {
                        print("end, running end effect")
                        var _ = self.endEffect?.start(attr: attr)
                    }
                }
                
            }
        ])
        
        target.run(sequence!)
        
        return true
    }
    
    func clone() -> Effect {
        let result = RepeatingEffect(repeatingEffect: self.repeatingEffect.clone(), count: self.count, period: self.period)
        result.channelingSpell = self.channelingSpell
        result.startEffect = self.startEffect?.clone()
        result.endEffect = self.endEffect?.clone()
        return result
    }
    
    
}
