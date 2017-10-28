//
//  ButtonNode.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/28/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import SpriteKit

class ButtonNode: SKSpriteNode {
    
    fileprivate var touchHandler: (() -> ())?
    
    convenience init(_ name: String) {
        self.init(imageNamed: name)
        isUserInteractionEnabled = true
        color = .white
        colorBlendFactor = 0.3
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        color = .black
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        color = .white
        if let handler = touchHandler {
            handler()
        }
    }
    
    func setTouchHandler(_ touchHandler: (() -> ())?) {
        self.touchHandler = touchHandler
    }
    
}
