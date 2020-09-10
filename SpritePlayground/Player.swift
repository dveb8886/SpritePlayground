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
        
        // Move North
        let northMoveEffect = MoveEffect(dir: .NORTH, speed: 0.5)
        let northMoveSpell = SelfChannel(cooldown: 0.1, startEffect: northMoveEffect)
        northMoveEffect.channelingSpell = northMoveSpell
        self.abilities[KeyCombo(keys: [kVK_ANSI_W])] = northMoveSpell
        
        //Move South
        let southMoveEffect = MoveEffect(dir: .SOUTH, speed: 0.5)
        let southMoveSpell = SelfChannel(cooldown: 0.1, startEffect: southMoveEffect)
        southMoveEffect.channelingSpell = southMoveSpell
        self.abilities[KeyCombo(keys: [kVK_ANSI_S])] = southMoveSpell
        
        // Move West
        let westMoveEffect = MoveEffect(dir: .WEST, speed: 0.5)
        let westMoveSpell = SelfChannel(cooldown: 0.1, startEffect: westMoveEffect)
        westMoveEffect.channelingSpell = westMoveSpell
        self.abilities[KeyCombo(keys: [kVK_ANSI_A])] = westMoveSpell
        
        // Move East
        let eastMoveEffect = MoveEffect(dir: .EAST, speed: 0.5)
        let eastMoveSpell = SelfChannel(cooldown: 0.1, startEffect: eastMoveEffect)
        eastMoveEffect.channelingSpell = eastMoveSpell
        self.abilities[KeyCombo(keys: [kVK_ANSI_D])] = eastMoveSpell
        
        // Shoot projectile (space)
        let impactEffect = DamageEffect(amount: 1)
        //        let impactEffect = EtherealEffect()
        let bullet = Bullet(impactEffect: impactEffect)
        let space_start = CreateProjectile(projectileTemplate: bullet)
        let space_spell = SelfChannel(cooldown: 1, startEffect: space_start)
        space_start.channelingSpell = space_spell
        self.abilities[KeyCombo(keys: [kVK_Space])] = space_spell
        
        // Shoot an ethereal projectile that splits (and becomes non-ethereal when channeling is done)
        let e_projectile = CreateProjectile(projectileTemplate: bullet)
        let e_ethereal = EtherealEffect(duration: 0.01)
        e_projectile.projectileEffect = e_ethereal
        let e_split = SplitEffect(startEffect: CreateProjectile(projectileTemplate: bullet), shootDirections: [.LEFT, .RIGHT])
        let e_repeating = RepeatingEffect(repeatingEffect: e_split)
        e_ethereal.endEffect = e_repeating
        let e_spell = SelfChannel(cooldown: 1, startEffect: e_projectile)
        e_ethereal.channelingSpell = e_spell
        self.abilities[KeyCombo(keys: [kVK_ANSI_E])] = e_spell
        
        // Shoot an ethereal projectile that also hides the shooter until channeling is done
        let z_projectile = CreateProjectile(projectileTemplate: bullet)
        let z_proj_ethereal = EtherealEffect(duration: 0.01)
        z_projectile.projectileEffect = z_proj_ethereal
        z_proj_ethereal.endEffect = SplitEffect(startEffect: CreateProjectile(projectileTemplate: bullet), shootDirections: [.LEFT, .RIGHT])
        let z_ethereal = EtherealEffect(duration: 0.01)
        let z_multiple = MultipleEffect(startingEffects: [z_projectile, z_ethereal])
        let z_spell = SelfChannel(cooldown: 1, startEffect: z_multiple)
        z_proj_ethereal.channelingSpell = z_spell
        z_ethereal.channelingSpell = z_spell
        self.abilities[KeyCombo(keys: [kVK_ANSI_Z])] = z_spell
        
        // makes self ethereal for duration of channel
        let q_start = EtherealEffect(duration: 0.1)
        let q_spell = SelfChannel(cooldown: 15, startEffect: q_start)
        q_start.channelingSpell = q_spell
        self.abilities[KeyCombo(keys: [kVK_ANSI_Q])] = q_spell
        
        // rock spell test
        let x_impact = DamageEffect(amount: 1.0)
        let x_rock = RockProjectile(impactEffect: x_impact)
        let split_rock = RockProjectile(impactEffect: x_impact)
        let split_launch = EarthLauncher(projectile: split_rock)
        x_rock.arriveEffect = SplitEffect(startEffect: split_launch, shootDirections: [.LEFT, .RIGHT], removeOriginal: false)
        let x_start = EarthLauncher(projectile: x_rock)
        let x_spell = SelfCast(cooldown: 1.0, startEffect: x_start)
        self.abilities[KeyCombo(keys: [kVK_ANSI_X])] = x_spell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(keys: Set<Int>, currentTime: TimeInterval){
        let pressed_keys = KeyCombo(keys: keys.sorted())
        let spell = self.abilities[pressed_keys]
        let dict: [EffectAttr: Any] = [
            .FACING: self.moving_dir,
            .TARGET: self
        ]
        spell?.cast(attr: dict)
    }
    
}
