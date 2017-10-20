//
//  MenuScene.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/8/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        setupView()
    }
    
    func setupView() {
        backgroundColor = .white
        
        let starNode = SKSpriteNode(imageNamed: "Star")
        starNode.position = CGPoint(x: self.size.width / 2, y: self.size.height - 100)
        
        addChild(starNode)
        
        setupButtons()
    }
    
    func setupButtons() {
        let buttonGroup = SKNode()

        let playButton = SKSpriteNode(imageNamed: "Play")
        playButton.anchorPoint = CGPoint(x: 0, y: 1)
        playButton.position = CGPoint(x: -130, y: 77)
        playButton.name = "btnPlay"
        
        let settingsButton = SKSpriteNode(imageNamed: "Settings")
        settingsButton.anchorPoint = CGPoint.zero
        settingsButton.position = CGPoint(x: -130, y: -77)
        settingsButton.name = "btnSettings"
        
        let storeButton = SKSpriteNode(imageNamed: "Store")
        storeButton.anchorPoint = CGPoint.zero
        storeButton.position = CGPoint(x: 4, y: -77)
        storeButton.name = "btnStore"
        
        buttonGroup.addChild(playButton)
        buttonGroup.addChild(settingsButton)
        buttonGroup.addChild(storeButton)
        buttonGroup.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(buttonGroup)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let touchNode = self.nodes(at: location).first
        if let name = touchNode?.name {
            switch name {
            case "btnPlay":
                goToGameScene()
                debugPrint("Play clicked")
            case "btnSettings":
                debugPrint("Settings clicked")
            case "btnStore":
                debugPrint("Store clicked")
            default:
                debugPrint("Other cases")
            }
        }
    }
    
    func goToGameScene() {
        let gameScene = GameScene(size: self.view!.frame.size)
        let transition = SKTransition.crossFade(withDuration: 0.3)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
}
