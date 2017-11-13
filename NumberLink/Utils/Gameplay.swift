//
//  Gameplay.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/15/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import SpriteKit

class Gameplay {
    
    var numbers: [Int] = [Int]()
    var colors: [Int] = [Int]()
    var chosenNumbers: [Int] = [Int]()
    var score: Int = 0
    var bound: UInt32 = 10
    var time: Float = 0
    var started: Bool = false
    var waitForNewRound: Bool = false
    var isOver = false
    
    func addChoice(number: Int) {
        chosenNumbers.append(number)
    }
    
    func canPlay() -> Bool {
        return chosenNumbers.count < 5
    }
    
    func canAdd(number: Int) -> Bool {
        return chosenNumbers.index(of: number) == nil
    }
    
    func reloadChoices() {
        chosenNumbers.removeAll()
    }
    
    func newGame() {
        score = 0
        bound = 10
        time = 0
        started = false
        waitForNewRound = true
        isOver = false
        reloadChoices()
        reloadNumbers()
        reloadColors()
    }
    
    func reloadGame() {
        isOver = false
        waitForNewRound = true
        reloadChoices()
        reloadNumbers()
        reloadColors()
    }
    
    func reloadNumbers() {
        numbers.removeAll()
        for _ in 0...4 {
            var value = Int(arc4random() % bound)
            repeat {
                value = Int(arc4random() % bound)
            } while (numbers.index(of: value) != nil)
            numbers.append(value)
        }
    }
    
    func reloadColors() {
        colors.removeAll()
        for _ in 0...4 {
            var value = Int(arc4random() % 5)
            repeat {
                value = Int(arc4random() % 5)
            } while (colors.index(of: value) != nil)
            colors.append(value)
        }
    }
    
    func isAcceptable() -> Bool {
        for i in 1...4 {
            if (chosenNumbers[i] <= chosenNumbers[i-1]) {
                return false
            }
        }
        return true
    }
    
    func checkWin() -> Bool {
        if chosenNumbers.count == 5 {
            if isAcceptable() {
                win()
                return true
            }
            return false
        }
        return false
    }
    
    func win() {
        score += 1
        bound += 2
        if bound > 100 {
            bound = 100
        }
    }
    
    func getSolution() -> [Int] {
        return numbers.enumerated()
            .sorted { $0.element < $1.element }
            .map { offset, _ in
                offset
            }
    }
    
    func gameOver() {
        isOver = true
    }
}
