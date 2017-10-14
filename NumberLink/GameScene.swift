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
    
    let starNode = SKSpriteNode(imageNamed: "Star")
    let scoreNode = SKLabelNode(fontNamed: "ProximaNovaSoft-Semibold")
    var score = 1
    
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
    var currentNode: SKShapeNode?
    
    // MARK: - Life cycle
    
    override func didMove(to view: SKView) {
        setupView()
        setupScore()
        setupMenu()
        setupGame()
    }
    
    
    // MARK: - Game stuff
    
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
        if let node = touchNode, currentNode != nil, node.position != currentNode!.position {
            finishPath(to: node)
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
            animateShapes()
            increaseScore()
            reloadLabels()
        }
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
        modifyPath(to: node.position)
//        let pathShape = pathShapes.last!
//
//        let gradientShader = SKShader(fileNamed: "Gradient.fsh")
//        let topColor = SKColor(cgColor: currentNode!.strokeColor.cgColor)
//        let bottomColor = SKColor(cgColor: node.strokeColor.cgColor)
//        let topColorUniform = SKUniform(name: "topColor")
//        topColorUniform.floatVector4Value = topColor.vec4()
//        let bottomColorUniform = SKUniform(name: "bottomColor")
//        bottomColorUniform.floatVector4Value = bottomColor.vec4()
//        let uniforms = [
//            topColorUniform,
//            bottomColorUniform
//        ]
//        gradientShader.uniforms = uniforms
//        pathShape.strokeShader = gradientShader
        
        currentNode = node
        addPath()
    }
    
    func clearPaths() {
        self.removeChildren(in: pathShapes)
    }
}
