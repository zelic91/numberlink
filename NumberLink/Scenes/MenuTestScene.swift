//
//  MenuTestScene.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/8/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import SpriteKit

class MenuTestScene: SKScene {
    
    var logoNode: SKSpriteNode!
    var cupNode: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    // Init
    static func create() -> MenuTestScene {
        let scene = MenuTestScene(size: CGSize(width: 375, height: 667))
        scene.scaleMode = .aspectFill
        return scene
    }
    
    override func didMove(to view: SKView) {
        SoundManager.playBackground()
        
        setupView()
    }
    
}

extension MenuTestScene {
    
    func setupView() {
        backgroundColor = .white
        scaleMode = .aspectFill
        
        setupButtons()
        
    }
    
    func setupLogo() {
        logoNode = SKSpriteNode(imageNamed: "Logo")
        logoNode.position = CGPoint(x: self.size.width / 2, y: self.size.height - 50)
        addChild(logoNode)
    }
    
    func setupScore() {
        cupNode = SKSpriteNode(imageNamed: "CupSmall")
        cupNode.position = CGPoint(x: self.size.width / 2, y: logoNode.position.y - logoNode.size.height / 2 - 30 - cupNode.size.height / 2)
        addChild(cupNode)
        
        scoreLabel = SKLabelNode(fontNamed: "ProximaNovaSoft-Semibold")
        scoreLabel.text = "\(ScoreUtil.getScore())"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = Common.mainColor
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.isUserInteractionEnabled = false
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: cupNode.position.y - cupNode.size.height / 2 - 40)
        
        addChild(scoreLabel)
    }
    
    func setupButtons() {
        let layout = LayoutNode()
        layout.orientation = .vertical
        layout.padding = 10

        let playButton = ButtonNode("Play")
        playButton.setTouchHandler { [weak self] in
            self?.goToGameScene()
        }
        
        let leaderboardButton = ButtonNode("Leaderboard")
        leaderboardButton.setTouchHandler {
            ScoreUtil.showLeaderboard()
        }
        leaderboardButton.position = CGPoint(x: -playButton.size.width / 2 + leaderboardButton.size.width/2, y: playButton.position.y - leaderboardButton.size.height - 10)
        
        let shopButton = ButtonNode("Cart")
        shopButton.position = CGPoint(x: playButton.position.x, y: leaderboardButton.position.y)
        shopButton.setTouchHandler {
            IAPManager.getInstance()?.purchase()
        }
        
        let soundButton = ButtonNode("Sound On")
        if SoundManager.isDisabledSound() {
            soundButton.disable()
        }
        soundButton.position = CGPoint(x: playButton.size.width / 2 - soundButton.size.width/2, y: leaderboardButton.position.y)
        soundButton.setTouchHandler {
            SoundManager.toogleSound()
        }
        
        layout.addChild(leaderboardButton)
        layout.addChild(shopButton)
        layout.addChild(soundButton)
        layout.alignment = .center
        layout.layout()
        layout.applyGlobalPosition(scene: self)
        self.addChild(layout)
    }
    
    func setupWaves() {
        let wave01 = SKSpriteNode.init(imageNamed: "Wave01")
        wave01.anchorPoint = CGPoint(x: 0.5, y: 0)
        wave01.position = CGPoint(x: self.size.width / 2, y: 0)
        
        let wave02 = SKSpriteNode.init(imageNamed: "Wave02")
        wave02.anchorPoint = CGPoint(x: 0.5, y: 0)
        wave02.position = CGPoint(x: self.size.width / 2, y: 0)
        
        self.addChild(wave01)
        self.addChild(wave02)
        
        // Setup animation
        let waveAction = SKAction.scaleX(by: 1, y: 0.8, duration: 2)
        let reverseAction = waveAction.reversed()
        let delayAction = SKAction.wait(forDuration: 0.2)
        let sequence01 = SKAction.repeatForever(SKAction.sequence([waveAction, reverseAction]))
        let sequence02 = SKAction.repeatForever(SKAction.sequence([delayAction, waveAction, reverseAction]))
        wave01.run(sequence01)
        wave02.run(sequence02)
    }

}

extension MenuTestScene {
    
    func goToGameScene() {
        let gameScene = GameScene.create()
        let transition = SKTransition.fade(with: .white, duration: 0.3)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
}
