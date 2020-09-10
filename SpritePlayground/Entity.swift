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

class Entity : SKSpriteNode, Updatable {
    
    var abilities: [KeyCombo: Spell]
    
    var bool_attr: [String: Bool] = [String: Bool]()
    var effects: [String: [Effect]] = ["collider": [Effect](), "general": [Effect]()]
    
    var moving_dir: Facing = .NORTH
    var facing_dir: Facing = .NORTH
    
    var cur_tile_pos = CGPoint(x: 0, y: 0)
    var tgt_coord_pos = CGPoint(x: 0, y: 0)
    
    override init(texture: SKTexture?, color: SKColor, size: CGSize){
        self.abilities = [KeyCombo: Spell]()
        super.init(texture: texture, color: color, size: size)
        self.bool_attr["moving"] = false
        self.bool_attr["ethereal"] = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func teleport(x: Int, y: Int){
        cur_tile_pos.x = CGFloat(x)
        cur_tile_pos.y = CGFloat(y)
        
        tgt_coord_pos = World.convertFromTile(x: x, y: y)
        
//        tgt_coord_pos.x = cur_tile_pos.x*CGFloat(World.squareSize)
//        tgt_coord_pos.y = cur_tile_pos.y*CGFloat(World.squareSize)
        
//        self.dest_marker?.position = tgt_coord_pos
        
        self.position.x = tgt_coord_pos.x
        self.position.y = tgt_coord_pos.y
    }
    
    func reset_tile_marker(){
        self.cur_tile_pos = World.convertToTile(x: self.position.x, y: self.position.y)
    }
    
    func update(keys: Set<Int>, currentTime: TimeInterval) {
        
    }
    
    func didBegin(contact: SKPhysicsContact, target: Entity){
        
    }
    
}
