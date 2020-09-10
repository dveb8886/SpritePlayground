//
//  Move.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/28/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit

class DiagnosticMarker : Entity {
    
    init(x: Int, y: Int, time: Double){
        let texture: SKTexture = SKTexture(imageNamed: "BulletLarge")
        super.init(texture: texture, color: SKColor.red, size: texture.size())
        self.colorBlendFactor = 1
        self.teleport(x: x, y: y)
        
        self.run(SKAction.sequence([
            SKAction.scale(to: 0.0, duration: time),
            SKAction.run {
                self.removeFromParent()
            }
        ]))
        
        GameScene.instance?.world.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MoveEffect : Effect, CollidingEffect {
    var channelingSpell: Spell? = nil
    var diagnostic: Bool = true
    
    var facing: Facing
    var speed: Double
    var rotate: Bool
    var distance: Int
    var neverStop: Bool = false
    
    var useAttrFacing: Bool = false
    var useAttrSpeed: Bool = false
    var useAttrDistance: Bool = false
    var slowdown: Bool = false
    var arriveEffect: Effect?
    
    init(dir: Facing, speed: Double, rotate: Bool = true, distance: Int = 1){
        self.facing = dir
        self.speed = speed
        self.rotate = rotate
        self.distance = distance
    }
    
    func start(attr: [EffectAttr : Any]) -> Bool {
        let target = attr[.TARGET] as! Entity
        if target.bool_attr["moving"] == false {
            target.effects["collider"]!.append(self)
            target.bool_attr["moving"] = true
            if useAttrFacing {
                self.facing = attr[.FACING] as! Facing? ?? self.facing
            }
            if useAttrDistance {
                self.distance = attr[.DISTANCE] as! Int? ?? self.distance
            }
            if useAttrSpeed {
                self.speed = attr[.SPEED] as! Double? ?? self.speed
            }
            
            executeMove(target: target)
            return true
        } else {
            return false
        }
    }
    
    func executeMove(target: Entity){
        target.cur_tile_pos.x += self.facing.vector.dx * CGFloat(distance)
        target.cur_tile_pos.y += self.facing.vector.dy * CGFloat(distance)
        
        // create diagnostic marker
        if diagnostic {
            _ = DiagnosticMarker(x: Int(target.cur_tile_pos.x), y: Int(target.cur_tile_pos.y), time: self.speed)
        }
        
        
        target.moving_dir = self.facing
        if self.rotate {
            target.zRotation = self.facing.zRotation
            target.facing_dir = self.facing
        }
        
        target.tgt_coord_pos.x = target.cur_tile_pos.x * CGFloat(World.squareSize)
        target.tgt_coord_pos.y = target.cur_tile_pos.y * CGFloat(World.squareSize)
        
        let moveAction: SKAction = SKAction.move(to: target.tgt_coord_pos, duration: speed)
        if slowdown {
            moveAction.timingMode = SKActionTimingMode.easeOut
        }
        target.run(SKAction.sequence([
            moveAction,
            SKAction.run {
                if self.channelingSpell?.channeling ?? false || self.neverStop {
                    self.executeMove(target: target)
                } else {
                    var _ = self.arriveEffect?.start(attr: [
                        .TARGET: target
                    ])
                    self.cleanupMove(target: target)
                }
            }
        ]), withKey: "move")
    }
    
    func cleanupMove(target: Entity){
        target.bool_attr["moving"] = false
        target.effects["collider"]!.removeObject(element: self)
    }
    
    func collide(attr: [EffectAttr : Any]) {
        let target = attr[.TARGET] as! Entity
        let collide_target = attr[.COLLIDE_TARGET] as! Entity
        if collide_target.name == "tile" || collide_target.name == "enemy" {
            target.removeAction(forKey: "move")
            self.cleanupMove(target: target)
            if target.facing_dir == target.moving_dir {
                let distance_point = CGPoint(   // calculate new distance so the x and y coordinates land next to the wall
                    x: abs(target.cur_tile_pos.x - collide_target.cur_tile_pos.x),
                    y: abs(target.cur_tile_pos.y - collide_target.cur_tile_pos.y)
                )
                let distance = Int(distance_point.x + distance_point.y)
                let effect = self.clone() as! MoveEffect
                effect.rotate = false
                effect.distance = distance+1
                effect.facing = self.facing.backward
                var _ = effect.start(attr: attr)
            }
        }
    }
    
    func clone() -> Effect {
        let result = MoveEffect(dir: self.facing, speed: self.speed, rotate: self.rotate, distance: self.distance)
        result.channelingSpell = self.channelingSpell
        result.slowdown = self.slowdown
        result.arriveEffect = self.arriveEffect?.clone()
        return result
    }
    
}
