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
    
    var projectileTemplate: Projectile  // Bullet (Entity)
    var arriveEffect: Effect?
    var collideEffect: Effect?
    
    let distance: CGFloat
    
    init(projectileTemplate: Projectile, distance: CGFloat = 5){
        self.projectileTemplate = projectileTemplate
        self.distance = distance
    }
    
    func start(attr: [EffectAttr: Any]) {
        let facing = attr[.FACING] as! Facing
        let target = attr[.TARGET] as! Entity
        
        let spawn_offset = target.size.width / 2.0 + projectileTemplate.getSize().width / 2.0 + 1.0
        let x = target.position.x + facing.vector.dx * spawn_offset
        let y = target.position.y + facing.vector.dy * spawn_offset
        
        var projectile = projectileTemplate.clone()
        projectile.spawnerEffect = self
        projectile.setPosition(x: x, y: y)
        projectile.setFacing(dir: facing)
        GameScene.instance?.world.addChild(projectile as! SKNode)
        GameScene.instance?.bullets.append(projectile as! Bullet)
    }
}
