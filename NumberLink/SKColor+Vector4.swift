//
//  SKColor+Vector4.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/14/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import SpriteKit

extension SKColor {
    func vec4() -> GLKVector4
    {
        var r:CGFloat = 0.0
        var g:CGFloat = 0.0
        var b:CGFloat = 0.0
        var a:CGFloat = 0.0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return GLKVector4(v: (Float(r), Float(g), Float(b), Float(a)))
    }
}
