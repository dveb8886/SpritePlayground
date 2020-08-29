//
//  Move.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/28/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit

class MoveEffect : Effect, CollidingEffect {
    
    let dir: Facing
    let speed: Double
    let rotate: Bool
    let distance: Int
    
    init(dir: Facing, speed: Double, rotate: Bool = true, distance: Int = 1){
        self.dir = dir
        self.speed = speed
        self.rotate = rotate
        self.distance = distance
    }
    
    func start(attr: [EffectAttr : Any]) {
        let target = attr[.TARGET] as! Unit
        if target.bool_attr["moving"] == false {
            target.effects["collider"]!.append(self)
            target.bool_attr["moving"] = true
            target.cur_tile_pos.x += self.dir.vector.dx * CGFloat(self.distance)
            target.cur_tile_pos.y += self.dir.vector.dy * CGFloat(self.distance)
            target.moving_dir = self.dir
            if self.rotate {
                target.zRotation = self.dir.zRotation
                target.facing_dir = self.dir
            }
            
            target.tgt_coord_pos.x = target.cur_tile_pos.x * CGFloat(World.squareSize)
            target.tgt_coord_pos.y = target.cur_tile_pos.y * CGFloat(World.squareSize)
            
            target.run(SKAction.sequence([
                SKAction.move(to: target.tgt_coord_pos, duration: self.speed),
                SKAction.run {
                    self.cleanupMove(target: target)
                }
            ]), withKey: "move")
        }
    }
    
    func cleanupMove(target: Unit){
        target.bool_attr["moving"] = false
        target.effects["collider"]!.removeObject(element: self)
    }
    
    func collide(attr: [EffectAttr : Any]) {
        let target = attr[.TARGET] as! Unit
        let collide_target = attr[.COLLIDE_TARGET] as! Entity
        if collide_target.name == "tile" {
            target.removeAction(forKey: "move")
            self.cleanupMove(target: target)
            if target.facing_dir == target.moving_dir {
                let distance_point = CGPoint(   // calculate new distance so the x and y coordinates land next to the wall
                    x: abs(target.cur_tile_pos.x - collide_target.cur_tile_pos.x),
                    y: abs(target.cur_tile_pos.y - collide_target.cur_tile_pos.y)
                )
                let distance = Int(distance_point.x + distance_point.y)
                let effect = MoveEffect(dir: self.dir.opposite, speed: self.speed, rotate: false, distance: distance+1)
                effect.start(attr: attr)
            }
        }
    }
    
}
