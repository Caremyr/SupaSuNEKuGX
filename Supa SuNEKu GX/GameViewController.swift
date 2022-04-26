//
//  GameViewController.swift
//  Supa SuNEKu GX
//
//  Created by Salvatore Manna on 30/03/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.bottom
    }
    
    
//    override var prefersHomeIndicatorAutoHidden: Bool {
//        return true
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
//            let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
            let scene = SplashScreen(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
//            let scene = MainMenu(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
//            let scene = GameOverScreen(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
//            let scene = HowToPlayScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))

//            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
//            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
            view.showsPhysics = false
        }
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

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
