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
    
    // Menu
    let starNode = SKSpriteNode(imageNamed: "CupSmall")
    let scoreNode = SKLabelNode(fontNamed: "ProximaNovaSoft-Semibold")
    let progressNode = ProgressNode()
    let exitButton = ButtonNode("Exit")
    
    let gameOverScreen = GameOverNode.create()
    let pauseScreen = PauseNode.create()
    
    // Gameplay
    let gamePlay = Gameplay()
    
    // Game elements
    let elementRadius: CGFloat = 40
    let radius: CGFloat = 120
    let padding: CGFloat = 20
    let colors = [
        UIColor(red:0.09, green:0.63, blue:0.52, alpha:1.0),
        UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.0),
        UIColor(red:0.16, green:0.50, blue:0.73, alpha:1.0),
        UIColor(red:0.95, green:0.61, blue:0.07, alpha:1.0),
        UIColor(red:0.83, green:0.33, blue:0.00, alpha:1.0)
    ]
    var shapeNodes = [NumberNode]()
    var labelNodes = [SKLabelNode]()
    var shapePositions = [CGPoint]()
    var labels = [String]()
    
    // Paths created by touches
    var pathShapes: [SKShapeNode] = [SKShapeNode]()
    var currentPath: SKShapeNode = SKShapeNode()
    var currentNode: NumberNode?
    
    // Gameplay
    var addedNumber: [Int] = [Int]()
    
    // Init
    static func create() -> GameScene {
        let scene = GameScene(size: CGSize(width: 375, height: 667))
        scene.scaleMode = .aspectFill
        return scene
    }
    
    // MARK: - Life cycle
    
    override func didMove(to view: SKView) {
        setupView()
        setupScore()
        setupMenu()
        setupProgress()
        setupGameElements()
        newGame()
    }
}

// MARK: - Game stuff
    
extension GameScene {
    
    func setupView() {
        backgroundColor = .white
        
        gameOverScreen.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        gameOverScreen.hide()
        gameOverScreen.replayButton.setTouchHandler { [weak self] in
            self?.gameOverScreen.hide()
            self?.newGame()
        }
        
        gameOverScreen.homeButton.setTouchHandler { [weak self] in
            self?.goToMenuScreen()
        }
        
        pauseScreen.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        pauseScreen.hide()
        pauseScreen.replayButton.setTouchHandler { [weak self] in
            self?.pauseScreen.hide()
            self?.newGame()
        }
        
        pauseScreen.homeButton.setTouchHandler { [weak self] in
            self?.goToMenuScreen()
        }
        addChild(pauseScreen)
    }
    
    func setupScore() {
        starNode.position = CGPoint(x: self.size.width / 2 - 30, y: self.size.height - 70)
        scoreNode.position = CGPoint(x: self.size.width / 2 + 10 + scoreNode.frame.size.width, y: self.size.height - 90)
        scoreNode.text = "\(gamePlay.score)"
        scoreNode.horizontalAlignmentMode = .left
        scoreNode.fontSize = 60
        scoreNode.fontColor = Common.mainColor
        
        addChild(scoreNode)
        addChild(starNode)
    }
    
    func setupMenu() {
        exitButton.position = CGPoint(x: self.size.width - 10 - exitButton.size.width / 2, y: self.size.height - exitButton.size.height/2 - 10)
        exitButton.setTouchHandler { [weak self] in
            self?.pauseScreen.show()
        }
        self.addChild(exitButton)
    }
    
    func setupProgress() {
        addChild(progressNode)
        progressNode.position = CGPoint(x: 10 + progressNode.size().width/2, y: exitButton.position.y)
    }
    
    func setupGameElements() {
        // Setup random numbers
        srandom(UInt32(time(nil)))
        
        setupNumberShapes()
        animateNumberShapes()
    }
    
