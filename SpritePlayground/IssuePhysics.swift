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

class IssuePhysics: SKScene, SKPhysicsContactDelegate {
    
    static var instance: IssuePhysics?
    
    var world = BrokenWorld()
    var keys = [Int: Bool]()
    
    override func didMove(to view: SKView) {
        IssuePhysics.instance = self
        
        let O = "e"
        let X = "b"
        
        // Load Map
        let map = [
            [O, X, X, X, X, X, X, X, X, X, X, X, X, X],
            [X, O, X, O, O, O, O, X, O, O, O, O, X, X],
            [X, O, X, O, X, X, X, X, X, X, X, O, X, X],
            [X, O, X, O, O, O, O, X, O, O, O, O, X, X],
            [X, O, X, X, X, X, O, X, O, X, X, O, X, X],
            [X, O, O, O, O, O, O, X, O, O, X, O, X, X],
            [X, X, X, X, X, O, X, X, X, O, X, O, X, X],
            [X, O, O, O, X, O, X, O, X, O, X, O, X, X],
            [X, O, X, O, X, O, X, O, X, O, X, O, X, X],
            [X, O, X, O, X, O, X, O, X, O, X, O, X, X],
            [X, O, X, O, O, O, O, O, O, O, X, O, X, X],
            [X, X, X, X, X, X, X, X, X, X, X, X, X, X]
        ]
        
        world.load(map: map)
        
        
        addChild(world)
        world.position = CGPoint(x: 50, y: 50)
        
    }
    
    override func mouseDown(with event: NSEvent) {
        // Get mouse position in scene coordinates
        let location = event.location(in: self)
        // Get node at mouse position
        let node = self.atPoint(location)
        print((node.name ?? "empty") + ": " + node.position.debugDescription)
        print((node.physicsBody?.velocity.debugDescription) as Any)
    }
    
    override func keyDown(with event: NSEvent) {
        keys[Int(event.keyCode)] = true
    }
    
    override func keyUp(with event: NSEvent) {
        keys[Int(event.keyCode)] = false
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        world.update(keys: keys)
    }
    
}

class BrokenWorld : SKNode {
    
    static var instance: BrokenWorld?
    
    var coords = [[BrokenTile]]()
    static let squareSize = 32
    var tile_templates = [String: BrokenTile]()
    
    override init(){
        super.init()
        BrokenWorld.instance = self
        self.name = "world"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(map: [[String]]){
        
        
        var tile = BrokenTile()
        tile_templates["e"] = tile   // register empty tile
        tile = BrokenTile(imageNamed: "Blocker")
        tile.initPhysics()
        tile_templates["b"] = tile   // register standard white tile
        
        let size = 34  // deliberately higher than 32 so that each square in the maze is clearly visible
        
        self.coords = Array(repeating: Array(repeating: BrokenTile(), count: map.count), count: map[0].count)
        for y in 0...map.count-1 {
            for x in 0...map[y].count-1 {
                let tile_tmp = tile_templates[map[y][x]]!.clone()
                tile_tmp.position = CGPoint(x: x*size, y: y*size)
                self.coords[x][y] = tile_tmp
                self.addChild(self.coords[x][y])
                
            }
        }
    }
    
    func update(keys: [Int: Bool]){
        for row in self.coords {
            for tile in row {
                tile.update(keys: keys)
            }
        }
        if keys[kVK_LeftArrow] ?? false {
            self.position.x -= 10
        } else if keys[kVK_RightArrow] ?? false {
            self.position.x += 10
        } else if keys[kVK_UpArrow] ?? false {
            self.position.y += 10
        } else if keys[kVK_DownArrow] ?? false {
            self.position.y -= 10
        }
    }
    
}

class BrokenTile : SKSpriteNode {
    
    var imageName: String = "empty"
    var lastPosition: CGPoint = CGPoint(x: 0, y: 0)
    var changeTimer = 0
    
    init(imageNamed: String){
        let texture = SKTexture(imageNamed: imageNamed)
        self.imageName = imageNamed
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
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
        // commenting out next two lines resolves the problem, but then collission cannot be enabled, so that is not a satisfactory solution
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.isDynamic = false
    }
    
    func update(keys: [Int: Bool]){
        if self.lastPosition.x != self.position.x || self.lastPosition.y != self.position.y {
            self.lastPosition.x = self.position.x
            self.lastPosition.y = self.position.y
            changeTimer = 1
        }
        
        if self.imageName == "Blocker" {
            if changeTimer > 0 {
                self.color = SKColor.blue
                changeTimer -= 1
            } else {
                self.color = SKColor.white
            }
        }
    }
    
    func clone() -> BrokenTile {
        let clone = self.copy() as! BrokenTile
        clone.imageName = self.imageName
        return clone
    }
}

//extension SKSpriteNode {
//    open override var position: CGPoint {
//        willSet {
//            print("Position of \(self) will change to: \(newValue)")
//            // Breakpoint here
//        }
//    }
//}
