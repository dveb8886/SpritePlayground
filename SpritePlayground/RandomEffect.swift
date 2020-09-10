//
//  RandomEffect.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/31/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
// === Ideas
// = Upgrade for ability to put different weights on different effects
class RandomEffect : Effect {
    var channelingSpell: Spell? = nil
    
    var startingEffects: [Effect]
    
    init(startingEffects: [Effect]){
        self.startingEffects = startingEffects
    }
    
    func start(attr: [EffectAttr : Any]) -> Bool {
        return startingEffects[Int.random(in: 0...startingEffects.count)].start(attr: attr)
    }
    
    func clone() -> Effect {
        var clonedEffects: [Effect] = [Effect]()
        for effect in self.startingEffects {
            clonedEffects.append(effect.clone())
        }
        let result = RandomEffect(startingEffects: clonedEffects)
        result.channelingSpell = self.channelingSpell
        return result
    }
    
    
}
