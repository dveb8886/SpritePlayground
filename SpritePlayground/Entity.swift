//
//  Entity.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/23/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit
import Carbon.HIToolbox.Events  // kVK

class Entity : SKSpriteNode {
    
    override init(texture: SKTexture?, color: SKColor, size: CGSize){
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didBegin(contact: SKPhysicsContact, target: Entity){
        
    }
    
}
