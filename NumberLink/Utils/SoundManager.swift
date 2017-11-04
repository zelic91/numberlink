//
//  SoundManager.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 11/4/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import AVFoundation

class SoundManager {
    
    static var backgroundPlayer: AVAudioPlayer?
    static var effectPlayer: AVAudioPlayer?
    static let backgroundSound = "background"
    static let popSound = "pop"
    static let keyDisableSound = "enableSound"
    
    static func toogleSound() {
        let disableSound = !isDisabledSound()
        UserDefaults.standard.set(disableSound, forKey: keyDisableSound)
        if disableSound {
            stopBackground()
        } else {
            playBackground()
        }
    }
    
    static func isDisabledSound() -> Bool {
        return UserDefaults.standard.bool(forKey: keyDisableSound)
    }
    
    static func playBackground() {
        
        if !isDisabledSound() {
            stopBackground()
            
            let fileURL = Bundle.main.url(forResource: backgroundSound, withExtension: "mp3")!
            
            do {
                backgroundPlayer = try AVAudioPlayer(contentsOf: fileURL)
                backgroundPlayer!.volume = 0.75
                backgroundPlayer!.numberOfLoops = -1
                backgroundPlayer!.prepareToPlay()
                backgroundPlayer!.play()
            } catch _ {
                backgroundPlayer = nil
            }
        }
    }
    
    static func stopBackground() {
        if backgroundPlayer != nil {
            backgroundPlayer!.stop()
            backgroundPlayer = nil
        }
    }
    
    static func playPop() {
        playEffect(effectName: popSound)
    }
    
    static func playEffect(effectName: String) {
        if !isDisabledSound() {
            stopEffect()
            
            let fileURL = Bundle.main.url(forResource: effectName, withExtension: "mp3")!
            
            do {
                effectPlayer = try AVAudioPlayer(contentsOf: fileURL)
                effectPlayer!.volume = 0.75
                effectPlayer!.numberOfLoops = 1
                effectPlayer!.prepareToPlay()
                effectPlayer!.play()
            } catch _ {
                effectPlayer = nil
            }
        }
    }
    
    static func stopEffect() {
        if effectPlayer != nil {
            effectPlayer!.stop()
            effectPlayer = nil
        }
    }
}

