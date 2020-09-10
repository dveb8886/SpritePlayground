//
//  SplitEffect.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/29/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit

class SplitEffect : Effect {
    var channelingSpell: Spell? = nil
    
    var startEffect: Effect?
    var removeOriginal: Bool
    var shootDirections: [FacingRelative]
    
    init(startEffect: Effect? = nil, shootDirections: [FacingRelative] = FacingRelative.all, removeOriginal: Bool = true){
        self.startEffect = startEffect
        self.shootDirections = shootDirections
        self.removeOriginal = removeOriginal
    }
    
    func start(attr: [EffectAttr : Any]) -> Bool {
        let target = attr[.TARGET] as! Entity
        let facing = target.moving_dir
        let tile = World.convertToTile(x: target.position.x, y: target.position.y)
        print(tile.debugDescription)
        target.teleport(x: Int(round(tile.x)), y: Int(round(tile.y)))
        print(target.cur_tile_pos.debugDescription)
        print(target.position.debugDescription)
        var dict: [EffectAttr: Any] = [
            .TARGET: target
        ]
        
        for shootDir in self.shootDirections {
            dict[.FACING] = shootDir.relate(to: facing)
            var _ = self.startEffect?.start(attr: dict)
        }
        
//        if !self.perpendicular || facing == .NORTH || facing == .SOUTH {
//            dict[.FACING] = Facing.WEST
//            var _ = self.startEffect?.start(attr: dict)
//            
//            dict[.FACING] = Facing.EAST
//            var _ = self.startEffect?.start(attr: dict)
//        }
//        
//        
//        if !self.perpendicular || facing == .WEST || facing == .EAST {
//            dict[.FACING] = Facing.NORTH
//            var _ = self.startEffect?.start(attr: dict)
//            
//            dict[.FACING] = Facing.SOUTH
//            var _ = self.startEffect?.start(attr: dict)
//        }
        
        if removeOriginal {
            World.instance?.removeChildren(in: [target])
        }
        
        return true
    }
    
    func clone() -> Effect {
        let result = SplitEffect(startEffect: self.startEffect?.clone(), shootDirections: self.shootDirections, removeOriginal: self.removeOriginal)
        result.channelingSpell = self.channelingSpell
        return result
    }
    
    
}

