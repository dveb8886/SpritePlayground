//
//  Enemy.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/13/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit
import Carbon.HIToolbox.Events  // kVK

class Enemy  : Unit {
    
    init(){
        super.init(imageNamed: "Circle", name: "enemy")
        self.speed = 1.0
        self.abilities[KeyCombo(keys: [kVK_ANSI_I])] = SelfCast(cooldown: 0.1, startEffect: MoveEffect(dir: .NORTH, speed: 0.5))
        self.abilities[KeyCombo(keys: [kVK_ANSI_K])] = SelfCast(cooldown: 0.1, startEffect: MoveEffect(dir: .SOUTH, speed: 0.5))
        self.abilities[KeyCombo(keys: [kVK_ANSI_J])] = SelfCast(cooldown: 0.1, startEffect: MoveEffect(dir: .WEST, speed: 0.5))
        self.abilities[KeyCombo(keys: [kVK_ANSI_L])] = SelfCast(cooldown: 0.1, startEffect: MoveEffect(dir: .EAST, speed: 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func update(keys: Set<Int>, currentTime: TimeInterval){
//        for ability in self.abilities {
////            print("ability - test")
//            let expected_keys = ability.key
//            let spell = ability.value
//
//            var found = true
//            for expected_key in expected_keys.keys {
//                if !(keys[expected_key] ?? false) {
//                    found = false
//                    break
//                }
//            }
//
//            if found {
////                print("ability - FOUND")
//                let dict: [EffectAttr: Any] = [
//                    .FACING: self.moving_dir,
//                    .TARGET: self
//                ]
//                spell.cast(attr: dict)
//                break
//            }
//        }
        
        let moves: [KeyCombo] = [
            KeyCombo(keys: [kVK_ANSI_I]),
            KeyCombo(keys: [kVK_ANSI_K]),
            KeyCombo(keys: [kVK_ANSI_J]),
            KeyCombo(keys: [kVK_ANSI_L])
        ]
        
        if !self.bool_attr["moving"]! {
            let spell = self.abilities[moves[Int.random(in: 0...3)]]!
            let dict: [EffectAttr: Any] = [
                .FACING: self.moving_dir,
                .TARGET: self
            ]
            spell.cast(attr: dict)
//            move(dir: Int.random(in: 0...3))
        }
        
    }
    
    
}
