//
//  HowToPlayFirstTime.swift
//  Supa SuNEKu GX
//
//  Created by Salvatore Manna on 12/04/22.
//

import UIKit
import SpriteKit
import SwiftUI

class HowToPlayFirstTime: SKScene {
    
    @AppStorage("firstTimePlaying") var firstTimePlaying: Bool = false
    
    let howToPlayLabel = SKLabelNode(text: "HOW TO PLAY")
    let generalHowToPlayGlobal = SKLabelNode(text: "This is a revisited version of the classic Snake.\nTo move, swipe in the direciton you want to move.\nThe longer you take to collect a cube, the less points you will get.\nEach cube will grant you an effect.\nThe currently active effect are displayed on top.\nOn the bottom you can see what the last pickup's effect was.")

    let powerUpsLabel: SKLabelNode = SKLabelNode(text: "POWER-UPS")
    let invertXPowerUp: SKSpriteNode = SKSpriteNode(imageNamed: "InvertXPowerUp")
    let invertYPowerUp: SKSpriteNode = SKSpriteNode(imageNamed: "InvertYPowerUp")
    let invertXYPowerUp: SKSpriteNode = SKSpriteNode(imageNamed: "InvertXYPowerUp")
    let speedUpPowerUp: SKSpriteNode = SKSpriteNode(imageNamed: "SpeedUpPowerUp")
    let cornerWallPowerUp: SKSpriteNode = SKSpriteNode(imageNamed: "CornerWallPowerUp")
    let fullWallPowerUp: SKSpriteNode = SKSpriteNode(imageNamed: "WallPowerUp")
    let noWallPowerUp: SKSpriteNode = SKSpriteNode(imageNamed: "NoWallPowerUp")
    
    let invertXPowerUpDescription: SKLabelNode = SKLabelNode(text: "This power-up will invert the horizontal movement.")
    let invertYPowerUpDescription: SKLabelNode = SKLabelNode(text: "This power-up will invert the vertical movement.")
    let invertXYPowerUpDescription: SKLabelNode = SKLabelNode(text: "This power-up will invert the horizontal and vertical movement.")
    let speedUpPowerUpDescription: SKLabelNode = SKLabelNode(text: "This power-up will increase the movement speed for 5 seconds.")
    let cornerWallPowerUpDescription: SKLabelNode = SKLabelNode(text: "This power-up will create walls in the four corners of the playable area.")
    let fullWallPowerUpDescription: SKLabelNode = SKLabelNode(text: "This power-up will create walls all around the playable area.")
    let nowWallPowerUpDescription: SKLabelNode = SKLabelNode(text: "This power-up will remove the walls.")
    
    
    var mainMenuLabel = SKLabelNode(text: "Play")
    var mainMenuLabelShadow = SKLabelNode(text: "Play")
    
    let nextPageSquare: SKShapeNode
    let nextPageLabel: SKLabelNode = SKLabelNode(text: "Power-Ups")
    let nextPageLabelShadow: SKLabelNode = SKLabelNode(text: "Power-Ups")
    
    let previousPageLabel: SKLabelNode = SKLabelNode(text: "How to play")
    let previousPageLabelShadow: SKLabelNode = SKLabelNode(text: "How to play")
    
