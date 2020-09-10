//
//  RotateEffect.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 9/7/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit

class RotateEffect : Effect {
    var channelingSpell: Spell?
    var endEffect: Effect?
    
    var facing: Facing?
    var relative: FacingRelative?
    
    init(facing: Facing? = nil, relative: FacingRelative? = nil){
        self.facing = facing
        self.relative = relative
        if facing == nil && relative == nil {
            self.relative = .BACKWARD
        }
    }
    
    func start(attr: [EffectAttr : Any]) -> Bool {
        let target = attr[.TARGET] as! Entity
        var tmp_facing = self.facing
        if self.relative != nil {
            tmp_facing = self.relative?.relate(to: attr[.FACING] as! Facing)
        }
        target.zRotation = tmp_facing!.zRotation
        target.facing_dir = tmp_facing!
        target.moving_dir = tmp_facing!
        
        return true
    }
    
    func clone() -> Effect {
        let result = RotateEffect()
        result.channelingSpell = self.channelingSpell
        result.endEffect = self.endEffect?.clone()
        return result
    }
    
    
}
