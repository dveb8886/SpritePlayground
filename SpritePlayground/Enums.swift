//
//  File.swift
//  SpritePlayground
//
//  Created by Dmitry Veber on 8/28/20.
//  Copyright © 2020 Dmitry Veber. All rights reserved.
//

import Foundation

enum EffectAttr {
    case POS_X
    case POS_Y
    case KEY
    case TARGET
    case COLLIDE_TARGET
}

enum Facing : String {
    case UP
    case DOWN
    case LEFT
    case RIGHT
    
    var vector: CGVector {
        switch self {
        case .UP:
            return CGVector(dx: 0, dy: 1)
        case .DOWN:
            return CGVector(dx: 0, dy: -1)
        case .LEFT:
            return CGVector(dx: -1, dy: 0)
        case .RIGHT:
            return CGVector(dx: 1, dy: 0)
        }
    }
    
    var zRotation: CGFloat {
        switch self {
        case .UP:
            return 0
        case .DOWN:
            return .pi
        case .LEFT:
            return .pi / 2
        case .RIGHT:
            return 3 * .pi / 2
        }
    }
    
    var opposite: Facing {
        switch self {
        case .UP:
            return .DOWN
        case .DOWN:
            return .UP
        case .LEFT:
            return .RIGHT
        case .RIGHT:
            return .LEFT
        }
    }
}
