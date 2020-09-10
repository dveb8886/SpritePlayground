//
//  ReverseEffect.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/29/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit

// changes the direction of a target
class DirectionEffect : Effect {
    var channelingSpell: Spell? = nil
    var direction: FacingRelative
    
    init(direction: FacingRelative){
        self.direction = direction
    }
    
    func start(attr: [EffectAttr : Any]) -> Bool {
        let target = attr[.TARGET] as! Entity
        target.facing_dir = direction.relate(to: target.facing_dir)
        target.moving_dir = direction.relate(to: target.moving_dir)
        
        return true
    }
    
    func clone() -> Effect {
        let result = DirectionEffect(direction: self.direction)
        result.channelingSpell = self.channelingSpell
        return result
    }
    
    
}
