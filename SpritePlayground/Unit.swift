//
//  Unit.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/13/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit
import Carbon.HIToolbox.Events  // kVK

struct KeyCombo: Hashable {
    var keys: [Int]
    
    init(keys: [Int]){
        self.keys = keys
        self.keys.sort()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(keys)
    }

    static func == (lhs: KeyCombo, rhs: KeyCombo) -> Bool {
        return lhs.keys == rhs.keys
    }
}

class Unit  : Entity, Status {
    
    var statuses: [Effect]
    var abilities: [KeyCombo: Spell]
    
    let DIR_UP = 0
    let DIR_DOWN = 1
    let DIR_LEFT = 2
    let DIR_RIGHT = 3
    
    
    var moving = false
    var shoot_delay = 0.0
    var moving_dir: Facing = .UP
    var facing_dir: Facing = .UP
    
    var life_max = 5.0
    var life_amt = 5.0
    var invulnerable = false
    
    var dest_marker: SKSpriteNode?
    
    init(imageNamed: String, name: String, marker: Bool = false){
        let texture = SKTexture(imageNamed: imageNamed)
        self.statuses = [Effect]()
        self.abilities = [KeyCombo: Spell]()
        super.init(texture: texture, color: SKColor.white, size: texture.size())
        self.colorBlendFactor = 1.0
        
        self.name = name
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.categoryBitMask = GameScene.ColliderType.UNIT.rawValue
        self.physicsBody!.contactTestBitMask =
            GameScene.ColliderType.UNIT.rawValue +
            GameScene.ColliderType.TERRAIN.rawValue
        self.physicsBody!.collisionBitMask =
            GameScene.ColliderType.TERRAIN.rawValue
        
        if marker {
            dest_marker = SKSpriteNode(texture: texture, color: SKColor.red, size: texture.size())
            dest_marker?.colorBlendFactor = 1.0
            dest_marker?.alpha = 0.5
            dest_marker?.position = tgt_coord_pos
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func damage(amt: Double){
        if !invulnerable {
            self.life_amt -= amt
            let scale = CGFloat(self.life_amt / self.life_max)
            self.color = SKColor.red
            
            self.invulnerable = true
            self.run(SKAction.scale(to: scale, duration: 0.5))
            let seq = SKAction.sequence([
                SKAction.colorize(with: SKColor.white, colorBlendFactor: 1.0, duration: 0.5),
                SKAction.run {
                    self.invulnerable = false
                }
            ])
            
            self.run(seq)
            
            SKAction.run {
                
            }
            if self.life_amt <= 0 {
                self.die()
            }
        }
    }
    
    func die(){
        self.removeFromParent()
//        GameScene.instance?.bullets.remove(at: (GameScene.instance?.bullets.firstIndex(of: self))!)
    }
    
    func update(keys: [Int: Bool], currentTime: TimeInterval){
//        updateMovement()
    }
    
    override func didBegin(contact: SKPhysicsContact, target: Entity) {
        
        // if the player is touched, damage the player
        if target.name == "player" {
//            (target as! Unit).damage(amt: 1)
        }
        
        for effect in effects["collider"]! {
            if effect is CollidingEffect {
                let colliding_effect = effect as! CollidingEffect
                let dict: [EffectAttr: Any] = [
                    .FACING: self.moving_dir,
                    .TARGET: self,
                    .COLLIDE_TARGET: target
                ]
                colliding_effect.collide(attr: dict)
            }
        }
    }
    
}
