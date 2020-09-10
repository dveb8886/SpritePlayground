//
//  Ember.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 9/7/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit
import Carbon.HIToolbox.Events  // kVK

class EmberProjectile : Entity, Projectile {
    var moveSpeed: CGFloat
    var impactEffect: Effect
    var endEffect: Effect?
    var duration: Double = 1.0
    
    init(impactEffect: Effect){
        self.impactEffect = impactEffect
        let texture = SKTexture(imageNamed: "Bullet")
        self.moveSpeed = 0.3
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        self.name = "bullet"
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.categoryBitMask = GameScene.ColliderType.PROJECTILE.rawValue
        self.physicsBody!.contactTestBitMask =
            GameScene.ColliderType.UNIT.rawValue +
            GameScene.ColliderType.TERRAIN.rawValue +
            GameScene.ColliderType.PROJECTILE.rawValue
        self.physicsBody!.collisionBitMask =
            GameScene.ColliderType.UNIT.rawValue +
            GameScene.ColliderType.TERRAIN.rawValue +
            GameScene.ColliderType.PROJECTILE.rawValue
        
        let timer = SKAction.sequence([
            SKAction.wait(forDuration: self.duration),
            SKAction.run {
                _ = self.endEffect?.start(attr: [
                    .TARGET: self,
                    .FACING: self.facing_dir
                ])
                self.removeFromParent()
            }
        ])
        
        self.run(timer)
        
    }
    
    override func update(keys: Set<Int>, currentTime: TimeInterval) {
        
    }
    
    override func didBegin(contact: SKPhysicsContact, target: Entity) {
        _ = self.impactEffect.start(attr: [
            .TARGET: target,
            .COLLIDE_TARGET: self,
            .FACING: self.facing_dir
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clone() -> Projectile {
        let result = EmberProjectile(impactEffect: self.impactEffect.clone())
        result.endEffect = self.endEffect?.clone()
        result.moveSpeed = self.moveSpeed
        result.duration = self.duration
        return result
    }
    
    func getMover() -> Effect {
        let mover = MoveEffect(dir: self.facing_dir, speed: Double(self.moveSpeed), rotate: false, distance: 1)
        mover.neverStop = true
        return mover
    }
    
    func setPosition(x: CGFloat, y: CGFloat) {
        self.position = CGPoint(x: x, y: y)
        self.cur_tile_pos = World.convertToTile(x: self.position.x, y: self.position.y)
    }
    
    func setFacing(dir: Facing) {
        self.moving_dir = dir
        self.facing_dir = dir
    }
    
    func getSize() -> CGSize {
        return self.size
    }
    
    
}
