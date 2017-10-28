//
//  GameOverScene.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/20/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import SpriteKit

class GameOverNode: SKNode {
    
    var scoreLabel: SKLabelNode = SKLabelNode(fontNamed: "ProximaNovaSoft-Semibold")
    var homeButton: ButtonNode = ButtonNode("Home")
    var replayButton: ButtonNode = ButtonNode("Replay")
    var backgroundNode: SKSpriteNode = SKSpriteNode()
    
    // Init
    static func create() -> GameOverNode {
        let node = GameOverNode()
        node.setupView()
        return node
    }
    
    func setupView() {
        
        backgroundNode.size = CGSize(width: 375, height: 667)
        backgroundNode.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        backgroundNode.colorBlendFactor = 1
        backgroundNode.isUserInteractionEnabled = true
        
        homeButton.position = CGPoint(x: 0, y: homeButton.size.height)
        replayButton.position = CGPoint(x: 0, y: homeButton.size.height/2 - 10 - replayButton.size.height/2)
        
        addChild(backgroundNode)
        addChild(homeButton)
        addChild(replayButton)
        addChild(scoreLabel)
    }
    
    func show() {
        zPosition = 999
        isHidden = false
    }
    
    func hide() {
        zPosition = -999
        isHidden = true
    }
    
}
