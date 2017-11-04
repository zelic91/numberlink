//
//  ScoreUtil.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/28/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import Foundation
import GameKit

protocol ScoreDelegate {
    func showLeaderboard()
}

class ScoreUtil {
    
    static let scoreKey = "best_score"
    static let LEADER_BOARD_ID = "com.thuongnh.NumberLink"
    static var delegate: ScoreDelegate?
    
    static func setScore(value: Int) {
        let currentScore = getScore()
        if value > currentScore {
            UserDefaults.standard.set(value, forKey: scoreKey)
            
            let score = GKScore(leaderboardIdentifier: LEADER_BOARD_ID)
            score.value = Int64(value)
            // Submit score
            GKScore.report([score], withCompletionHandler: nil)
        }
    }
    
    static func getScore() -> Int {
        let score = UserDefaults.standard.value(forKey: scoreKey)
        return score != nil ? score as! Int : 0
    }
    
    static func showLeaderboard() {
        delegate?.showLeaderboard()
    }
    
}