    func setupNumberShapes() {
        // Setup current path
        addChild(currentPath)
        
        let centerPoint = CGPoint(x: size.width/2, y: padding + elementRadius + radius + 30)
        for i in 0..<5 {
            let shape = NumberNode(circleOfRadius: elementRadius)
            shape.fillColor = .white
            shape.lineWidth = 4
            let x: CGFloat = centerPoint.x + radius * CGFloat(sin( Double(i) * 2.0 * Double.pi / 5))
            let y: CGFloat = centerPoint.x + radius * CGFloat(cos( Double(i) * 2.0 * Double.pi / 5))
            let point = CGPoint(x: x, y: y)
            shapePositions.append(point)
            shape.position = point
            
            let label = SKLabelNode(fontNamed: "ProximaNovaSoft-Semibold")
            label.fontSize = 44
            label.verticalAlignmentMode = .center
            label.isUserInteractionEnabled = false
            shape.addChild(label)
            addChild(shape)
            labelNodes.append(label)
            shapeNodes.append(shape)
        }
    }
    
    func animateNumberShapes() {
        var delayTimes = [Double]()
        var index = 0
        var maxDelayTime = 0.0
        for i in 0..<5 {
            let currentDelayTime = TimeInterval(CGFloat(arc4random() % 10) / 20.0)
            delayTimes.append(currentDelayTime)
            if currentDelayTime > maxDelayTime {
                maxDelayTime = currentDelayTime
                index = i
            }
        }
        
        for i in 0..<5 {
            let shape = shapeNodes[i]
            let originLocation = shapePositions[i]
            shape.position = CGPoint(x: originLocation.x, y: originLocation.y - 20)
            shape.alpha = 0
            shape.xScale = 1
            shape.yScale = 1
            
            let fadeInAnim = SKAction.fadeIn(withDuration: 0.2)
            let transitionAnim = SKAction.move(to: originLocation, duration: 0.2)
            let groupAnim = SKAction.group([fadeInAnim, transitionAnim])
            if i == index {
                shape.run(SKAction.sequence([SKAction.wait(forDuration: delayTimes[i]), groupAnim, SKAction.run { [weak self] in
                        self?.gamePlay.waitForNewRound = false
                    }]))
            } else {
                shape.run(SKAction.sequence([SKAction.wait(forDuration: delayTimes[i]), groupAnim]))
            }
        }
    }
    
    // MARK: Reload
    
    func newGame() {
        gamePlay.score = 0
        reloadGame()
    }
    
    func reloadScore() {
        scoreNode.text = "\(gamePlay.score)"
    }
    
    func reloadGame() {
        reloadScore()
        gamePlay.reloadGame()
        clearPaths()
        reloadNumberShapes()
        animateNumberShapes()
        reloadProgress()
    }
    
    func reloadChoices() {
        gamePlay.reloadChoices()
        clearPaths()
        for node in shapeNodes {
            node.xScale = 1
            node.yScale = 1
        }
    }
    
    func reloadNumberShapes() {
        for i in 0..<labelNodes.count {
            let value = gamePlay.numbers[i]
            let node = shapeNodes[i]
            let label = labelNodes[i]
            label.text = "\(value)"
            node.number = value
            node.strokeColor = colors[gamePlay.colors[i]]
            label.fontColor = colors[gamePlay.colors[i]]
        }
    }
    
    func reloadProgress() {
        progressNode.startProgress(in: 5, with: { [weak self] in
            self?.showGameOver()
        })
    }
}

// MARK: - Navigation
extension GameScene {
    
    func goToMenuScreen() {
        let scene = MenuScene.create()
        let transition = SKTransition.fade(withDuration: 0.3)
        self.view?.presentScene(scene, transition: transition)
    }
    
    func showGameOver() {
        gameOverScreen.show()
    }
}

