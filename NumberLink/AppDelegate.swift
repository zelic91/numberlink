//
//  AppDelegate.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/8/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GADMobileAds.configure(withApplicationID: Common.admobAppID)
        configAlertView()
        
        return true
    }
    
    func configAlertView() {
        ZAlertView.blurredBackground = false
        ZAlertView.positiveColor = UIColor(red:0.37, green:0.68, blue:0.89, alpha:1.0)
        ZAlertView.buttonFont = UIFont(name: "ProximaNovaSoft-Semibold", size: 14)
        ZAlertView.alertTitleFont = UIFont(name: "ProximaNovaSoft-Semibold", size: 14)
        ZAlertView.messageFont = UIFont(name: "ProximaNovaSoft-Semibold", size: 14)
    }
}