    override init(size: CGSize) {
        nextPageSquare = SKShapeNode(rectOf: CGSize(width: size.width*0.4, height: size.height*0.05))
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        nextPageLabel.fontName = "Grand9K Pixel"
        nextPageLabel.fontSize = size.height*0.02
        nextPageLabel.fontColor = playLabelColor
        nextPageLabel.position = CGPoint(x: size.width*0.75, y: size.height*0.2)
        nextPageLabel.zPosition = 11
        nextPageLabel.name = "NextPage"
        addChild(nextPageLabel)
        nextPageLabelShadow.fontName = "Grand9K Pixel"
        nextPageLabelShadow.fontSize = size.height*0.02
        nextPageLabelShadow.fontColor = playLabelShadowColor
        nextPageLabelShadow.position = nextPageLabel.position
        nextPageLabelShadow.position.x -= nextPageLabel.fontSize*0.1
        nextPageLabelShadow.position.y -= nextPageLabel.fontSize*0.1
        nextPageLabelShadow.zPosition = 10
        nextPageLabelShadow.name = "NextPage"
        addChild(nextPageLabelShadow)
        
        previousPageLabel.fontName = "Grand9K Pixel"
        previousPageLabel.fontSize = size.height*0.02
        previousPageLabel.fontColor = playLabelColor
        previousPageLabel.position = CGPoint(x: size.width*0.2, y: size.height*0.2)
        previousPageLabel.zPosition = 11
        previousPageLabel.name = "PreviousPage"
        previousPageLabelShadow.fontName = "Grand9K Pixel"
        previousPageLabelShadow.fontSize = size.height*0.02
        previousPageLabelShadow.fontColor = playLabelShadowColor
        previousPageLabelShadow.position = previousPageLabel.position
        previousPageLabelShadow.position.x -= previousPageLabel.fontSize*0.1
        previousPageLabelShadow.position.y -= previousPageLabel.fontSize*0.1
        previousPageLabelShadow.zPosition = 10
        previousPageLabelShadow.name = "PreviousPage"
        
        generalHowToPlayGlobal.preferredMaxLayoutWidth = size.width*0.9
        generalHowToPlayGlobal.numberOfLines = 0
        generalHowToPlayGlobal.verticalAlignmentMode = SKLabelVerticalAlignmentMode.baseline
        generalHowToPlayGlobal.position = CGPoint(x: size.width*0.52, y: size.height*0.25)
        generalHowToPlayGlobal.fontName = "Grand9K Pixel"
        if(UIDevice.modelName.contains("iPhone 8")){
            generalHowToPlayGlobal.fontSize = size.width*0.053
        } else {
            generalHowToPlayGlobal.fontSize = size.width*0.06
        }
        addChild(generalHowToPlayGlobal)
        
        howToPlayLabel.fontName = "Grand9K Pixel"
        howToPlayLabel.fontSize = size.width*0.06
        howToPlayLabel.position = CGPoint(x: size.width*0.29, y: size.height*0.9)
        addChild(howToPlayLabel)
        
        mainMenuLabel.position = CGPoint(x: size.width*0.5, y: size.height*0.1)
        mainMenuLabel.zPosition = 5
        mainMenuLabel.name = "Play"
        mainMenuLabel.fontSize = size.width*0.1
        mainMenuLabel.fontColor = playLabelColor
        mainMenuLabel.fontName = "Grand9K Pixel"
        addChild(mainMenuLabel)
        
        mainMenuLabelShadow.position = mainMenuLabel.position
        mainMenuLabelShadow.position.x -= mainMenuLabel.fontSize*0.1
        mainMenuLabelShadow.position.y -= mainMenuLabel.fontSize*0.1
        mainMenuLabelShadow.zPosition = 4
        mainMenuLabelShadow.name = "Play"
        mainMenuLabelShadow.fontSize = size.width*0.1
        mainMenuLabelShadow.fontColor = playLabelShadowColor
        mainMenuLabelShadow.fontName = "Grand9K Pixel"
        addChild(mainMenuLabelShadow)
        
        
        powerUpsLabel.fontName = "Grand9K Pixel"
        powerUpsLabel.fontSize = size.width*0.06
        powerUpsLabel.position = CGPoint(x: size.width*0.29, y: size.height*0.9)
        
        invertXPowerUp.position = CGPoint(x: size.width*0.15, y: size.height*0.83)
        invertXPowerUp.size.width = size.width*0.1
        invertXPowerUp.size.height = size.width*0.1
        invertXPowerUpDescription.fontName = "Grand9K Pixel"
        invertXPowerUpDescription.fontSize = size.width*0.04
        invertXPowerUpDescription.position = CGPoint(x: size.width*0.54, y: size.height*0.83 - invertXPowerUpDescription.fontSize*1.5)
        invertXPowerUpDescription.preferredMaxLayoutWidth = size.width*0.7
        invertXPowerUpDescription.numberOfLines = 0
        invertXPowerUpDescription.verticalAlignmentMode = SKLabelVerticalAlignmentMode.baseline
        
        invertYPowerUp.position = CGPoint(x: size.width*0.15, y: size.height*0.75)
        invertYPowerUp.size.width = size.width*0.1
        invertYPowerUp.size.height = size.width*0.1
        invertYPowerUpDescription.fontName = "Grand9K Pixel"
        invertYPowerUpDescription.fontSize = size.width*0.04
        invertYPowerUpDescription.position = CGPoint(x: size.width*0.54, y: size.height*0.75 - invertXPowerUpDescription.fontSize*1.5)
        invertYPowerUpDescription.preferredMaxLayoutWidth = size.width*0.7
        invertYPowerUpDescription.numberOfLines = 0
        invertYPowerUpDescription.verticalAlignmentMode = SKLabelVerticalAlignmentMode.baseline
        
        invertXYPowerUp.position = CGPoint(x: size.width*0.15, y: size.height*0.67)
        invertXYPowerUp.size.width = size.width*0.1
        invertXYPowerUp.size.height = size.width*0.1
        invertXYPowerUpDescription.fontName = "Grand9K Pixel"
        invertXYPowerUpDescription.fontSize = size.width*0.04
        invertXYPowerUpDescription.position = CGPoint(x: size.width*0.54, y: size.height*0.67 - invertXYPowerUpDescription.fontSize*2.5)
        invertXYPowerUpDescription.preferredMaxLayoutWidth = size.width*0.7
        invertXYPowerUpDescription.numberOfLines = 0
        invertXYPowerUpDescription.verticalAlignmentMode = SKLabelVerticalAlignmentMode.baseline
        
        speedUpPowerUp.position = CGPoint(x: size.width*0.15, y: size.height*0.58)
        speedUpPowerUp.size.width = size.width*0.1
        speedUpPowerUp.size.height = size.width*0.1
        speedUpPowerUpDescription.fontName = "Grand9K Pixel"
        speedUpPowerUpDescription.fontSize = size.width*0.04
        speedUpPowerUpDescription.position = CGPoint(x: size.width*0.56, y: size.height*0.58 - speedUpPowerUpDescription.fontSize*1.5)
        speedUpPowerUpDescription.preferredMaxLayoutWidth = size.width*0.7
        speedUpPowerUpDescription.numberOfLines = 0
        speedUpPowerUpDescription.verticalAlignmentMode = SKLabelVerticalAlignmentMode.baseline
        
        fullWallPowerUp.position = CGPoint(x: size.width*0.15, y: size.height*0.51)
        fullWallPowerUp.size.width = size.width*0.1
        fullWallPowerUp.size.height = size.width*0.1
        fullWallPowerUpDescription.fontName = "Grand9K Pixel"
        fullWallPowerUpDescription.fontSize = size.width*0.04
        fullWallPowerUpDescription.position = CGPoint(x: size.width*0.58, y: size.height*0.51 - fullWallPowerUpDescription.fontSize*1.5)
        fullWallPowerUpDescription.preferredMaxLayoutWidth = size.width*0.7
        fullWallPowerUpDescription.numberOfLines = 0
        fullWallPowerUpDescription.verticalAlignmentMode = SKLabelVerticalAlignmentMode.baseline
        
        cornerWallPowerUp.position = CGPoint(x: size.width*0.15, y: size.height*0.42)
        cornerWallPowerUp.size.width = size.width*0.1
        cornerWallPowerUp.size.height = size.width*0.1
        cornerWallPowerUpDescription.fontName = "Grand9K Pixel"
        cornerWallPowerUpDescription.fontSize = size.width*0.04
        cornerWallPowerUpDescription.position = CGPoint(x: size.width*0.58, y: size.height*0.42 - cornerWallPowerUpDescription.fontSize*2.5)
        cornerWallPowerUpDescription.preferredMaxLayoutWidth = size.width*0.7
        cornerWallPowerUpDescription.numberOfLines = 0
        cornerWallPowerUpDescription.verticalAlignmentMode = SKLabelVerticalAlignmentMode.baseline
        
        noWallPowerUp.position = CGPoint(x: size.width*0.15, y: size.height*0.33)
        noWallPowerUp.size.width = size.width*0.1
        noWallPowerUp.size.height = size.width*0.1
        nowWallPowerUpDescription.fontName = "Grand9K Pixel"
        nowWallPowerUpDescription.fontSize = size.width*0.04
        nowWallPowerUpDescription.position = CGPoint(x: size.width*0.55, y: size.height*0.33 - nowWallPowerUpDescription.fontSize*1.5)
        nowWallPowerUpDescription.preferredMaxLayoutWidth = size.width*0.7
        nowWallPowerUpDescription.numberOfLines = 0
        nowWallPowerUpDescription.verticalAlignmentMode = SKLabelVerticalAlignmentMode.baseline
        
        if(UIDevice.modelName.contains("iPad")){
            howToPlayLabel.removeFromParent()
            generalHowToPlayGlobal.fontSize = size.width*0.053
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
        if(touchedNode.name == "Play"){
            
            firstTimePlaying = true
            
            let scene = GameScene(size: size)
            view?.presentScene(scene, transition: .fade(withDuration: 1))
        }
        if(touchedNode.name == "NextPage"){
            howToPlayLabel.removeFromParent()
            generalHowToPlayGlobal.removeFromParent()
            nextPageLabel.removeFromParent()
            nextPageLabelShadow.removeFromParent()
            addChild(previousPageLabel)
            addChild(previousPageLabelShadow)
            addChild(powerUpsLabel)
            
            addChild(invertXPowerUp)
            addChild(invertXPowerUpDescription)
            addChild(invertYPowerUp)
            addChild(invertYPowerUpDescription)
            addChild(invertXYPowerUp)
            addChild(invertXYPowerUpDescription)
            addChild(speedUpPowerUp)
            addChild(speedUpPowerUpDescription)
            addChild(fullWallPowerUp)
            addChild(fullWallPowerUpDescription)
            addChild(cornerWallPowerUp)
            addChild(cornerWallPowerUpDescription)
            addChild(noWallPowerUp)
            addChild(nowWallPowerUpDescription)
        }
        if(touchedNode.name == "PreviousPage"){
            powerUpsLabel.removeFromParent()
            previousPageLabel.removeFromParent()
            previousPageLabelShadow.removeFromParent()
            
            invertXPowerUp.removeFromParent()
            invertXPowerUpDescription.removeFromParent()
            invertYPowerUp.removeFromParent()
            invertYPowerUpDescription.removeFromParent()
            invertXYPowerUp.removeFromParent()
            invertXYPowerUpDescription.removeFromParent()
            speedUpPowerUp.removeFromParent()
            speedUpPowerUpDescription.removeFromParent()
            fullWallPowerUp.removeFromParent()
            fullWallPowerUpDescription.removeFromParent()
            cornerWallPowerUp.removeFromParent()
            cornerWallPowerUpDescription.removeFromParent()
            noWallPowerUp.removeFromParent()
            nowWallPowerUpDescription.removeFromParent()
            
            addChild(nextPageLabel)
            addChild(nextPageLabelShadow)
            addChild(generalHowToPlayGlobal)
            addChild(howToPlayLabel)
            if(UIDevice.modelName.contains("iPad")){
                howToPlayLabel.removeFromParent()
            }
        }
        
    }

}
