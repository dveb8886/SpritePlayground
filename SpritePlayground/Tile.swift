//
//  Tile.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/12/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit

class Tile : SKSpriteNode {
    
    init(imageNamed: String){
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
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
        self.physicsBody!.affectedByGravity = false
//        self.physicsBody!.isDynamic = false
//        self.physicsBody!.categoryBitMask = GameScene.ColliderType.TERRAIN.rawValue
//        self.physicsBody!.contactTestBitMask = GameScene.ColliderType.UNIT.rawValue
        self.physicsBody!.collisionBitMask = 0
//            GameScene.ColliderType.UNIT.rawValue
    }
    
    func clone() -> Tile {
        let clone = self.copy() as! Tile
        return clone
    }
}
