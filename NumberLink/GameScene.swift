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
    var score = 0
    
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
        UIColor(red:0.83, green:0.33, blue:0.00, alpha:1.0),
        UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
    ]
    var shapeNodes = [NumberNode]()
    var labelNodes = [SKLabelNode]()
    var shapePositions = [CGPoint]()
    var labels = [String]()
    
    // Paths created by touches
    var pathShapes: [SKShapeNode] = [SKShapeNode]()
    var currentNode: NumberNode?
    
    // Gameplay
    var relationships: [NumberNode: [NumberNode]] = [NumberNode: [NumberNode]]()
    
    // MARK: - Life cycle
    
    override func didMove(to view: SKView) {
        setupTestView()
        setupView()
        setupScore()
        setupMenu()
        setupGame()
    }
    
    
    // MARK: - Game stuff
    
    func setupTestView() {
        let node = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 4, height: 100)))
        let shader = SKShader(fileNamed: "Gradient.fsh")
        let topColor = SKColor.blue
        let bottomColor = SKColor.red
        let topUniform = SKUniform(name: "topColor")
        topUniform.floatVector4Value = topColor.vec4()
        let bottomUniform = SKUniform(name: "bottomColor")
        bottomUniform.floatVector4Value = bottomColor.vec4()
        let uniforms = [
            topUniform,
            bottomUniform
        ]
        shader.uniforms = uniforms
        node.fillShader = shader
        node.position = CGPoint(x: size.width / 2, y: size.height / 2)
        node.zRotation = CGFloat(Double.pi / 4)
        addChild(node)
    }
    
    func setupView() {
        scaleMode = .aspectFill
        backgroundColor = .white
    }
    
    func setupScore() {
        starNode.position = CGPoint(x: self.size.width / 2 - 30, y: self.size.height - 140)
        scoreNode.position = CGPoint(x: self.size.width / 2 + 10 + scoreNode.frame.size.width, y: self.size.height - 165)
        scoreNode.text = "\(score)"
        scoreNode.horizontalAlignmentMode = .left
        scoreNode.fontSize = 70
        scoreNode.fontColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:1.0)
        
        addChild(scoreNode)
        addChild(starNode)
    }
    
    func setupMenu() {
        let homeButton = SKSpriteNode(imageNamed: "Home")
        homeButton.name = "homeButton"
        homeButton.position = CGPoint(x: self.size.width/2, y: self.size.height - 50)
        self.addChild(homeButton)
    }
    
    func setupGame() {
        // Setup random numbers
        srandom(UInt32(time(nil)))
        
        setupShapes()
        animateShapes()
    }
    
    func setupShapes() {
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
        reloadLabels()
        reloadRelationships()
    }
    
    func animateShapes() {
        for i in 0..<5 {
            let shape = shapeNodes[i]
            let originLocation = shapePositions[i]
            shape.position = CGPoint(x: originLocation.x, y: originLocation.y - 20)
            shape.alpha = 0
            
            let fadeInAnim = SKAction.fadeIn(withDuration: 0.2)
            let transitionAnim = SKAction.move(to: originLocation, duration: 0.2)
            let groupAnim = SKAction.group([fadeInAnim, transitionAnim])
            shape.run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(CGFloat(arc4random() % 10) / 20.0)), groupAnim]))
        }
    }
    
    // MARK: Reload
    func reloadLabels() {
        var values: [Int] = [Int]()
        for label in labelNodes {
            var value: Int
            repeat {
                value = Int(arc4random() % 10)
            } while (values.index(of: value) != nil)
            values.append(value)
            label.text = "\(value)"
        }
    }
    
    func reloadRelationships() {
        for shape in shapeNodes {
            relationships[shape] = []
        }
    }
    
    // MARK: - Utils
    
    func increaseScore() {
        score += 1
        scoreNode.text = "\(score)"
    }
    
    
    
    func goToMenuScreen() {
        let scene = MenuScene(size: self.size)
        let transition = SKTransition.doorway(withDuration: 0.3)
        self.view?.presentScene(scene, transition: transition)
    }
}

// MARK: Touch handlers

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchNode = findShapeNode(with: touches)
        if let node = touchNode {
            currentNode = node
            addPath()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchNode = findShapeNode(with: touches)
        if let node = touchNode, currentNode != nil, node.position != currentNode!.position, !existRelationship(from: currentNode!, to: node) {
            finishPath(to: node)
            
            if (pathShapes.count == 5) {
                clearPaths()
                reloadRelationships()
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
            clearPaths()
            reloadRelationships()
            animateShapes()
        }
    }
    
    func existRelationship(from: NumberNode, to: NumberNode) -> Bool {
        if let _ = relationships[from]?.index(of: to) {
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
    
    func addPath() {
        if let node = currentNode {
            let shape = SKShapeNode()
            shape.strokeColor = node.strokeColor
            shape.lineWidth = 4
            shape.zPosition = -1
            shape.fillColor = .clear
            pathShapes.append(shape)
            addChild(shape)
        }
    }
    
    func modifyPath(to position: CGPoint) {
        if let node = currentNode {
            let path = UIBezierPath()
            path.move(to: node.position)
            path.addLine(to: position)
            pathShapes.last?.path = path.cgPath
        }
    }
    
    func finishPath(to node: NumberNode) {
        relationships[node]?.append(currentNode!)
        relationships[currentNode!]?.append(node)
        
        modifyPath(to: node.position)
        currentNode = node
        addPath()
    }
    
    func clearPaths() {
        self.removeChildren(in: pathShapes)
        pathShapes.removeAll()
    }
}
