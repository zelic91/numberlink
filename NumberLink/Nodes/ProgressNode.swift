//
//  ProgressNode.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/20/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import SpriteKit

class ProgressNode: SKCropNode {
    
    var foregroundNode: SKSpriteNode = SKSpriteNode(imageNamed: "ProgressForeground")
    var backgroundNode: SKSpriteNode = SKSpriteNode(imageNamed: "ProgressBackground")
    var action: SKAction?
    
    override init() {
        super.init()
        setupProgress()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupProgress() {
        maskNode = backgroundNode
        foregroundNode.position = CGPoint(x: foregroundNode.position.x, y: 0)
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
        addChild(foregroundNode)
    }
    
    func reloadProgress() {
        foregroundNode.position = CGPoint(x: backgroundNode.position.x, y: 0)
    }
    
    func startProgress(in time: Double, with completion: @escaping () -> Void) {
        foregroundNode.removeAllActions()
        foregroundNode.position = CGPoint(x: 0, y: 0)
        let transition = SKAction.move(to: CGPoint(x: -backgroundNode.size.width, y: 0), duration: TimeInterval(time))
        let block = SKAction.run(completion)
        action = SKAction.sequence([transition, block])
        foregroundNode.run(action!)
    }
    
    func pauseProgress() {
        foregroundNode.removeAllActions()
    }
    
    func size() -> CGSize {
        return backgroundNode.size
    }
}
