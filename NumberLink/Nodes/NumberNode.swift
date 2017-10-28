//
//  NumberNode.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/14/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import SpriteKit

class NumberNode: SKShapeNode {
    var number: Int!
    
    func animateSelectNode() {
        let scaleAction = SKAction.scale(to: 1.2, duration: 0.2)
        self.run(scaleAction)
    }
}
