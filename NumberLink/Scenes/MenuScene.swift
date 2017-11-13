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
    
    var playButton: ButtonNode!
    var shopButton: ButtonNode!
    var leaderboardButton: ButtonNode!
    var soundButton: ButtonNode!
    
    var animManager: AnimManager = AnimManager()
    var animInPool: AnimPool!
    var animOutPool: AnimPool!
    let animInPoolName = "menuInPool"
    let animOutPoolName = "menuOutPool"
    
    // Init
    static func create() -> MenuScene {
        let scene = MenuScene(size: CGSize(width: 375, height: 667))
        scene.scaleMode = .aspectFill
        return scene
    }
    
    override func didMove(to view: SKView) {
        SoundManager.playBackground()
        
        setupView()
        setupAnimation()
        animateIn()
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
    
    func animateIn() {
        animInPool.run()
    }
    
    func animateOut() {
        animOutPool.run()
    }
    
    func setupAnimation() {
        animInPool = animManager.addPool(animInPoolName)
        animOutPool = animManager.addPool(animOutPoolName)
        let timingFunction = Anim.createTimingFunction()
        setupAnimationIn(timingFunction: timingFunction)
        setupAnimationOut(timingFunction: timingFunction)
    }
    
    func setupAnimationIn(timingFunction: ((CGFloat) -> CGFloat)?) {
        
        // Small logo
        _ = animInPool.createAnim(node: logoNode)?
                            .moveIn(distance: CGPoint(x: 0, y: 50), duration: 0.5, timingFunction: timingFunction, delay: 0)
        // Score
        
        _ = animInPool.createAnim(node: cupNode)?
            .moveIn(distance: CGPoint(x: 0, y: 50), duration: 0.5, timingFunction: timingFunction, delay: 0.1)
        
        _ = animInPool.createAnim(node: scoreLabel)?
            .moveIn(distance: CGPoint(x: 0, y: 50), duration: 0.5, timingFunction: timingFunction, delay: 0.1)
        
        // Menu
        _ = animInPool.createAnim(node: playButton)?
                               .moveIn(distance: CGPoint(x: 0, y: 50), duration: 0.5, timingFunction: timingFunction, delay: 0.1)
        
        _ = animInPool.createAnim(node: leaderboardButton)?
                                       .moveIn(distance: CGPoint(x: 0, y: 50), duration: 0.5, timingFunction: timingFunction, delay: 0.3)
        
        _ = animInPool.createAnim(node: shopButton)?
                               .moveIn(distance: CGPoint(x: 0, y: 50), duration: 0.5, timingFunction: timingFunction, delay: 0.2)
        
        _ = animInPool.createAnim(node: soundButton)?
                                .moveIn(distance: CGPoint(x: 0, y: 50), duration: 0.5, timingFunction: timingFunction, delay: 0.2)
    }
    
    func setupAnimationOut(timingFunction: ((CGFloat) -> CGFloat)?) {
        
        // Small logo
        _ = animOutPool.createAnim(node: logoNode)?
            .moveOut(distance: CGPoint(x: 0, y: 50), duration: 0.5, timingFunction: timingFunction, delay: 0)
        // Score
        
        _ = animOutPool.createAnim(node: cupNode)?
            .moveOut(distance: CGPoint(x: 0, y: 50), duration: 0.5, timingFunction: timingFunction, delay: 0.1)
        
        _ = animOutPool.createAnim(node: scoreLabel)?
            .moveOut(distance: CGPoint(x: 0, y: 50), duration: 0.5, timingFunction: timingFunction, delay: 0.1)
        
        // Menu
        _ = animOutPool.createAnim(node: playButton)?
            .moveOut(distance: CGPoint(x: 0, y: 50), duration: 0.5, timingFunction: timingFunction, delay: 0.1)
        
        _ = animOutPool.createAnim(node: leaderboardButton)?
            .moveOut(distance: CGPoint(x: 0, y: 50), duration: 0.5, timingFunction: timingFunction, delay: 0.3)
        
        _ = animOutPool.createAnim(node: shopButton)?
            .moveOut(distance: CGPoint(x: 0, y: 50), duration: 0.5, timingFunction: timingFunction, delay: 0.2)
        
        _ = animOutPool.createAnim(node: soundButton)?
            .moveOut(distance: CGPoint(x: 0, y: 50), duration: 0.5, timingFunction: timingFunction, delay: 0.2)
        
        animOutPool.addAfterAction(node: self) {
            self.goToGameScene()
        }
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
        
        scoreLabel = SKLabelNode(fontNamed: Common.fontName)
        scoreLabel.text = "\(ScoreUtil.getScore())"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = Common.mainColor
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.isUserInteractionEnabled = false
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: cupNode.position.y - cupNode.size.height / 2 - 40)
        
        addChild(scoreLabel)
    }
    
    func setupButtons() {
        let buttonGroup = SKNode()

        playButton = ButtonNode("Play")
        playButton.setTouchHandler {
            self.animateOut()
        }
        
        leaderboardButton = ButtonNode("Leaderboard")
        leaderboardButton.setTouchHandler {
            ScoreUtil.showLeaderboard()
        }
        leaderboardButton.position = CGPoint(x: -playButton.size.width / 2 + leaderboardButton.size.width/2, y: playButton.position.y - leaderboardButton.size.height - 10)
        
        shopButton = ButtonNode("Cart")
        shopButton.position = CGPoint(x: playButton.position.x, y: leaderboardButton.position.y)
        shopButton.setTouchHandler {
            IAPManager.getInstance()?.purchase()
        }
        
        soundButton = ButtonNode.createToggle(normal: "Sound On", disable: "Sound Off")
        soundButton.position = CGPoint(x: playButton.size.width / 2 - soundButton.size.width/2, y: leaderboardButton.position.y)
        soundButton.setTouchHandler {
            SoundManager.toogleSound()
        }
        
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
        let waveAction = SKAction.scaleX(by: 1, y: 0.8, duration: 2)
        let reverseAction = waveAction.reversed()
        let delayAction = SKAction.wait(forDuration: 0.2)
        let sequence01 = SKAction.repeatForever(SKAction.sequence([waveAction, reverseAction]))
        let sequence02 = SKAction.repeatForever(SKAction.sequence([delayAction, waveAction, reverseAction]))
        wave01.run(sequence01)
        wave02.run(sequence02)
    }

}

extension MenuScene {
    
    func goToGameScene() {
        let gameScene = GameScene.create()
        let transition = SKTransition.fade(with: .white, duration: 0.3)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
}
