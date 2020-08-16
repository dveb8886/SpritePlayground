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

class Unit  : SKSpriteNode {
    
    let DIR_UP = 0
    let DIR_DOWN = 1
    let DIR_LEFT = 2
    let DIR_RIGHT = 3
    
    var cur_tile_pos = CGPoint(x: 0, y: 0)
    var tgt_coord_pos = CGPoint(x: 0, y: 0)
    var moving = false
    var shoot_delay = 0.0
    var moving_dir = 0
    var facing_dir = 0
    
    var dest_marker: SKSpriteNode?
    
    init(imageNamed: String, name: String){
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        self.name = name
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.categoryBitMask = GameScene.ColliderType.UNIT.rawValue
        self.physicsBody!.contactTestBitMask =
            GameScene.ColliderType.UNIT.rawValue +
            GameScene.ColliderType.TERRAIN.rawValue
        self.physicsBody!.collisionBitMask =
            GameScene.ColliderType.UNIT.rawValue +
            GameScene.ColliderType.TERRAIN.rawValue
        
        dest_marker = SKSpriteNode(texture: texture, color: SKColor.red, size: texture.size())
        dest_marker?.colorBlendFactor = 1.0
        dest_marker?.alpha = 0.5
        dest_marker?.position = tgt_coord_pos
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(dir: Int, rotate: Bool = true){
        print(String(dir) + " r:"+String(rotate))
        moving = true
        moving_dir = dir
        if dir == DIR_UP {
            cur_tile_pos.y += 1
            if rotate {
                self.zRotation = 0
                self.facing_dir = DIR_UP
            }
        } else if dir == DIR_DOWN {
            cur_tile_pos.y -= 1
            if rotate {
                self.zRotation = .pi
                self.facing_dir = DIR_DOWN
            }
        } else if dir == DIR_LEFT {
            cur_tile_pos.x -= 1
            if rotate {
                self.zRotation = .pi / 2
                self.facing_dir = DIR_LEFT
            }
        } else if dir == DIR_RIGHT {
            cur_tile_pos.x += 1
            if rotate {
                self.zRotation = 3 * .pi / 2
                self.facing_dir = DIR_RIGHT
            }
        }
        
        tgt_coord_pos.x = cur_tile_pos.x*CGFloat(World.squareSize)
        tgt_coord_pos.y = cur_tile_pos.y*CGFloat(World.squareSize)
        
        self.dest_marker?.position = tgt_coord_pos
        self.dest_marker?.zRotation = self.zRotation
    }
    
    func teleport(x: Int, y: Int){
        cur_tile_pos.x = CGFloat(x)
        cur_tile_pos.y = CGFloat(y)
        
        tgt_coord_pos.x = cur_tile_pos.x*CGFloat(World.squareSize)
        tgt_coord_pos.y = cur_tile_pos.y*CGFloat(World.squareSize)
        
        self.dest_marker?.position = tgt_coord_pos
        
        self.position.x = tgt_coord_pos.x
        self.position.y = tgt_coord_pos.y
    }
    
    func shoot(){
        var x = self.position.x
        var y = self.position.y
        let spawn_offset = CGFloat(18)
        if moving_dir == DIR_UP {
            y += spawn_offset
        } else if moving_dir == DIR_DOWN {
            y -= spawn_offset
        } else if moving_dir == DIR_LEFT {
            x -= spawn_offset
        } else if moving_dir == DIR_RIGHT {
            x += spawn_offset
        }
        Bullet(dir: self.moving_dir, x: x, y: y)
    }
    
    func updateMovement(){
        if moving {
            if moving_dir == DIR_UP {
                var new_y = self.position.y + speed
                if new_y > self.tgt_coord_pos.y {
                    new_y = self.tgt_coord_pos.y
                    moving = false
                }
                self.position.y = new_y
            } else if moving_dir == DIR_DOWN {
                var new_y = self.position.y - speed
                if new_y < self.tgt_coord_pos.y {
                    new_y = self.tgt_coord_pos.y
                    moving = false
                }
                self.position.y = new_y
            } else if moving_dir == DIR_LEFT {
                var new_x = self.position.x - speed
                if new_x < self.tgt_coord_pos.x {
                    new_x = self.tgt_coord_pos.x
                    moving = false
                }
                self.position.x = new_x
            } else if moving_dir == DIR_RIGHT {
                var new_x = self.position.x + speed
                if new_x > self.tgt_coord_pos.x {
                    new_x = self.tgt_coord_pos.x
                    moving = false
                }
                self.position.x = new_x
            }
        }
    }
    
    func update(keys: [Int: Bool], currentTime: TimeInterval){
        updateMovement()
    }
    
    func didBegin(contact: SKPhysicsContact) {
        // cancel move by reversing it without turning around
        if self.facing_dir == self.moving_dir {
            if moving_dir == DIR_UP {
                move(dir: DIR_DOWN, rotate: false)
            } else if moving_dir == DIR_DOWN {
                move(dir: DIR_UP, rotate: false)
            } else if moving_dir == DIR_LEFT {
                move(dir: DIR_RIGHT, rotate: false)
            } else if moving_dir == DIR_RIGHT {
                move(dir: DIR_LEFT, rotate: false)
            } else {
                fatalError("bad moving_dir value: "+String(moving_dir))
            }
        }
    }
    
}
