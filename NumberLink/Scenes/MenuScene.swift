//
//  MenuScene.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/8/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var logoNode: SKSpriteNode!
    var cupNode: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    // Init
    static func create() -> MenuScene {
        let scene = MenuScene(size: CGSize(width: 375, height: 667))
        scene.scaleMode = .aspectFill
        return scene
    }
    
    override func didMove(to view: SKView) {
        setupView()
    }
    
}

extension MenuScene {
    
    func setupView() {
        backgroundColor = .white
        scaleMode = .aspectFill
        
        setupLogo()
        setupScore()
        setupButtons()
        setupWaves()
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
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: cupNode.position.y - cupNode.size.height / 2 - 30)
        
        addChild(scoreLabel)
    }
    
    func setupButtons() {
        let buttonGroup = SKNode()

        let playButton = ButtonNode("Play")
        playButton.setTouchHandler { [weak self] in
            self?.goToGameScene()
        }
        
        let leaderboardButton = ButtonNode("Leaderboard")
        leaderboardButton.position = CGPoint(x: -playButton.size.width / 2 + leaderboardButton.size.width/2, y: playButton.position.y - leaderboardButton.size.height - 10)
        
        let shopButton = ButtonNode("Cart")
        shopButton.position = CGPoint(x: playButton.position.x, y: leaderboardButton.position.y)
        
        let soundButton = ButtonNode("Sound On")
        soundButton.position = CGPoint(x: playButton.size.width / 2 - soundButton.size.width/2, y: leaderboardButton.position.y)
        
        buttonGroup.addChild(playButton)
        buttonGroup.addChild(leaderboardButton)
        buttonGroup.addChild(shopButton)
        buttonGroup.addChild(soundButton)
        buttonGroup.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 50)
        self.addChild(buttonGroup)
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
        let waveAction = SKAction.moveBy(x: 0, y: -10, duration: 1)
        let reverseAction = waveAction.reversed()
        let delayAction = SKAction.wait(forDuration: 0.5)
        let sequence01 = SKAction.repeatForever(SKAction.sequence([waveAction, reverseAction]))
        let sequence02 = SKAction.repeatForever(SKAction.sequence([delayAction, waveAction, reverseAction]))
        wave01.run(sequence01)
        wave02.run(sequence02)
    }

}

extension MenuScene {
    
    func goToGameScene() {
        let gameScene = GameScene.create()
        let transition = SKTransition.fade(withDuration: 0.3)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
}
