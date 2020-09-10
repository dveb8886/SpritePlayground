//
//  Bullet.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/13/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit
import Carbon.HIToolbox.Events  // kVK

class Bullet : Entity, Projectile {
    
    var moveSpeed: CGFloat
    
    var impactEffect: Effect
    var spawnerEffect: Effect?
    
    var moving = true
    
    
    init(impactEffect: Effect){
        let texture = SKTexture(imageNamed: "Bullet")
        self.moveSpeed = 3.0
        self.impactEffect = impactEffect
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        
        self.name = "bullet"
        self.speed = 3.0
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(dir: Facing, rotate: Bool = true){
        moving_dir = dir
        if dir == .NORTH {
            if rotate {self.zRotation = 0}
        } else if dir == .SOUTH {
            if rotate {self.zRotation = .pi}
        } else if dir == .WEST {
            if rotate {self.zRotation = .pi / 2}
        } else if dir == .EAST {
            if rotate {self.zRotation = 3 * .pi / 2}
        }
        
    }
    
    func teleport(x: CGFloat, y: CGFloat){
        self.position.x = x
        self.position.y = y
    }
    
    override func update(keys: Set<Int>, currentTime: TimeInterval){
        if moving {
            if moving_dir == .NORTH {
                self.position.y = self.position.y + speed
            } else if moving_dir == .SOUTH {
                self.position.y = self.position.y - speed
            } else if moving_dir == .WEST {
                self.position.x = self.position.x - speed
            } else if moving_dir == .EAST {
                self.position.x = self.position.x + speed
            }
        }
    }
    
    func clone() -> Projectile {
        let bullet = Bullet(impactEffect: self.impactEffect)
        bullet.moveSpeed = self.moveSpeed
        bullet.impactEffect = self.impactEffect.clone()
        bullet.spawnerEffect = self.spawnerEffect?.clone()
        return bullet
    }
    
    func setPosition(x: CGFloat, y: CGFloat) {
        self.position = CGPoint(x: x, y: y)
    }
    
    func setFacing(dir: Facing) {
        self.moving_dir = dir
    }
    
    func getSize() -> CGSize {
        return self.size
    }
    
    func getMover() -> Effect {
        return MoveEffect(dir: self.facing_dir, speed: 3.0)
    }
    
    override func didBegin(contact: SKPhysicsContact, target: Entity){
//        if !target.bool_attr["ethereal"]! {
            self.removeFromParent()
            GameScene.instance?.bullets.remove(at: (GameScene.instance?.bullets.firstIndex(of: self))!)
            print("bullet contact")
//            if target is Unit {
            print("target contact")
            let dict: [EffectAttr: Any] = [
                .TARGET: target,
                .FACING: self.moving_dir
            ]
            var _ = self.impactEffect.start(attr: dict)
//            }
//        }
    }
}
