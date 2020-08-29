//
//  Sketchboard.swift
//  SpritePlayground
//  this file is for putting in new ideas before properly organizing them
//
//  Created by Dmitry Veber on 8/25/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit


//class KnockbackEffect : Effect, CollidingEffect {
//
//    let distance: Int
//    let speed: Double
//
//    init(distance: Int = 2, speed: Double = 0.2){
//        self.distance = distance
//        self.speed = speed
//    }
//
//    func start(attr: [EffectAttr : Any]) {
//
//    }
//
//
//    func collide(attr: [EffectAttr : Any]) {
//        let collider = attr[.TARGET] as! Unit
//        let target = attr[.COLLIDE_TARGET] as! Unit
//
//        let same_axis = collider.cur_tile_pos.x == target.cur_tile_pos.x || collider.cur_tile_pos.y == target.cur_tile_pos.y
//
//        if same_axis {
//            target.removeAction(forKey: "move")
//            target.bool_attr["moving"] = false
//            target.reset_tile_marker()
//            let effect = MoveEffect(dir: collider.moving_dir, speed: self.speed, rotate: false, distance: distance)
//            let dict: [EffectAttr: Any] = [
//                .TARGET: target
//            ]
//            effect.start(attr: dict)
//        }
//    }
//
//
//}





