//
//  AdsManager.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/30/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import Foundation

protocol AdsDelegate {
    func show()
    func hide()
}

class AdsManager {
    
    static var canShowAds: Bool = false
    static var delegate: AdsDelegate? = nil
    
    static func showAds() {
        if allowAds() {
            delegate?.show()
        }
    }
    
    static func hideAds() {
        delegate?.hide()
    }
    
    static func allowAds() -> Bool {
        return !UserDefaults.standard.bool(forKey: Common.keyAds)
    }
    
    static func disableAds() {
        UserDefaults.standard.set(true, forKey: Common.keyAds)
    }
    
}
