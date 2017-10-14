//
//  SKTexture+Gradient.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/14/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import UIKit
import SpriteKit

extension SKTexture {
    static func gradientTexture(from: CGPoint,
                                to: CGPoint,
                                startColor: UIColor,
                                endColor: UIColor) -> SKTexture? {
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CILinearGradient")
        filter?.setDefaults()
        let startVector = CIVector(x: from.x, y: from.y)
        let endVector = CIVector(x: to.x, y: to.y)
        filter?.setValue(startVector, forKey: "inputPoint0")
        filter?.setValue(endVector, forKey: "inputPoint1")
        filter?.setValue(CIColor(color: startColor), forKey: "inputColor0")
        filter?.setValue(CIColor(color: endColor), forKey: "inputColor1")
        if let image = filter?.outputImage {
            let cgImage = context.createCGImage(image, from: CGRect(x: 0, y: 0, width: clamp(abs(from.x - to.x)/4, 20, 4), height: clamp(abs(from.y - to.y)/4, 20, 4)))
            return SKTexture(cgImage: cgImage!)
        }
        return nil
    }
    
    static func clamp(_ input: CGFloat, _ upperBound: CGFloat, _ lowerBound: CGFloat) -> CGFloat {
        if input > upperBound {
            return upperBound
        }
        
        if input < lowerBound {
            return lowerBound
        }
        return input
    }
}
