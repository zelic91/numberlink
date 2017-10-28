//
//  ScoreUtil.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/28/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import Foundation

class ScoreUtil {
    
    static let scoreKey = "best_score"
    
    static func setScore(value: Int) {
        let currentScore = getScore()
        if value > currentScore {
            UserDefaults.standard.set(value, forKey: scoreKey)
        }
    }
    
    static func getScore() -> Int {
        let score = UserDefaults.standard.value(forKey: scoreKey)
        return score != nil ? score as! Int : 0
    }
    
}
