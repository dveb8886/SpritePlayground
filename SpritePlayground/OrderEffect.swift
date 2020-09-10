//
//  OrderEffect.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/31/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation

// issues an order to the target
class OrderEffect : Effect {
    var channelingSpell: Spell? = nil
    
    let keyCombo: KeyCombo
    
    init(keyCombo: KeyCombo){
        self.keyCombo = keyCombo
    }
    
    func start(attr: [EffectAttr : Any]) -> Bool {
        let target = attr[.TARGET] as! Unit
        let spell = target.abilities[self.keyCombo]
        let dict: [EffectAttr: Any] = [
            .FACING: target.moving_dir,
            .TARGET: target
        ]
        spell?.cast(attr: dict)
        
        return true
    }
    
    func clone() -> Effect {
        let result = OrderEffect(keyCombo: self.keyCombo)
        result.channelingSpell = self.channelingSpell
        return result
    }
    
    
}
