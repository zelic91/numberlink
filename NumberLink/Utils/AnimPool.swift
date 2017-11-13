//
//  AnimPool.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 11/11/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import SpriteKit

class Anim {
    
    enum ExecutingType {
        case sequence;
        case parallel;
    }

    var node: SKNode
    var delay: Double = 0
    var executingType: ExecutingType = .sequence
    var repeatable: Bool = false
    var reversible: Bool = false
    var timingFunction: ((CGFloat) -> CGFloat)?
    var actions: [SKAction] = []
    
    init(node: SKNode) {
        self.node = node
    }
    
    func setDelay(delay: Double) -> Anim {
        self.delay = delay
        return self
    }
    
    func setRepeatable() -> Anim {
        self.repeatable = true
        return self
    }
    
    func getMaxRunningTime() -> Double {
        var max: Double = 0
        if executingType == .parallel {
            for action in actions {
                if max < action.duration {
                    max = action.duration
                }
            }
        } else {
            for action in actions {
                max += action.duration
            }
        }
        return max
    }
    
    func scale(from: CGFloat, to: CGFloat, duration: Double, timingFunction: ((CGFloat) -> CGFloat)? = nil, delay: Double?) -> Anim {
        let scaleAction = SKAction.customScale(node: node, duration: duration, startScale: CGPoint(x: from, y: from), endScale: CGPoint(x: to, y: to), timingFunction: timingFunction)
        actions.append(scaleAction)
        return self
    }
    
    func move(to: CGPoint, duration: Double, timingFunction: ((CGFloat) -> CGFloat)? = nil, delay: Double?) -> Anim {
        let moveAction = SKAction.customMove(node: node, duration: duration, startPosition: node.position, endPosition: to, timingFunction: timingFunction)
        actions.append(moveAction)
        return self
    }
    
    func moveIn(distance: CGPoint, duration: Double, timingFunction: ((CGFloat) -> CGFloat)? = nil, delay: Double?) -> Anim {
        let position: CGPoint = CGPoint(x: node.position.x + distance.x, y: node.position.y + distance.y)
        let moveInAction = SKAction.customMove(node: node, duration: duration, startPosition: position, endPosition: node.position, timingFunction: timingFunction)
        let alphaAction = SKAction.fadeAlpha(to: 1, duration: duration)
        executingType = .parallel
        node.alpha = 0
        
        if let d = delay {
            self.delay = d
        }
        
        actions.append(moveInAction)
        actions.append(alphaAction)
        return self
    }
    
    func moveOut(distance: CGPoint, duration: Double, timingFunction: ((CGFloat) -> CGFloat)? = nil, delay: Double?) -> Anim {
        let position: CGPoint = CGPoint(x: node.position.x + distance.x, y: node.position.y + distance.y)
        let moveOutAction = SKAction.customMove(node: node, duration: duration, startPosition: node.position, endPosition: position, timingFunction: timingFunction)
        let alphaAction = SKAction.fadeAlpha(to: 0, duration: duration)
        executingType = .parallel
        node.alpha = 1
        
        if let d = delay {
            self.delay = d
        }
        
        actions.append(moveOutAction)
        actions.append(alphaAction)
        return self
    }
    
//    func rotate(to: CGFloat, duration: Double, timingFunction: ((CGFloat) -> CGFloat)? = nil, delay: Double?) -> Anim {
//        let rotateAction = SKAction.rotate(byAngle: to, duration: duration)
//        actions.append(action(rotateAction, timingFunction, delay))
//        return self
//    }
//
//    func alpha(to: CGFloat, duration: Double, timingFunction: ((CGFloat) -> CGFloat)? = nil, delay: Double?) -> Anim {
//        let alphaAction = SKAction.fadeAlpha(to: to, duration: duration)
//        actions.append(action(alphaAction, timingFunction, delay))
//        return self
//    }
    
    func run() {
        let action: SKAction = buildAnimation()
        node.run(action)
    }
    
    func action(_ actionBlock: @escaping () -> (), _ delay: Double?) -> Anim {
        let ret = SKAction.customAction(withDuration: 0) { (_, _) in
            actionBlock()
        }
        actions.append(ret)
        return self
    }
    
    private func buildAnimation() -> SKAction {
        var finalAnim: SKAction
        if executingType == .parallel {
            var actionArray: [SKAction] = []
            if delay > 0 {
                actionArray.append(SKAction.wait(forDuration: delay))
            }
            actionArray.append(SKAction.group(actions))
            finalAnim = SKAction.sequence(actionArray)
            
            return finalAnim
        } else {
            var actionArray: [SKAction] = []
            if delay > 0 {
                actionArray.append(SKAction.wait(forDuration: delay))
            }
            actionArray.append(contentsOf: actions)
            finalAnim = SKAction.sequence(actionArray)
        }
        
        if reversible {
            finalAnim.reversed()
        }
        
        return finalAnim
    }
    
    static func createTimingFunction() -> ((CGFloat) -> CGFloat) {
        return { time in
            let t = time + 1.0
            let f = sin(-13.0 * CGFloat.pi/2 * t)
            let s = pow(2.0, -10.0 * time)
            return f * s + 1.0
        }
    }
    
}

class AnimPool {
    var anims: [Anim] = []
    var beforeAction: (() ->())?
    var afterAction: (() ->())?
    
    func run() {
        if beforeAction != nil {
            beforeAction?()
        }
        
        anims.forEach { (anim) in
            anim.run()
        }
    }
    
    func createAnim(node: SKNode) -> Anim? {
        let anim = Anim(node: node)
        anims.append(anim)
        return anim
    }
    
    func addAfterAction(node: SKNode, action: @escaping ()->()) {
        var delay = 0.0
        for anim in anims {
            let maxRunningTime = anim.getMaxRunningTime()
            if delay < maxRunningTime {
                delay = maxRunningTime
            }
        }
        let anim = Anim(node: node).action(action, delay)
        anims.append(anim)
    }
    
}

class AnimManager {
    var pools: [String: AnimPool] = [:]
    
    func run(poolName: String) {
        guard let pool = pools[poolName] else {
            return
        }
        
        pool.run()
    }
    
    func runAll() {
        
    }
    
    func addPool(_ poolName: String) -> AnimPool {
        let pool: AnimPool
        if !pools.keys.contains(poolName) {
            pool = AnimPool()
            pools[poolName] = pool
        } else {
            pool = pools[poolName]!
        }
        return pool
    }
}
