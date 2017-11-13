//
//  ButtonNode.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/28/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import SpriteKit

class ButtonNode: SKSpriteNode {
    
    enum ButtonType {
        case button
        case toggle
    }
    
    enum State {
        case normal
        case disabled
    }
    
    var buttonType: ButtonType = .button
    
    // State
    var state: State = .normal
    
    var normalImage: String!
    var disabledImage: String!
    
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
        
        if buttonType == .toggle {
            if state == .normal {
                disable()
            } else {
                normal()
            }
        }
        
        if let handler = touchHandler {
            handler()
        }
    }
    
    func setTouchHandler(_ touchHandler: (() -> ())?) {
        self.touchHandler = touchHandler
    }
    
}

extension ButtonNode {
    
    static func createToggle(normal: String, disable: String) -> ButtonNode {
        let ret = ButtonNode(normal)
        ret.buttonType = .toggle
        ret.normalImage = normal
        ret.disabledImage = disable
        return ret
    }
    
    func disable() {
        state = .disabled
        texture = SKTexture(imageNamed: disabledImage)
    }
    
    func normal() {
        state = .normal
        texture = SKTexture(imageNamed: normalImage)
    }
}
