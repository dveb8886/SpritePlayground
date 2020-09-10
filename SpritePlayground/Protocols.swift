//
//  Protocols.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/28/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation

protocol Status {
    var statuses: [Effect] { get set }
}

extension Array {
    mutating func removeObject(element: Element) {
        guard let index = firstIndex(where: { $0 as AnyObject === element as AnyObject}) else { return }
        remove(at: index)
    }
}

protocol Effect : class {
    var channelingSpell: Spell? { get set }
    func start(attr: [EffectAttr: Any]) -> Bool
    func clone() -> Effect
}

protocol UpdatingEffect {
    func update(attr: [EffectAttr: Any])
}

protocol CollidingEffect {
    func collide(attr: [EffectAttr: Any])
}

protocol Spell {
    var channeling: Bool { get set }
    func cast(attr: [EffectAttr: Any])
}

protocol Updatable {
    func update(keys: Set<Int>, currentTime: TimeInterval)
}

protocol Projectile {
    var moveSpeed: CGFloat { get set }
    var impactEffect: Effect { get set }
    
    func clone() -> Projectile
    func setPosition(x: CGFloat, y: CGFloat)
    func setFacing(dir: Facing)
    func getSize() -> CGSize
    func getMover() -> Effect
}
