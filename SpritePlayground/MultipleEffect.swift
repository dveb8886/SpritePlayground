//
//  MultipleEffect.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/29/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation
import SpriteKit

class MultipleEffect : Effect {
    var channelingSpell: Spell? = nil
    
    var startingEffects: [Effect]
    
    init(startingEffects: [Effect]){
        self.startingEffects = startingEffects
    }
    
    func start(attr: [EffectAttr : Any]) -> Bool {
        for startingEffect in startingEffects {
            var _ = startingEffect.start(attr: attr)
        }
        
        return true
    }
    
    func clone() -> Effect {
        var clonedEffects: [Effect] = [Effect]()
        for effect in self.startingEffects {
            clonedEffects.append(effect.clone())
        }
        let result = MultipleEffect(startingEffects: clonedEffects)
        result.channelingSpell = self.channelingSpell
        return result
    }
    
    
}
