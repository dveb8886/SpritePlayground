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

class Bullet : SKSpriteNode {
    let DIR_UP = 0
    let DIR_DOWN = 1
    let DIR_LEFT = 2
    let DIR_RIGHT = 3
    
    var moving = true
    var moving_dir = 0
    
    init(dir: Int, x: CGFloat, y: CGFloat){
        let texture = SKTexture(imageNamed: "Bullet")
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
        
        GameScene.instance?.bullets.append(self)
        GameScene.instance?.world.addChild(self) 
        teleport(x: x, y: y)
        move(dir: dir)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(dir: Int, rotate: Bool = true){
        moving_dir = dir
        if dir == DIR_UP {
            if rotate {self.zRotation = 0}
        } else if dir == DIR_DOWN {
            if rotate {self.zRotation = .pi}
        } else if dir == DIR_LEFT {
            if rotate {self.zRotation = .pi / 2}
        } else if dir == DIR_RIGHT {
            if rotate {self.zRotation = 3 * .pi / 2}
        }
        
    }
    
    func teleport(x: CGFloat, y: CGFloat){
        self.position.x = x
        self.position.y = y
    }
    
    func update(keys: [Int: Bool]){
        if moving {
            if moving_dir == DIR_UP {
                self.position.y = self.position.y + speed
            } else if moving_dir == DIR_DOWN {
                self.position.y = self.position.y - speed
            } else if moving_dir == DIR_LEFT {
                self.position.x = self.position.x - speed
            } else if moving_dir == DIR_RIGHT {
                self.position.x = self.position.x + speed
            }
        }
    }
    
    func didBegin(contact: SKPhysicsContact) {
        self.removeFromParent()
        GameScene.instance?.bullets.remove(at: (GameScene.instance?.bullets.firstIndex(of: self))!)
        print("bullet contact")
    }
}
