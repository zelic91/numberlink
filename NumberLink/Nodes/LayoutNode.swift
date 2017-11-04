//
//  LayoutNode.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/30/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import SpriteKit

protocol Layoutable {
    func layout() -> CGSize
}

class LayoutNode: SKNode {
    
    enum Orientation {
        case horizontal
        case vertical
    }
    
    enum Alignment {
        case top
        case bottom
        case left
        case right
        case center
        case justified
    }
    
    var padding: CGFloat! = 10
    var orientation: Orientation = .vertical
    var alignment: Alignment = .center
    var margin: CGFloat! = 10
    var contentSize: CGSize!
    var sizeMap: [SKNode: CGSize] = [:]
    
    func measure() -> CGSize {
        if orientation == .horizontal {
            return measureHorizontal()
        } else {
            return measureVertical()
        }
    }
    
    func measureHorizontal() -> CGSize {
        var width:CGFloat = 0
        var height:CGFloat = 0
        let totalPadding: CGFloat = CGFloat(children.count) * padding
        
        for child in children {
            let childSize = getChildSize(child: child)
            sizeMap[child] = childSize
            width += childSize.width
            if childSize.height > height {
                height = childSize.height
            }
        }
        
        return CGSize(width: width + totalPadding, height: height)
    }
    
    func measureVertical() -> CGSize {
        var width:CGFloat = 0
        var height:CGFloat = 0
        let totalPadding: CGFloat = CGFloat(children.count) * padding
        
        for child in children {
            let childSize = getChildSize(child: child)
            sizeMap[child] = childSize
            height += childSize.height
            if childSize.width > width {
                width = childSize.width
            }
        }
        
        return CGSize(width: width, height: height + totalPadding)
    }
    
    func getChildSize(child: SKNode) -> CGSize {
        var childSize = CGSize.zero
        if child.isKind(of: SKShapeNode.self) || child.isKind(of: SKLabelNode.self) {
            childSize = (child as! SKShapeNode).frame.size
        } else if child.isKind(of: SKSpriteNode.self) {
            childSize = (child as! SKSpriteNode).size
        } else if child.isKind(of: LayoutNode.self) {
            childSize = (child as! LayoutNode).measure()
        }
        return childSize
    }
    
    func layout() {
        contentSize = measure()
        
        if orientation == .horizontal {
            layoutHorizontal()
        } else {
            layoutVertical()
        }
    }
    
    func applyGlobalPosition(scene: SKScene) {
        let x: CGFloat = contentSize.width / 2
        let y: CGFloat = contentSize.height / 2
        let sceneSize = scene.size
        switch alignment {
        case .bottom:
            position = CGPoint(x: sceneSize.width / 2, y: margin + y)
            break
        case .top:
            position = CGPoint(x: sceneSize.width / 2, y: sceneSize.height - margin - y)
            break
        case .left:
            position = CGPoint(x: margin + x, y: sceneSize.height / 2)
            break
        case .right:
            position = CGPoint(x: sceneSize.width - margin - x, y: sceneSize.height / 2)
            break
        default:
            position = CGPoint(x: sceneSize.width / 2, y: sceneSize.height / 2)
        }
    }
    
    func layoutHorizontal() {
        var x:CGFloat = -contentSize.width / 2
        let y:CGFloat = 0
        
        for child in children {
            let childSize = sizeMap[child]!
            let childX: CGFloat = x + childSize.width / 2
            child.position = CGPoint(x: childX, y: y)
            x += childSize.width + padding
            if child.isKind(of: LayoutNode.self) {
                (child as! LayoutNode).layout()
            }
        }
    }
    
    func layoutVertical() {
        let x:CGFloat = 0
        var y:CGFloat = contentSize.height / 2
        
        for child in children {
            let childSize = sizeMap[child]!
            let childY: CGFloat = y - childSize.height / 2
            child.position = CGPoint(x: x, y: childY)
            y -= childSize.height + padding
            if child.isKind(of: LayoutNode.self) {
                (child as! LayoutNode).layout()
            }
        }
    }
}
