//
//  Damage.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/28/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation

// === Ideas
// Upgrade to be able to do extra things like ignore armor or shields
class DamageEffect : Effect {
    
    var channelingSpell: Spell? = nil
    var amount: Double
    
    init(amount: Double){
        self.amount = amount
    }
    
    func start(attr: [EffectAttr: Any]) -> Bool {
        let target = attr[.TARGET] as! Entity
        if target is Unit {
            let unit = target as! Unit
            if !(unit.bool_attr["ethereal"])! {
                unit.damage(amt: amount)
            }
        }
        return true
    }
    
    func clone() -> Effect {
        let result = DamageEffect(amount: self.amount)
        result.channelingSpell = self.channelingSpell
        return result
    }
    
}
