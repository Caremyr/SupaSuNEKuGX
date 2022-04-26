//
//  SplashScreen.swift
//  Supa SuNEKu GX
//
//  Created by Salvatore Manna on 31/03/22.
//

import UIKit
import SpriteKit
import SwiftUI


class SplashScreen: SKScene {

    @AppStorage("volume") var volume: Bool = true
    
    var teamLogo = SKSpriteNode(imageNamed: "TeamLogo")
    
    let gamesLabel = SKLabelNode(text: "Games")
    
    
    var myMammtAudio = SKAudioNode(fileNamed: "MammtSound")
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        
        teamLogo.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        teamLogo.alpha = 0
        teamLogo.size.width = size.width*0.3
        teamLogo.size.height = size.width*0.4
        addChild(teamLogo)
        
//        gamesLabel.fontSize = size.width*0.065
//        gamesLabel.zPosition = 20
//        gamesLabel.fontColor = .white
//        gamesLabel.position = CGPoint(x: size.width*1.5, y: size.height*0.5 - teamLogo.size.height*0.7)
//        addChild(gamesLabel)
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+(0.7), execute: {
//            self.gamesLabel.run(.moveTo(x: self.size.width*0.65, duration: 0.7))
//        })
        
        
        teamLogo.run(.fadeIn(withDuration: 1.5), completion: {
//            self.addChild(self.myMammtAudio)
//            self.myMammtAudio.run(.play())
            if(self.volume){
                self.teamLogo.run(.playSoundFileNamed("MamtSound", waitForCompletion: false))
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                self.gamesLabel.run(.fadeOut(withDuration: 1.5))
                self.teamLogo.run(.fadeOut(withDuration: 1.5), completion: {
                    let nextScene = MainMenu(size: self.size)
                    self.view?.presentScene(nextScene)
                })
            })
        })
        
    }
    
    
}
