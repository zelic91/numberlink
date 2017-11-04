//
//  GameViewController.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 10/8/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import GoogleMobileAds

class GameViewController: UIViewController {

    var gameCenterEnabled: Bool = false
    
    @IBOutlet weak var vBanner: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = MenuTestScene(size: CGSize(width: 375, height: 667))
            scene.scaleMode = .aspectFit
            view.presentScene(scene)
            
            view.allowsTransparency = true
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        // Game center
        authenticateLocalPlayer()
        ScoreUtil.delegate = self
        
        AdsManager.delegate = self
        setupAdsBanner()
        
        IAPManager.getInstance()?.fetchProducts()
        IAPManager.getInstance()?.delegate = self
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController {
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = { (viewController, error) -> Void in
            if (viewController != nil) {
                self.present(viewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                self.gameCenterEnabled = true
                
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardId, error) in
                    if error != nil {
                    } else {
                    }
                })
            } else {
                self.gameCenterEnabled = false
            }
        }
    }
}

extension GameViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}

extension GameViewController: ScoreDelegate {
    func showLeaderboard() {
        let gcViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        gcViewController.viewState = .leaderboards
        gcViewController.leaderboardIdentifier = ScoreUtil.LEADER_BOARD_ID
        present(gcViewController, animated: true, completion: nil)
    }
}

extension GameViewController: GADBannerViewDelegate {
    
    func setupAdsBanner() {
        vBanner.adUnitID = Common.adsUnitID
        vBanner.delegate = self
        vBanner.rootViewController = self
    }
    
    func requestAds() {
        let request = GADRequest()
        request.testDevices = ["1e7e9704b0581cf4ba07be0e5543463e"]
        vBanner.load(request)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        vBanner.isHidden = false
    }
    
}

extension GameViewController: AdsDelegate {
    
    func show() {
        requestAds()
    }
    
    func hide() {
        vBanner.isHidden = true
    }
    
}

extension GameViewController: IAPDelegate {
    
    func purchased() {
        AdsManager.disableAds()
        vBanner.isHidden = true
    }
    
}
