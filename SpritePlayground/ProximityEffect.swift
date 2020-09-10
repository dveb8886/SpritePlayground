//
//  ProximityEffect.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/31/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit

class ProximityEntity : Entity {
    let owner: Entity
    let parentEffect: ProximityEffect
    
    init(owner: Entity, parentEffect: ProximityEffect){
        self.owner = owner
        self.parentEffect = parentEffect
        let texture = SKTexture(imageNamed: "Blank")
        super.init(texture: texture, color: SKColor.white, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didBegin(contact: SKPhysicsContact, target: Entity){
        var _ = self.parentEffect.detectEffect.start(attr: [
            .TARGET: self.owner,
            .COLLIDE_TARGET: target
        ])
    }
}

class ProximityEffect : Effect {
    var channelingSpell: Spell? = nil
    var duration: Double
    var range: Double
    var detectEffect: Effect
    
    init(duration: Double = 1.0, range: Double = 32, detectEffect: Effect){
        self.duration = duration
        self.range = range
        self.detectEffect = detectEffect
    }
    
    func start(attr: [EffectAttr : Any]) -> Bool {
        let target = attr[.TARGET] as! Entity
        let node = ProximityEntity(owner: target, parentEffect: self)
        node.name = "proximity"
        node.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.range))
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.categoryBitMask = GameScene.ColliderType.PROXIMITY.rawValue
        node.physicsBody?.contactTestBitMask = GameScene.ColliderType.UNIT.rawValue + GameScene.ColliderType.PROJECTILE.rawValue
        node.physicsBody?.isDynamic = false
        target.addChild(node)
        
        var sequence: SKAction?
        sequence = SKAction.sequence([
            SKAction.wait(forDuration: self.duration),
            SKAction.run {
                if self.channelingSpell?.channeling ?? false {
                    target.run(sequence!)
                } else {
                    target.removeChildren(in: [node])
                }
            }
        ])
        
        target.run(sequence!)
        
        return true
    }
    
    func clone() -> Effect {
        let result = ProximityEffect(duration: self.duration, range: self.range, detectEffect: self.detectEffect.clone())
        result.channelingSpell = self.channelingSpell
        return result
    }
    
    
}
