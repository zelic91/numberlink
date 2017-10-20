//
//  ProgressNode.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/20/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import SpriteKit

class ProgressNode: SKCropNode {
    
    var foregroundNode: SKSpriteNode = SKSpriteNode(imageNamed: "ActiveProgress")
    var backgroundNode: SKSpriteNode = SKSpriteNode(imageNamed: "ProgressPlaceholder")
    
    override init() {
        super.init()
        setupProgress()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupProgress() {
        maskNode = backgroundNode
        
//        let foreSize = foregroundNode.size
//        let newCenterRect = CGRect(x: foreSize.height/foreSize.width, y: 0, width: (foreSize.width - foreSize.height)/foreSize.width, height: 1)
        
//        foregroundNode.anchorPoint = CGPoint(x: 0, y: 0.5)
//        foregroundNode.centerRect = newCenterRect
//        foregroundNode.position = CGPoint(x: -size.width/2, y: 0)
        foregroundNode.size = CGSize(width: foregroundNode.size.width, height: foregroundNode.size.height)
        addChild(foregroundNode)
    }
    
    func setProgress(value: Int) {
        
    }
    
}
