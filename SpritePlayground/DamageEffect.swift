//
//  Damage.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/28/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation

class DamageEffect : Effect {
    
    var amount: Double
    
    init(amount: Double){
        self.amount = amount
    }
    
    func start(attr: [EffectAttr: Any]) {
        let target = attr[.TARGET] as! Entity
        if target is Unit {
            let unit = target as! Unit
            if !(unit.bool_attr["ethereal"])! {
                unit.damage(amt: amount)
            }
        }
    }
    
}
