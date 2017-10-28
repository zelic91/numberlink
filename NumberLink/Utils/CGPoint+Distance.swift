//
//  CGPoint+Distance.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/14/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import UIKit

extension CGPoint {
    static func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        let dx = from.x - to.x
        let dy = from.y - to.y
        return CGFloat(sqrt(Double(dx * dx + dy * dy)))
    }
}
