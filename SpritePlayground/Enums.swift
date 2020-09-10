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
    case FACING
    case TARGET
    case COLLIDE_TARGET
    case DISTANCE
    case SPEED
}

enum FacingRelative : String {
    case FORWARD
    case BACKWARD
    case LEFT
    case RIGHT
    
    func relate(to: Facing) -> Facing {
        switch self {
        case .FORWARD:
            return to.forward
        case .BACKWARD:
            return to.backward
        case .LEFT:
            return to.left
        case .RIGHT:
            return to.right
        }
    }
    
    static var all: [FacingRelative] {
        return [.FORWARD, .BACKWARD, .LEFT, .RIGHT]
    }
}

enum Facing : String {
    case NORTH
    case SOUTH
    case WEST
    case EAST
    
    var forward: Facing {
        return self
    }
    
    var left: Facing {
        switch self {
        case .NORTH:
            return .WEST
        case .SOUTH:
            return .EAST
        case .WEST:
            return .SOUTH
        case .EAST:
            return .NORTH
        }
    }
    
    var right: Facing {
        switch self {
        case .NORTH:
            return .EAST
        case .SOUTH:
            return .WEST
        case .WEST:
            return .NORTH
        case .EAST:
            return .SOUTH
        }
    }
    var backward: Facing {
        switch self {
        case .NORTH:
            return .SOUTH
        case .SOUTH:
            return .NORTH
        case .WEST:
            return .EAST
        case .EAST:
            return .WEST
        }
    }
    
    var vector: CGVector {
        switch self {
        case .NORTH:
            return CGVector(dx: 0, dy: 1)
        case .SOUTH:
            return CGVector(dx: 0, dy: -1)
        case .WEST:
            return CGVector(dx: -1, dy: 0)
        case .EAST:
            return CGVector(dx: 1, dy: 0)
        }
    }
    
    var zRotation: CGFloat {
        switch self {
        case .NORTH:
            return 0
        case .SOUTH:
            return .pi
        case .WEST:
            return .pi / 2
        case .EAST:
            return 3 * .pi / 2
        }
    }
    
    
}
