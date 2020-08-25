//
//  Tile.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/12/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit

class Tile : Entity {
    
    var imageName: String = "empty"
    var lastPosition: CGPoint = CGPoint(x: 0, y: 0)
    var changeTimer = 0
    
    init(imageNamed: String){
        let texture = SKTexture(imageNamed: imageNamed)
        self.imageName = imageNamed
        super.init(texture: texture, color: SKColor.white, size: texture.size())
        self.colorBlendFactor = 1.0
        self.name = "tile"
    }
    
    init(){
        super.init(texture: nil, color: SKColor.clear, size: CGSize(width: 32, height: 32))
        self.name = "tile"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPhysics(){
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
//        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.isDynamic = false
        self.physicsBody!.categoryBitMask = GameScene.ColliderType.TERRAIN.rawValue
        self.physicsBody!.contactTestBitMask = GameScene.ColliderType.UNIT.rawValue
        self.physicsBody!.collisionBitMask =
            GameScene.ColliderType.UNIT.rawValue
    }
    
    func update(keys: [Int: Bool]){
//        if self.lastPosition.x != self.position.x || self.lastPosition.y != self.position.y {
//            self.lastPosition.x = self.position.x
//            self.lastPosition.y = self.position.y
//            changeTimer = 1
//        }
//
//        if self.imageName == "Blocker" {
//            if changeTimer > 0 {
//                self.color = SKColor.blue
//                changeTimer -= 1
//            } else {
//                self.color = SKColor.white
//            }
//        }
    }
    
    func clone() -> Tile {
        let clone = self.copy() as! Tile
        clone.imageName = self.imageName
        return clone
    }
}
