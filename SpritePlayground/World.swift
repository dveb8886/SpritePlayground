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


class World : SKNode, Updatable {
    
    
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
        
//        let size = World.squareSize
        
        self.coords = Array(repeating: Array(repeating: Tile(), count: map.count), count: map[0].count)
        for y in 0...map.count-1 {
            for x in 0...map[y].count-1 {
                let tile_tmp = tile_templates[map[y][x]]!.clone()
                
//                if tile_tmp.imageName == "Blocker" {
//                    tile_tmp.initPhysics()
//                }
//                tile_tmp.position = CGPoint(x: x*size, y: y*size)
                tile_tmp.teleport(x: x, y: y)
                self.coords[x][y] = tile_tmp
                self.addChild(self.coords[x][y])
                
            }
        }
    }
    
    static func convertFromTile(x: Int, y: Int) -> CGPoint {
        return CGPoint(x: CGFloat(x*World.squareSize), y: CGFloat(y*World.squareSize))
    }
    
    static func convertToTile(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: round(x/CGFloat(World.squareSize)), y: round(y/CGFloat(World.squareSize)))
    }
    
//        func teleport(x: Int, y: Int){
//            cur_tile_pos.x = CGFloat(x)
//            cur_tile_pos.y = CGFloat(y)
//
//            tgt_coord_pos.x = cur_tile_pos.x*CGFloat(World.squareSize)
//            tgt_coord_pos.y = cur_tile_pos.y*CGFloat(World.squareSize)
//
//    //        self.dest_marker?.position = tgt_coord_pos
//
//            self.position.x = tgt_coord_pos.x
//            self.position.y = tgt_coord_pos.y
//        }
    
    func update(keys: Set<Int>, currentTime: TimeInterval){
        for child in self.children {
            (child as! Updatable).update(keys: keys, currentTime: currentTime)
        }
        
//        for row in self.coords {
//            for tile in row {
//                tile.update(keys: keys)
//            }
//        }
        if keys.contains(kVK_LeftArrow) {
            self.position.x -= 10
        } else if keys.contains(kVK_RightArrow) {
            self.position.x += 10
        } else if keys.contains(kVK_UpArrow) {
            self.position.y += 10
        } else if keys.contains(kVK_DownArrow) {
            self.position.y -= 10
        }
    }
    
}
