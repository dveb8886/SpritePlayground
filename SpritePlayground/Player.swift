//
//  Player.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/12/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit
import Carbon.HIToolbox.Events  // kVK

class Player  : Unit {
    
    
    
    init(){
        super.init(imageNamed: "Arrow", name: "player")
        self.speed = 3.0
        self.abilities[KeyCombo(keys: [kVK_ANSI_W])] = SelfCast(cooldown: 0.1, startEffect: MoveEffect(dir: .UP, speed: 0.5))
        self.abilities[KeyCombo(keys: [kVK_ANSI_S])] = SelfCast(cooldown: 0.1, startEffect: MoveEffect(dir: .DOWN, speed: 0.5))
        self.abilities[KeyCombo(keys: [kVK_ANSI_A])] = SelfCast(cooldown: 0.1, startEffect: MoveEffect(dir: .LEFT, speed: 0.5))
        self.abilities[KeyCombo(keys: [kVK_ANSI_D])] = SelfCast(cooldown: 0.1, startEffect: MoveEffect(dir: .RIGHT, speed: 0.5))
        
        let impactEffect = DamageEffect(amount: 1)
        //        let impactEffect = EtherealEffect()
        let bullet = Bullet(impactEffect: impactEffect)
        self.abilities[KeyCombo(keys: [kVK_Space])] = SelfCast(cooldown: 1, startEffect: CreateProjectile(projectileTemplate: bullet))
        
        self.abilities[KeyCombo(keys: [kVK_ANSI_Q])] = SelfCast(cooldown: 15, startEffect: EtherealEffect(duration: 5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(keys: [Int: Bool], currentTime: TimeInterval){
        for ability in self.abilities {
//            print("ability - test")
            let expected_keys = ability.key
            let spell = ability.value
            
            var found = true
            for expected_key in expected_keys.keys {
                if !(keys[expected_key] ?? false) {
                    found = false
                    break
                }
            }
            
            if found {
//                print("ability - FOUND")
                let dict: [EffectAttr: Any] = [
                    .FACING: self.moving_dir,
                    .TARGET: self
                ]
                spell.cast(attr: dict)
                break
            }
        }
        
//        if !currentTime.isLess(than: shoot_delay) && keys[kVK_Space] ?? false {
//            shoot_delay = currentTime + 1
//            shoot()
//        }
        
    }
    
}
