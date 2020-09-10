//
//  CreateProjectile.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/28/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit

class CreateProjectile : Effect {
    var channelingSpell: Spell? = nil
    
    
    var projectileTemplate: Projectile  // Bullet (Entity)
    var arriveEffect: Effect?
    var collideEffect: Effect?
    
    var projectileEffect: Effect?
    
    let distance: CGFloat
    
    init(projectileTemplate: Projectile, distance: CGFloat = 5){
        self.projectileTemplate = projectileTemplate
        self.distance = distance
    }
    
    func start(attr: [EffectAttr: Any]) -> Bool {
        let facing = attr[.FACING] as! Facing
        let target = attr[.TARGET] as! Entity
        
        let spawn_offset = target.size.width / 2.0 + projectileTemplate.getSize().width / 2.0 + 1.0
        let x = target.position.x + facing.vector.dx * spawn_offset
        let y = target.position.y + facing.vector.dy * spawn_offset
        
        let projectile = projectileTemplate.clone()
        projectile.setPosition(x: x, y: y)
        projectile.setFacing(dir: facing)
//        print("before projectile effect")
        var _ = projectileEffect?.start(attr: [
            .TARGET: projectile
        ])
//        print("after projectile effect")
        GameScene.instance?.world.addChild(projectile as! SKNode)
        GameScene.instance?.bullets.append(projectile as! Bullet)
        
        return true
    }
    
    func clone() -> Effect {
        let result = CreateProjectile(projectileTemplate: self.projectileTemplate.clone(), distance: self.distance)
        result.channelingSpell = self.channelingSpell
        result.arriveEffect = self.arriveEffect?.clone()
        result.collideEffect = self.collideEffect?.clone()
        result.projectileEffect = self.projectileEffect?.clone()
        return result
    }
}
