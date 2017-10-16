//
//  Gameplay.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/15/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import SpriteKit

class Gameplay {
    
    var userResult: [NumberNode] = [NumberNode]()
    var result: [NumberNode] = [NumberNode]()
    
    func checkResult() -> Bool {
        if userResult.count == 5 {
            for i in 1..<userResult.count {
                if userResult[i].number < userResult[i-1].number {
                    return false
                }
            }
            return true
        }
        return true
    }
    
    func resetResult() {
        userResult.removeAll()
        result.removeAll()
    }
}
