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
    let starNode = SKSpriteNode(imageNamed: "Star")
    let scoreNode = SKLabelNode(fontNamed: "ProximaNovaSoft-Semibold")
    let progressNode = ProgressNode()
    let homeButton = SKSpriteNode(imageNamed: "Home")
    
    // Gameplay
    let gamePlay = Gameplay()
    
    // Game elements
    let elementRadius: CGFloat = 30
    let radius: CGFloat = 100
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
        scaleMode = .aspectFill
        backgroundColor = .white
    }
    
    func setupScore() {
        starNode.position = CGPoint(x: self.size.width / 2 - 30, y: self.size.height - 140)
        scoreNode.position = CGPoint(x: self.size.width / 2 + 10 + scoreNode.frame.size.width, y: self.size.height - 165)
        scoreNode.text = "\(gamePlay.score)"
        scoreNode.horizontalAlignmentMode = .left
        scoreNode.fontSize = 70
        scoreNode.fontColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:1.0)
        
        addChild(scoreNode)
        addChild(starNode)
    }
    
    func setupMenu() {
        homeButton.name = "homeButton"
        homeButton.position = CGPoint(x: self.size.width/2, y: self.size.height - 50)
        self.addChild(homeButton)
    }
    
    func setupProgress() {
        addChild(progressNode)
        progressNode.position = CGPoint(x: homeButton.position.x, y: homeButton.position.y - homeButton.size.height/2 - 15)
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
        
        let centerPoint = CGPoint(x: size.width/2, y: padding + elementRadius + radius)
        for i in 0..<5 {
            let shape = NumberNode(circleOfRadius: elementRadius)
            shape.fillColor = .white
            shape.strokeColor = colors[i]
            shape.lineWidth = 4
            let x: CGFloat = centerPoint.x + radius * CGFloat(sin( Double(i) * 2.0 * Double.pi / 5))
            let y: CGFloat = centerPoint.x + radius * CGFloat(cos( Double(i) * 2.0 * Double.pi / 5))
            let point = CGPoint(x: x, y: y)
            shapePositions.append(point)
            shape.position = point
            
            let label = SKLabelNode(fontNamed: "ProximaNovaSoft-Semibold")
            label.fontSize = 32
            label.fontColor = colors[i]
            label.color = .blue
            label.verticalAlignmentMode = .center
            label.isUserInteractionEnabled = false
            shape.addChild(label)
            addChild(shape)
            labelNodes.append(label)
            shapeNodes.append(shape)
        }
    }
    
    func animateNumberShapes() {
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
            shape.run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(CGFloat(arc4random() % 10) / 20.0)), groupAnim]))
        }
    }
    
    // MARK: Reload
    func newGame() {
        gamePlay.reloadGame()
        reloadNumberShapes()
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
    }
    
    func reloadChoices() {
        gamePlay.reloadChoices()
        clearPaths()
        for node in shapeNodes {
            debugPrint(node.number)
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
        }
    }
}

// MARK: - Navigation
extension GameScene {
    
    func goToMenuScreen() {
        let scene = MenuScene(size: self.size)
        let transition = SKTransition.fade(withDuration: 0.3)
        self.view?.presentScene(scene, transition: transition)
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
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchNode = findShapeNode(with: touches)
        if let node = touchNode, currentNode != nil, node.position != currentNode!.position, gamePlay.canAdd(number: node.number) {
            
            node.animateSelectNode()
            gamePlay.addChoice(number: node.number)
            finishPath(to: node)
            
            if gamePlay.checkWin() {
                reloadGame()
            } else if !gamePlay.canPlay() {
                reloadChoices()
            }
        } else {
            let location = touches.first!.location(in: self)
            modifyPath(to: location)
        }
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
        } else {
            let touchNode = findShapeNode(with: touches)
            if let node = touchNode {
                node.xScale = 1
                node.yScale = 1
            }
            reloadChoices()
        }
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