// MARK: Touch handlers

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchNode = findShapeNode(with: touches)
        if let node = touchNode {
            node.animateSelectNode()
            gamePlay.addChoice(number: node.number)
            currentNode = node
            refreshPath()
            if (!gamePlay.started) {
                reloadProgress()
                gamePlay.started = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchNode = findShapeNode(with: touches)
        if let node = touchNode, currentNode != nil, node.position != currentNode!.position, gamePlay.canAdd(number: node.number), !gamePlay.waitForNewRound {
            
            node.animateSelectNode()
            gamePlay.addChoice(number: node.number)
            finishPath(to: node)
            
            if gamePlay.checkWin() {
                reloadGame()
            } else if !gamePlay.canPlay() {
                currentNode = nil
                reloadChoices()
            }
        } else {
            let location = touches.first!.location(in: self)
            modifyPath(to: location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for i in 0..<shapeNodes.count {
            shapeNodes[i].removeAllActions()
            shapeNodes[i].xScale = 1
            shapeNodes[i].yScale = 1
        }
        
        reloadChoices()
    }
    
    func existNumber(node: NumberNode) -> Bool {
        if let _ = addedNumber.index(of: node.number) {
            return true
        }
        return false
    }
    
    func findShapeNode(with touches: Set<UITouch>) -> NumberNode? {
        let position = touches.first!.location(in: self)
        let nodes = self.nodes(at: position)
        return nodes.filter { node -> Bool in
            node.isKind(of: NumberNode.self)
            }.first as? NumberNode
    }
    
    func refreshPath() {
        if let node = currentNode {
            currentPath.strokeColor = node.strokeColor
            currentPath.lineWidth = 4
            currentPath.zPosition = -1
            currentPath.fillColor = .clear
            currentPath.path = nil
        }
    }
    
    func modifyPath(to position: CGPoint) {
        if let node = currentNode {
            let path = UIBezierPath()
            path.move(to: node.position)
            path.addLine(to: position)
            currentPath.path = path.cgPath
            currentPath.strokeColor = node.strokeColor
        }
    }
    
    func finishPath(to node: NumberNode) {
        addedNumber.append(node.number)
        addGradientPath(node: node)
        refreshPath()
        currentNode = node
    }
    
    func addGradientPath(node: SKShapeNode) {
        let dx = Double(node.position.x - currentNode!.position.x)
        let dy = Double(currentNode!.position.y - node.position.y)
        let path = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 4, height: sqrt(dx * dx + dy * dy))))
        let shader = SKShader(fileNamed: "Gradient.fsh")
        let fromColor = SKColor(cgColor: (currentNode?.strokeColor.cgColor)!)
        let toColor = SKColor(cgColor: node.strokeColor.cgColor)
        let topUniform = SKUniform(name: "topColor")
        let bottomUniform = SKUniform(name: "bottomColor")
        let angleUniform = SKUniform(name: "angle")
        topUniform.floatVector4Value = fromColor.vec4()
        bottomUniform.floatVector4Value = toColor.vec4()
        angleUniform.floatValue = 1.0
        if dy >= 0 {
            path.zRotation = CGFloat(atan(dx / dy))
        } else {
            path.zRotation = CGFloat(atan(dx / dy) + Double.pi)
        }
        
        if dx < 0 {
            angleUniform.floatValue = -1.0
        } else if dx == 0 {
            angleUniform.floatValue = 0.0
        }
        
        if dx > 0 || dy < 0 {
            topUniform.floatVector4Value = toColor.vec4()
            bottomUniform.floatVector4Value = fromColor.vec4()
        } else {
            topUniform.floatVector4Value = fromColor.vec4()
            bottomUniform.floatVector4Value = toColor.vec4()
        }
        
        let uniforms = [
            topUniform,
            bottomUniform,
            angleUniform
        ]
        shader.uniforms = uniforms
        path.fillShader = shader
        path.position = node.position
        path.zPosition = -1
        
        addChild(path)
        pathShapes.append(path)
    }
    
    func clearPaths() {
        gamePlay.reloadChoices()
        self.removeChildren(in: pathShapes)
        pathShapes.removeAll()
        refreshPath()
    }
}