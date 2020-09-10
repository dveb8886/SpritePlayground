//
//  Rock.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 9/4/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit
import Carbon.HIToolbox.Events  // kVK

class RockProjectile : Entity, Projectile {
    var moveSpeed: CGFloat
    var impactEffect: Effect
    var arriveEffect: Effect?
    var endEffect: Effect?
    var duration: Double = 5.0
    var distance: Int = 3
    var mover: MoveEffect? = nil
    
    init(impactEffect: Effect){
        self.impactEffect = impactEffect
        let texture = SKTexture(imageNamed: "Bullet")
        self.moveSpeed = 1.0
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
        if self.bool_attr["moving"] == true {  // impact effect occurs only when projectile is moving, it does nothing at rest
            self.mover?.collide(attr: [
                .TARGET: self,
                .COLLIDE_TARGET: target
            ])
            _ = self.impactEffect.start(attr: [
                .TARGET: target,
                .COLLIDE_TARGET: self,
                .FACING: self.facing_dir
            ])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clone() -> Projectile {
        let result = RockProjectile(impactEffect: self.impactEffect.clone())
        result.arriveEffect = self.arriveEffect?.clone()
        result.endEffect = self.endEffect?.clone()
        result.moveSpeed = self.moveSpeed
        result.duration = self.duration
        result.distance = self.distance
        return result
    }
    
    func getMover() -> Effect {
        let mover = MoveEffect(dir: self.facing_dir, speed: Double(self.moveSpeed), rotate: false, distance: self.distance)
        mover.arriveEffect = self.arriveEffect?.clone()
//        mover.arriveEffect = MultipleEffect(startingEffects: [])
        mover.slowdown = true
        self.mover = mover
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
