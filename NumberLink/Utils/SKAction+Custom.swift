//
//  SKAction+Custom.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 11/12/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import SpriteKit

import SpriteKit

public class Effect {
    unowned var node: SKNode
    var duration: TimeInterval
    public var timingFunction: ((CGFloat) -> CGFloat)?
    
    public init(node: SKNode, duration: TimeInterval) {
        self.node = node
        self.duration = duration
    }
    
    public func update(_ t: CGFloat) {
        // subclasses implement this
    }
}

/**
 * Moves a node from its current position to a new position.
 */
public class MoveEffect: Effect {
    var startPosition: CGPoint
    var deltaX: CGFloat
    var deltaY: CGFloat
    var previousPosition: CGPoint
    
    public init(node: SKNode, duration: TimeInterval, startPosition: CGPoint, endPosition: CGPoint) {
        previousPosition = node.position
        self.startPosition = startPosition
        deltaX = endPosition.x - startPosition.x
        deltaY = endPosition.y - startPosition.y
        super.init(node: node, duration: duration)
    }
    
    public override func update(_ t: CGFloat) {
        // This allows multiple SKTMoveEffect objects to modify the same node
        // at the same time.
        let newPosition = CGPoint(x: startPosition.x + deltaX*t, y: startPosition.y + deltaY*t)
        let diffX = newPosition.x - previousPosition.x
        let diffY = newPosition.y - previousPosition.y
        previousPosition = newPosition
        node.position.x += diffX
        node.position.y += diffY
    }
}

/**
 * Scales a node to a certain scale factor.
 */
public class ScaleEffect: Effect {
    var startScale: CGPoint
    var deltaX: CGFloat
    var deltaY: CGFloat
    var previousScale: CGPoint
    
    public init(node: SKNode, duration: TimeInterval, startScale: CGPoint, endScale: CGPoint) {
        previousScale = CGPoint(x: node.xScale, y: node.yScale)
        self.startScale = startScale
        deltaX = endScale.x - startScale.x
        deltaY = endScale.y - startScale.y
        super.init(node: node, duration: duration)
    }
    
    public override func update(_ t: CGFloat) {
        let newScale = CGPoint(x: startScale.x + deltaX*t, y: startScale.y + deltaY*t)
        let diffX = newScale.x / previousScale.x
        let diffY = newScale.y / previousScale.y
        previousScale = newScale
        node.xScale *= diffX
        node.yScale *= diffY
    }
}

/**
 * Rotates a node to a certain angle.
 */
public class RotateEffect: Effect {
    var startAngle: CGFloat
    var delta: CGFloat
    var previousAngle: CGFloat
    
    public init(node: SKNode, duration: TimeInterval, startAngle: CGFloat, endAngle: CGFloat) {
        previousAngle = node.zRotation
        self.startAngle = startAngle
        delta = endAngle - startAngle
        super.init(node: node, duration: duration)
    }
    
    public override func update(_ t: CGFloat) {
        let newAngle = startAngle + delta*t
        let diff = newAngle - previousAngle
        previousAngle = newAngle
        node.zRotation += diff
    }
}

/**
 * Fade a node to a certain alpha factor.
 */
public class AlphaEffect: Effect {
    var startAlpha: CGFloat
    var delta: CGFloat
    var previousAlpha: CGFloat
    
    public init(node: SKNode, duration: TimeInterval, from: CGFloat, to: CGFloat) {
        previousAlpha = from
        self.startAlpha = from
        delta = to - from
        node.alpha = from
        super.init(node: node, duration: duration)
    }
    
    public override func update(_ t: CGFloat) {
        let newAlpha = startAlpha + delta * t
        let diff = newAlpha - previousAlpha
        previousAlpha = newAlpha
        node.alpha = newAlpha
    }
}

/**
 * Wrapper that allows you to use Effect objects as regular SKActions.
 */
public extension SKAction {
    
    public class func customMove(node: SKNode, duration: TimeInterval, startPosition: CGPoint, endPosition: CGPoint, timingFunction: ((CGFloat) -> CGFloat)?) -> SKAction {
        let effect = MoveEffect(node: node, duration: duration, startPosition: startPosition, endPosition: endPosition)
        effect.timingFunction = timingFunction
        return actionWithEffect(effect)
    }
    
    public class func customScale(node: SKNode, duration: TimeInterval, startScale: CGPoint, endScale: CGPoint, timingFunction: ((CGFloat) -> CGFloat)?) -> SKAction {
        let effect = ScaleEffect(node: node, duration: duration, startScale: startScale, endScale: endScale)
        effect.timingFunction = timingFunction
        return actionWithEffect(effect)
    }
    
    public class func customRotate(node: SKNode, duration: TimeInterval, startAngle: CGFloat, endAngle: CGFloat, timingFunction: ((CGFloat) -> CGFloat)?) -> SKAction {
        let effect = RotateEffect(node: node, duration: duration, startAngle: startAngle, endAngle: endAngle)
        effect.timingFunction = timingFunction
        return actionWithEffect(effect)
    }
    
    public class func customAlpha(node: SKNode, duration: TimeInterval, from: CGFloat, to: CGFloat, timingFunction: ((CGFloat) -> CGFloat)?) -> SKAction {
        let effect = AlphaEffect(node: node, duration: duration, from: from, to: to)
        return actionWithEffect(effect)
    }
    
    public class func actionWithEffect(_ effect: Effect) -> SKAction {
        return SKAction.customAction(withDuration: effect.duration) { node, elapsedTime in
            var t = elapsedTime / CGFloat(effect.duration)
            if let timingFunction = effect.timingFunction {
                t = timingFunction(t)  // the magic happens here
            }
            
            effect.update(t)
        }
    }
}
