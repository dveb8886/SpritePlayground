//
//  GameScene.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/11/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import SpriteKit
import GameplayKit
import Carbon.HIToolbox.Events  // kVK

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    static var instance: GameScene? = nil
    
    var player = Player()
    var enemy = Enemy()
    var world = World()
    var keys: Set = Set<Int>()
    var bullets = [Bullet]()
    
    enum ColliderType: UInt32 {
        case UNIT = 1
        case TERRAIN = 2
        case PROJECTILE = 4
        case PROXIMITY = 8
    }
    
    override func didMove(to view: SKView) {
        GameScene.instance = self
        self.physicsWorld.contactDelegate = self
        
        let O = "e"
        let X = "b"
        
        // Load Map
//        let map = [
//            [X, X, X, X, X, X, X, X, X, X, X, X, X, X],
//            [X, O, X, O, O, O, O, X, O, O, O, O, X, X],
//            [X, O, X, O, X, X, X, X, X, X, X, O, X, X],
//            [X, O, X, O, O, O, O, X, O, O, O, O, X, X],
//            [X, O, X, X, X, X, O, X, O, X, X, O, X, X],
//            [X, O, O, O, O, O, O, X, O, O, X, O, X, X],
//            [X, X, X, X, X, O, X, X, X, O, X, O, X, X],
//            [X, O, O, O, X, O, X, O, X, O, X, O, X, X],
//            [X, O, X, O, X, O, X, O, X, O, X, O, X, X],
//            [X, O, X, O, X, O, X, O, X, O, X, O, X, X],
//            [X, O, X, O, O, O, O, O, O, O, X, O, X, X],
//            [X, X, X, X, X, X, X, X, X, X, X, X, X, X]
//        ]
        
        let map = [[X],[X],[X],[X],[X],[X],[X],[X],[X],[X],[X],[X],[O]]
        
        world.load(map: map)
        
        
        addChild(world)
        world.position = CGPoint(x: 50, y: 50)
        
        // Load Player
        player.teleport(x: 11, y: 10)
        world.addChild(player)
//        world.addChild(player.dest_marker!)
        
        enemy.teleport(x: 5, y: 5)
        world.addChild(enemy)
    }
    
    override func mouseDown(with event: NSEvent) {
        // Get mouse position in scene coordinates
        let location = event.location(in: self)
        // Get node at mouse position
        let node = self.atPoint(location)
        print((node.name ?? "empty") + ": " + node.position.debugDescription)
        
    }
    
    override func mouseDragged(with event: NSEvent) {
        
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }
    
    override func keyDown(with event: NSEvent) {
        keys.insert(Int(event.keyCode))
    }
    
    override func keyUp(with event: NSEvent) {
        keys.remove(Int(event.keyCode))
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        for child in self.children {
            (child as! Updatable).update(keys: keys, currentTime: currentTime)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node as? Entity
        let nodeB = contact.bodyB.node as? Entity
        let nameA = nodeA?.name ?? "empty"
        let nameB = nodeB?.name ?? "empty"
        print(nameA + " > " + nameB)
        
        // init nodeA as source and nodeB as target
        var source = nodeA
        var target = nodeB
        
        // tile alwals target, bullet and enemy always source
        if nodeA?.name == "tile" || nodeB?.name == "bullet" || nodeB?.name == "enemy" || nodeB?.name == "proximity" {   // tile is always the target, bullet always source
            target = nodeA
            source = nodeB
        }
        
        if source != nil && target != nil {
            source!.didBegin(contact: contact, target: target!)
        }
    }
    
    
}
