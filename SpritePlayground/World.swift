//
//  World.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/12/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit
import Carbon.HIToolbox.Events  // kVK


class World : SKNode {
    
    static var instance: World?
    
    var coords = [[Tile]]()
    static let squareSize = 32
    var tile_templates = [String: Tile]()
    
    override init(){
        super.init()
        World.instance = self
        self.name = "world"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(map: [[String]]){
        
        
        var tile = Tile()
        tile_templates["e"] = tile
        tile = Tile(imageNamed: "Blocker")
        tile.initPhysics()
        tile_templates["b"] = tile
        tile = Tile(imageNamed: "Arrow")
//        tile.initPhysics()
        tile_templates["a"] = tile
        
        let size = World.squareSize
        
        self.coords = Array(repeating: Array(repeating: Tile(), count: map.count), count: map[0].count)
        for y in 0...map.count-1 {
            for x in 0...map[y].count-1 {
                let tile_tmp = tile_templates[map[y][x]]!.clone()
                
//                if tile_tmp.imageName == "Blocker" {
//                    tile_tmp.initPhysics()
//                }
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
