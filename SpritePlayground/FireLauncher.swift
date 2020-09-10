//
//  FireLauncher.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 9/8/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit

class FireLauncher : Effect {
    var channelingSpell: Spell?
    var cooldown: Double = 0.3
    var channelPeriod: Double = 0.5
    var projectile: Projectile
    
    init(projectile: Projectile){
        self.projectile = projectile
    }
    
    func executeLaunch(facing: Facing, launcher: Entity) -> Bool{
        let spawn_offset = launcher.size.width / 2.0 + projectile.getSize().width / 2.0 + 1.0
        let x = launcher.position.x + facing.vector.dx * spawn_offset
        let y = launcher.position.y + facing.vector.dy * spawn_offset
        
        let projectile = self.projectile.clone()
        projectile.setFacing(dir: facing)
        projectile.setPosition(x: x, y: y)
        
        GameScene.instance?.world.addChild(projectile as! SKNode)
        
        let mover = projectile.getMover()
        let success = mover.start(attr: [
            .TARGET: projectile,
            .FACING: facing
        ])
        
        return success
    }
    
    func start(attr: [EffectAttr : Any]) -> Bool {
        let facing = attr[.FACING] as! Facing
        let launcher = attr[.TARGET] as! Entity
        
        if self.channelingSpell != nil {
            var timer: SKAction? = nil
            timer = SKAction.sequence([
                SKAction.wait(forDuration: self.channelPeriod),
                SKAction.run {
                    if self.channelingSpell?.channeling ?? false {
                        _ = self.executeLaunch(facing: facing, launcher: launcher)
                        launcher.run(timer!)
                    }
                }
            ])
            
            launcher.run(timer!)
            return true
        } else {
            return self.executeLaunch(facing: facing, launcher: launcher)
        }
        
    }
    
    func clone() -> Effect {
        let result = EarthLauncher(projectile: self.projectile.clone())
        result.channelingSpell = self.channelingSpell
        result.cooldown = self.cooldown
        return result
    }
    
    
}
