//
//  GameScene.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/8/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        setupView()
        setupMenu()
    }
    
    func setupView() {
        scaleMode = .aspectFill
        backgroundColor = .white
        
        let starNode = SKSpriteNode(imageNamed: "Star")
        starNode.position = CGPoint(x: self.size.width / 2 - 30, y: self.size.height - 120)
        addChild(starNode)
    }
    
    func setupMenu() {
        let homeButton = SKSpriteNode(imageNamed: "Home")
        homeButton.name = "homeButton"
        homeButton.position = CGPoint(x: self.size.width/2, y: self.size.height - 50)
        self.addChild(homeButton)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.nodes(at: location).first
        
        if let name = node?.name {
            switch name {
            case "homeButton":
                goToMenuScreen()
            default:
                debugPrint("Other touches")
            }
        }
    }
    
    func goToMenuScreen() {
        let scene = MenuScene(size: self.size)
        let transition = SKTransition.doorway(withDuration: 0.3)
        self.view?.presentScene(scene, transition: transition)
    }
}
