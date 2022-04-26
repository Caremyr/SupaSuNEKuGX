//
//  MainMenu.swift
//  Supa SuNEKu GX
//
//  Created by Salvatore Manna on 31/03/22.
//

import UIKit
import SpriteKit
import SwiftUI



class MainMenu: SKScene {
    
    @AppStorage("volume") var volume: Bool = true
    @AppStorage("highestScore") var highestScore: Int = 0
    @AppStorage("firstTimePlaying") var firstTimePlaying: Bool = false
    
    var playLabel = SKLabelNode(text: "Play")
    var playLabelShadow = SKLabelNode(text: "Play")
    var leftArrow = SKSpriteNode(imageNamed: "LeftArrow")
    var rightArrow = SKSpriteNode(imageNamed: "RightArrow")
    
    let howToPlayLabel = SKLabelNode(text: "How to Play")
    let howToPlayLabelShadow = SKLabelNode(text: "How to Play")
    let leftArrowHowToPlay = SKSpriteNode(imageNamed: "LeftArrow")
    let rightArrowHowToPlay = SKSpriteNode(imageNamed: "RightArrow")
    
    let creditsLabel = SKLabelNode(text: "Credits")
    let creditsLabelShadow = SKLabelNode(text: "Credits")
    let leftArrowCredits = SKSpriteNode(imageNamed: "LeftArrow")
    let rightArrowCredits = SKSpriteNode(imageNamed: "RightArrow")
    
    
    var arcadeWriting = SKLabelNode(text: "ARCADE")
    var arcadeWritingShadow = SKLabelNode(text: "ARCADE")
    
    var pressPlayToStartLabel = SKLabelNode(text: "Press play to start!")
    var pressPLayToStartLabelShadow = SKLabelNode(text: "Press play to start!")
    
    var gameLogo = SKSpriteNode(imageNamed: "Logo")
    
    var centerBackground = SKSpriteNode(imageNamed: "MainMenuBackground")
    
    var background = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
    
    
    var bannerMessage = SKLabelNode(text: "Hello and welcome to Supa SuNEKu GX!")
    var highestScoreMessage = SKLabelNode(text: "")
    
    let banner: SKShapeNode
    let bannerFrame: SKShapeNode
    let leftBannerCover: SKShapeNode
    let rightBannerCover: SKShapeNode
    
    //Elementi dei crediti
    let artAndCodeLabel: SKLabelNode = SKLabelNode(text: "Art & Coding: ")
    let name1Label: SKLabelNode = SKLabelNode(text: "Antonio Romano")
    let andLabel: SKLabelNode = SKLabelNode(text: "&")
    let name2Label: SKLabelNode = SKLabelNode(text: "Salvatore Manna")
    let backLabel: SKLabelNode = SKLabelNode(text: "Back")
    let backLabelShadow: SKLabelNode = SKLabelNode(text: "Back")
    
    //Elementi della scritta arcade in alto
    var arcadeLetters: [SKLabelNode] = [SKLabelNode(text: "A"), SKLabelNode(text: "R"), SKLabelNode(text: "C"), SKLabelNode(text: "A"), SKLabelNode(text: "D"), SKLabelNode(text: "E")]
    var arcadeLettersShadow: [SKLabelNode] = [SKLabelNode(text: "A"), SKLabelNode(text: "R"), SKLabelNode(text: "C"), SKLabelNode(text: "A"), SKLabelNode(text: "D"), SKLabelNode(text: "E")]
    var arcadeIndex: Int = 0
    var fullIlluminationIndex: Int = 0
    
    let soundButton: SKSpriteNode = SKSpriteNode(imageNamed: "SoundNotMuted")
    let infoButton: SKSpriteNode = SKSpriteNode(imageNamed: "InfoButton")

    var transitioning: Bool = false
    
    override init(size: CGSize) {
        
        banner = SKShapeNode(rectOf: CGSize(width: size.width*0.7, height: size.height*0.1))
        bannerFrame = SKShapeNode(rectOf: CGSize(width: size.width*0.7, height: size.height*0.1))
        
        leftBannerCover = SKShapeNode(rectOf: CGSize(width: (size.width - size.width*0.7)*0.5, height: size.height*0.1))
        rightBannerCover = SKShapeNode(rectOf: CGSize(width: (size.width - size.width*0.7)*0.5, height: size.height*0.1))
        
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func didMove(to view: SKView) {
        
        highestScoreMessage.text = "Highest score: \(highestScore)"
        
        backgroundColor = .black
        
        centerBackground.position = CGPoint(x: size.width*0.5, y: size.height*0.52)
        centerBackground.size.width = size.width*0.7
        centerBackground.size.height = size.width*0.7
        centerBackground.zPosition = 5
        addChild(centerBackground)
        
        
        
        arcadeLettersSetup()
        
        playButtonSetup()
        
        howToPlayButtonSetup()
        
        creditsSetUp()
        
        pressPlayToStartLabel.position = centerBackground.position
        pressPlayToStartLabel.position.y -= centerBackground.size.height*0.45
        pressPlayToStartLabel.zPosition = 7
        pressPlayToStartLabel.fontSize = size.width*0.04
        pressPlayToStartLabel.fontColor = playLabelShadowColor
        pressPlayToStartLabel.fontName = "Grand9K Pixel"
        addChild(pressPlayToStartLabel)
//        pressPLayToStartLabelShadow.position = pressPlayToStartLabel.position
//        pressPLayToStartLabelShadow.zPosition = 6
//        pressPLayToStartLabelShadow.fontSize = size.width*0.04
//        pressPLayToStartLabelShadow.fontColor = playLabelShadowColor
//        pressPLayToStartLabelShadow.position.x -= pressPlayToStartLabel.fontSize * 0.1
//        pressPLayToStartLabelShadow.position.y -= pressPlayToStartLabel.fontSize * 0.1
//        pressPLayToStartLabelShadow.fontName = "Grand9K Pixel"
        
        creditsScreenSetup()
        
        gameLogo.position = CGPoint(x: size.width*0.5, y: size.height*0.9)
        gameLogo.size.width = size.width*0.3
        gameLogo.size.height = gameLogo.size.width*1.1
        addChild(gameLogo)
        
        
        soundButton.position = centerBackground.position
        soundButton.position.y -= centerBackground.size.height*0.4
        soundButton.position.x += centerBackground.size.width*0.4
        soundButton.zPosition = 7
        soundButton.size.width = playLabel.fontSize*1.2
        soundButton.size.height = playLabel.fontSize*1.2
        soundButton.name = "SoundButton"
        if(!volume){
            soundButton.run(.setTexture(SKTexture(imageNamed: "SoundMuted")))
        }
        addChild(soundButton)
        
        
        infoButton.position = centerBackground.position
        infoButton.position.y += centerBackground.size.height*0.4
        infoButton.position.x -= centerBackground.size.width*0.4
        infoButton.zPosition = 7
        infoButton.size.width = playLabel.fontSize*1.2
        infoButton.size.height = playLabel.fontSize*1.2
        infoButton.name = "InfoButton"
        
        
    
        bannerFrame.strokeColor = .cyan
        bannerFrame.fillColor = .clear
        bannerFrame.position = CGPoint(x: size.width*0.5, y: size.height*0.2)
        bannerFrame.zPosition = 15
        addChild(bannerFrame)
        banner.strokeColor = .clear
        banner.fillColor = UIColor(red: 138/255, green: 32/255, blue: 80/255, alpha: 1)
        banner.position = CGPoint(x: size.width*0.5, y: size.height*0.2)
        banner.zPosition = 11
        addChild(banner)
        
        leftBannerCover.strokeColor = .clear
        leftBannerCover.fillColor = .black
        leftBannerCover.position = CGPoint(x: size.width*0.5 + (size.width*0.7)*0.5 + ((size.width - size.width*0.7)*0.5)*0.5 , y: size.height*0.2)
        leftBannerCover.zPosition = 14
        addChild(leftBannerCover)
        rightBannerCover.strokeColor = .clear
        rightBannerCover.fillColor = .black
        rightBannerCover.position = CGPoint(x: size.width*0.5 - (size.width*0.7)*0.5 - ((size.width - size.width*0.7)*0.5)*0.5, y: size.height*0.2)
        rightBannerCover.zPosition = 14
        addChild(rightBannerCover)
        
        bannerMessage.zPosition = 13
        bannerMessage.position = CGPoint(x: size.width*0.5, y: size.height*0.2)
        bannerMessage.position.x = size.width*2
        bannerMessage.position.y -= size.width*0.08*0.5
        bannerMessage.fontSize = size.width*0.08
        bannerMessage.fontName = "Grand9K Pixel"
        let myPosition = -size.width*0.1
        print(-size.width*1)
        print((bannerMessage.position.x + (size.width*1))/500)
        bannerMessage.run(.moveTo(x: -size.width*1, duration: (bannerMessage.position.x + (size.width*1))/300), completion: {
//            self.recursiveHelloWriting()
        })
        addChild(bannerMessage)
        highestScoreMessage.zPosition = 13
        highestScoreMessage.position = CGPoint(x: size.width*0.5, y: size.height*0.2)
        highestScoreMessage.position.x = size.width*3.5
        highestScoreMessage.position.y -= size.width*0.08*0.5
        highestScoreMessage.fontSize = size.width*0.08
        highestScoreMessage.fontName = "Grand9K Pixel"
        highestScoreMessage.run(.moveTo(x: -size.width*1, duration: (highestScoreMessage.position.x + (size.width*1))/300), completion: {
            self.recursiveHelloWriting()
        })
        addChild(highestScoreMessage)
        
        
        
        createBottomBorder()
        createLeftBorder()
        createRightBorder()
        createUpperBorder()
        
        DispatchQueue.main.async {
            self.arcadeIllumination()
        }
        
    }
    
    func arcadeIllumination(){
        for index in 0...arcadeLetters.count-1{
            if(index == arcadeIndex){
                arcadeLetters[index].alpha = 1
                arcadeLettersShadow[index].alpha = 1
            } else {
                arcadeLetters[index].alpha = 0.3
                arcadeLettersShadow[index].alpha = 0.3
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
            self.arcadeIndex += 1
            if(self.arcadeIndex == 6){
                self.arcadeIndex = 0
                self.arcadeFullIllumination()
            }else {
                self.arcadeIllumination()
            }
            
        })
    }
    
    func arcadeFullIllumination(){
        if(fullIlluminationIndex == 0){
            for index in 0...arcadeLetters.count-1{
                arcadeLetters[index].alpha = 0.3
                arcadeLettersShadow[index].alpha = 0.3
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
            for index in 0...self.arcadeLetters.count-1{
                self.arcadeLetters[index].alpha = 1
                self.arcadeLettersShadow[index].alpha = 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                for index in 0...self.arcadeLetters.count-1{
                    self.arcadeLetters[index].alpha = 0.3
                    self.arcadeLettersShadow[index].alpha = 0.3
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                    self.fullIlluminationIndex += 1
                    if(self.fullIlluminationIndex == 2){
                        self.fullIlluminationIndex = 0
                        self.arcadeIllumination()
                    }else {
                        self.arcadeFullIllumination()
                    }
                })
            })
        })
        
    }
    
    func recursiveHelloWriting(){
        bannerMessage.position.x = size.width*2
        highestScoreMessage.position.x = size.width*3.5
        
        bannerMessage.run(.moveTo(x: -size.width*1, duration: (bannerMessage.position.x + (size.width*1))/300), completion: {
        })
        highestScoreMessage.run(.moveTo(x: -size.width*1, duration: (highestScoreMessage.position.x + (size.width*1))/300), completion: {
            self.recursiveHelloWriting()
        })
    }
    
    func createBottomBorder(){
        var myBottomPath = UIBezierPath()
        myBottomPath.move(to: CGPoint(x: 0, y: 0))
        myBottomPath.addLine(to: CGPoint(x: size.width*0.1, y: size.width*0.1))
        myBottomPath.addLine(to: CGPoint(x: size.width*0.8, y: size.width*0.1))
        myBottomPath.addLine(to: CGPoint(x: size.width*0.9, y: 0))
        myBottomPath.addLine(to: CGPoint(x: 0, y: 0))
        
        var bottomBorder: SKShapeNode = SKShapeNode(path: myBottomPath.cgPath)
        bottomBorder.position.x = size.width*0.5 - size.width*0.9 / 2
        bottomBorder.position.y = size.height*0.52 - (size.width*0.7 / 2) - size.width*0.1
        
        bottomBorder.fillColor = bottomBorderColor
        bottomBorder.strokeColor = bottomBorderColor
        
        addChild(bottomBorder)
        bottomBorder.zPosition = 10
    }
    
    
    func createLeftBorder(){
        var myLeftPath = UIBezierPath()
        myLeftPath.move(to: CGPoint(x: 0, y: 0))
        myLeftPath.addLine(to: CGPoint(x: size.width*0.1, y: size.width*0.1))
        myLeftPath.addLine(to: CGPoint(x: size.width*0.1, y: size.width*0.8))
        myLeftPath.addLine(to: CGPoint(x: 0, y: size.width*0.81))
        myLeftPath.addLine(to: CGPoint(x: 0, y: 0))
        
        var leftBorder: SKShapeNode = SKShapeNode(path: myLeftPath.cgPath)
        leftBorder.position.x = size.width * 0.5 - size.width*0.7 / 2 - size.width*0.1
        leftBorder.position.y = size.height*0.52 - (size.width*0.7 / 2) - size.width*0.1
        
        leftBorder.fillColor = leftAndRightBorderColor
        leftBorder.strokeColor = leftAndRightBorderColor
        
        addChild(leftBorder)
        leftBorder.zPosition = 10
    }
    
    func createRightBorder(){
        var myRightPath = UIBezierPath()
        myRightPath.move(to: CGPoint(x: 0, y: 0))
        myRightPath.addLine(to: CGPoint(x: size.width*0.1, y: size.width*0.1))
        myRightPath.addLine(to: CGPoint(x: size.width*0.1, y: size.width*0.8))
        myRightPath.addLine(to: CGPoint(x: 0, y: size.width*0.81))
        myRightPath.addLine(to: CGPoint(x: 0, y: 0))
        
        var rightBorder: SKShapeNode = SKShapeNode(path: myRightPath.cgPath)
        rightBorder.position.x = size.width * 0.5 + size.width*0.7 / 2 + size.width*0.1
        rightBorder.position.y = size.height*0.52 - (size.width*0.7 / 2) - size.width*0.1
        
        rightBorder.fillColor = leftAndRightBorderColor
        rightBorder.strokeColor = leftAndRightBorderColor
        rightBorder.xScale = -1
        
        addChild(rightBorder)
        rightBorder.zPosition = 10
    }
    
    func createUpperBorder(){
        var myBottomPath = UIBezierPath()
        myBottomPath.move(to: CGPoint(x: 0, y: 0))
        myBottomPath.addLine(to: CGPoint(x: size.width*0.1, y: size.width*0.01))
        myBottomPath.addLine(to: CGPoint(x: size.width*0.8, y: size.width*0.01))
        myBottomPath.addLine(to: CGPoint(x: size.width*0.9, y: 0))
        myBottomPath.addLine(to: CGPoint(x: 0, y: 0))
        
        var bottomBorder: SKShapeNode = SKShapeNode(path: myBottomPath.cgPath)
        bottomBorder.position.x = size.width*0.5 - size.width*0.9 / 2
        bottomBorder.position.y = size.height*0.52 + (size.width*0.7 / 2) + size.width*0.01
        
        bottomBorder.fillColor = upperBorderColor
        bottomBorder.strokeColor = upperBorderColor
        
        bottomBorder.yScale = -1
        
        addChild(bottomBorder)
        bottomBorder.zPosition = 10
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
        if(touchedNode.name == "Play" && !transitioning){
            transitioning = true
            
            leftArrowHowToPlay.alpha = 0.4
            rightArrowHowToPlay.alpha = 0.4
            howToPlayLabel.alpha = 0.4
            howToPlayLabelShadow.alpha = 0.4
            
            run(.wait(forDuration: 0.2), completion: {
                if(self.firstTimePlaying == false){
                    let scene = HowToPlayFirstTime(size: self.size)
                    self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
                } else {
                    let scene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
                }
            })
        }
        
        if(touchedNode.name == "SoundButton"){
            if(volume){
                volume = false
                soundButton.run(.setTexture(SKTexture(imageNamed: "SoundMuted")))
            } else if(!volume){
                volume = true
                soundButton.run(.setTexture(SKTexture(imageNamed: "SoundNotMuted")))
            }
        }
        
        if(touchedNode.name == "HowToPlay" && !transitioning){
            transitioning = true
            
            leftArrow.alpha = 0.4
            rightArrow.alpha = 0.4
            playLabel.alpha = 0.4
            playLabelShadow.alpha = 0.4
            
            run(.wait(forDuration: 0.2), completion: {
                let scene = HowToPlayScene(size: self.size)
                self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
            })
        }
        
        if(touchedNode.name == "Credits" && !transitioning){
            playLabel.removeFromParent()
            playLabelShadow.removeFromParent()
            pressPlayToStartLabel.removeFromParent()
            leftArrow.removeFromParent()
            rightArrow.removeFromParent()
            soundButton.removeFromParent()
            howToPlayLabel.removeFromParent()
            howToPlayLabelShadow.removeFromParent()
            leftArrowHowToPlay.removeFromParent()
            rightArrowHowToPlay.removeFromParent()
            creditsLabel.removeFromParent()
            creditsLabelShadow.removeFromParent()
            leftArrowCredits.removeFromParent()
            rightArrowCredits.removeFromParent()
            
            
            addChild(backLabel)
            addChild(backLabelShadow)
            
            addChild(artAndCodeLabel)
            addChild(name1Label)
            addChild(andLabel)
            addChild(name2Label)
        }
        
        
        if(touchedNode.name == "Back"){
            addChild(playLabel)
            addChild(playLabelShadow)
            addChild(pressPlayToStartLabel)
            addChild(leftArrow)
            addChild(rightArrow)
            addChild(soundButton)
            addChild(howToPlayLabel)
            addChild(howToPlayLabelShadow)
            addChild(leftArrowHowToPlay)
            addChild(rightArrowHowToPlay)
            addChild(creditsLabel)
            addChild(creditsLabelShadow)
            addChild(leftArrowCredits)
            addChild(rightArrowCredits)
            
            backLabel.removeFromParent()
            backLabelShadow.removeFromParent()
            
            artAndCodeLabel.removeFromParent()
            name1Label.removeFromParent()
            andLabel.removeFromParent()
            name2Label.removeFromParent()
            
        }
        
    }
    
    func arcadeLettersSetup(){
        arcadeLetters[0].position = CGPoint(x: size.width*0.29, y: size.height*0.77)
        arcadeLetters[0].zPosition = 8
        arcadeLetters[0].fontSize = size.width*0.12
        arcadeLetters[0].fontColor = playLabelColor
        arcadeLetters[0].fontName = "Grand9K Pixel"
        addChild(arcadeLetters[0])
        arcadeLettersShadow[0].position = arcadeLetters[0].position
        arcadeLettersShadow[0].position.y -= arcadeLetters[0].fontSize * 0.07
        arcadeLettersShadow[0].position.x -= arcadeLetters[0].fontSize * 0.07
        arcadeLettersShadow[0].zPosition = 6
        arcadeLettersShadow[0].fontSize = size.width*0.12
        arcadeLettersShadow[0].fontColor = playLabelShadowColor
        arcadeLettersShadow[0].fontName = "Grand9K Pixel"
        addChild(arcadeLettersShadow[0])
        arcadeLetters[1].position = CGPoint(x: size.width*0.38, y: size.height*0.77)
        arcadeLetters[1].zPosition = 8
        arcadeLetters[1].fontSize = size.width*0.12
        arcadeLetters[1].fontColor = playLabelColor
        arcadeLetters[1].fontName = "Grand9K Pixel"
        addChild(arcadeLetters[1])
        arcadeLettersShadow[1].position = arcadeLetters[1].position
        arcadeLettersShadow[1].position.y -= arcadeLetters[1].fontSize * 0.07
        arcadeLettersShadow[1].position.x -= arcadeLetters[1].fontSize * 0.07
        arcadeLettersShadow[1].zPosition = 6
        arcadeLettersShadow[1].fontSize = size.width*0.12
        arcadeLettersShadow[1].fontColor = playLabelShadowColor
        arcadeLettersShadow[1].fontName = "Grand9K Pixel"
        addChild(arcadeLettersShadow[1])
        arcadeLetters[2].position = CGPoint(x: size.width*0.46, y: size.height*0.77)
        arcadeLetters[2].zPosition = 8
        arcadeLetters[2].fontSize = size.width*0.12
        arcadeLetters[2].fontColor = playLabelColor
        arcadeLetters[2].fontName = "Grand9K Pixel"
        addChild(arcadeLetters[2])
        arcadeLettersShadow[2].position = arcadeLetters[2].position
        arcadeLettersShadow[2].position.y -= arcadeLetters[2].fontSize * 0.07
        arcadeLettersShadow[2].position.x -= arcadeLetters[2].fontSize * 0.07
        arcadeLettersShadow[2].zPosition = 6
        arcadeLettersShadow[2].fontSize = size.width*0.12
        arcadeLettersShadow[2].fontColor = playLabelShadowColor
        arcadeLettersShadow[2].fontName = "Grand9K Pixel"
        addChild(arcadeLettersShadow[2])
        arcadeLetters[3].position = CGPoint(x: size.width*0.55, y: size.height*0.77)
        arcadeLetters[3].zPosition = 8
        arcadeLetters[3].fontSize = size.width*0.12
        arcadeLetters[3].fontColor = playLabelColor
        arcadeLetters[3].fontName = "Grand9K Pixel"
        addChild(arcadeLetters[3])
        arcadeLettersShadow[3].position = arcadeLetters[3].position
        arcadeLettersShadow[3].position.y -= arcadeLetters[3].fontSize * 0.07
        arcadeLettersShadow[3].position.x -= arcadeLetters[3].fontSize * 0.07
        arcadeLettersShadow[3].zPosition = 6
        arcadeLettersShadow[3].fontSize = size.width*0.12
        arcadeLettersShadow[3].fontColor = playLabelShadowColor
        arcadeLettersShadow[3].fontName = "Grand9K Pixel"
        addChild(arcadeLettersShadow[3])
        arcadeLetters[4].position = CGPoint(x: size.width*0.64, y: size.height*0.77)
        arcadeLetters[4].zPosition = 8
        arcadeLetters[4].fontSize = size.width*0.12
        arcadeLetters[4].fontColor = playLabelColor
        arcadeLetters[4].fontName = "Grand9K Pixel"
        addChild(arcadeLetters[4])
        arcadeLettersShadow[4].position = arcadeLetters[4].position
        arcadeLettersShadow[4].position.y -= arcadeLetters[4].fontSize * 0.07
        arcadeLettersShadow[4].position.x -= arcadeLetters[4].fontSize * 0.07
        arcadeLettersShadow[4].zPosition = 6
        arcadeLettersShadow[4].fontSize = size.width*0.12
        arcadeLettersShadow[4].fontColor = playLabelShadowColor
        arcadeLettersShadow[4].fontName = "Grand9K Pixel"
        addChild(arcadeLettersShadow[4])
        arcadeLetters[5].position = CGPoint(x: size.width*0.72, y: size.height*0.77)
        arcadeLetters[5].zPosition = 8
        arcadeLetters[5].fontSize = size.width*0.12
        arcadeLetters[5].fontColor = playLabelColor
        arcadeLetters[5].fontName = "Grand9K Pixel"
        addChild(arcadeLetters[5])
        arcadeLettersShadow[5].position = arcadeLetters[5].position
        arcadeLettersShadow[5].position.y -= arcadeLetters[5].fontSize * 0.07
        arcadeLettersShadow[5].position.x -= arcadeLetters[5].fontSize * 0.07
        arcadeLettersShadow[5].zPosition = 6
        arcadeLettersShadow[5].fontSize = size.width*0.12
        arcadeLettersShadow[5].fontColor = playLabelShadowColor
        arcadeLettersShadow[5].fontName = "Grand9K Pixel"
        addChild(arcadeLettersShadow[5])
    }
    
    func playButtonSetup(){
        leftArrow.position.y = size.height*0.62 + size.width*0.1/2
        leftArrow.zPosition = 7
        leftArrow.position.x = size.width*0.3
        leftArrow.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        leftArrow.size.width = size.width*0.1
        leftArrow.size.height = size.width*0.1
        rightArrow.zPosition = 7
        addChild(leftArrow)
        rightArrow.position = CGPoint(x: size.width*0.5, y: size.height*0.62 + size.width*0.1/2)
        rightArrow.zPosition = 7
        rightArrow.position.x = size.width*0.7
        rightArrow.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        rightArrow.size.width = size.width*0.1
        rightArrow.size.height = size.width*0.1
        addChild(rightArrow)
        playLabel.name = "Play"
        playLabel.fontColor = playLabelColor
        playLabel.fontName = "Grand9K Pixel"
        playLabel.fontSize = size.width*0.1
        playLabel.position = CGPoint(x: size.width*0.5, y: size.height*0.62)
        playLabel.zPosition = 7
        addChild(playLabel)
        playLabelShadow.name = "PlayShadow"
        playLabelShadow.fontColor = playLabelShadowColor
        playLabelShadow.fontName = "Grand9K Pixel"
        playLabelShadow.fontSize = size.width*0.1
        playLabelShadow.position = playLabel.position
        playLabelShadow.position.x -= playLabel.fontSize * 0.1
        playLabelShadow.position.y -= playLabel.fontSize * 0.1
        playLabelShadow.zPosition = 6
        addChild(playLabelShadow)
        rightArrow.run(.repeatForever(.sequence([.moveBy(x: 3, y: 0, duration: 0.5), .moveBy(x: -3, y: 0, duration: 0.5)])))
        leftArrow.run(.repeatForever(.sequence([.moveBy(x: -3, y: 0, duration: 0.5), .moveBy(x: 3, y: 0, duration: 0.5)])))
    }
    
    func howToPlayButtonSetup(){
        leftArrowHowToPlay.position.x = size.width*0.27
        leftArrowHowToPlay.position.y = size.height*0.55 + size.width*0.06/2
        leftArrowHowToPlay.zPosition = 7
        leftArrowHowToPlay.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        leftArrowHowToPlay.size.width = size.width*0.06
        leftArrowHowToPlay.size.height = size.width*0.06
        leftArrowHowToPlay.zPosition = 7
        addChild(leftArrowHowToPlay)
        rightArrowHowToPlay.position = CGPoint(x: size.width*0.5, y: size.height*0.55 + size.width*0.06/2)
        rightArrowHowToPlay.zPosition = 7
        rightArrowHowToPlay.position.x = size.width*0.73
        rightArrowHowToPlay.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        rightArrowHowToPlay.size.width = size.width*0.06
        rightArrowHowToPlay.size.height = size.width*0.06
        addChild(rightArrowHowToPlay)
        howToPlayLabel.name = "HowToPlay"
        howToPlayLabel.fontColor = playLabelColor
        howToPlayLabel.fontName = "Grand9K Pixel"
        howToPlayLabel.fontSize = size.width*0.06
        howToPlayLabel.position = CGPoint(x: size.width*0.5, y: size.height*0.55)
        howToPlayLabel.zPosition = 7
        addChild(howToPlayLabel)
        howToPlayLabelShadow.name = "HowToPlay"
        howToPlayLabelShadow.fontColor = playLabelShadowColor
        howToPlayLabelShadow.fontName = "Grand9K Pixel"
        howToPlayLabelShadow.fontSize = size.width*0.06
        howToPlayLabelShadow.position = howToPlayLabel.position
        howToPlayLabelShadow.position.x -= howToPlayLabel.fontSize * 0.1
        howToPlayLabelShadow.position.y -= howToPlayLabel.fontSize * 0.1
        howToPlayLabelShadow.zPosition = 6
        addChild(howToPlayLabelShadow)
        rightArrowHowToPlay.run(.repeatForever(.sequence([.moveBy(x: 3, y: 0, duration: 0.5), .moveBy(x: -3, y: 0, duration: 0.5)])))
        leftArrowHowToPlay.run(.repeatForever(.sequence([.moveBy(x: -3, y: 0, duration: 0.5), .moveBy(x: 3, y: 0, duration: 0.5)])))
    }
    
    func creditsSetUp(){
        leftArrowCredits.position.x = size.width*0.33
        leftArrowCredits.position.y = size.height*0.5 + size.width*0.06/2
        leftArrowCredits.zPosition = 7
        leftArrowCredits.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        leftArrowCredits.size.width = size.width*0.06
        leftArrowCredits.size.height = size.width*0.06
        leftArrowCredits.zPosition = 7
        addChild(leftArrowCredits)
        rightArrowCredits.position = CGPoint(x: size.width*0.5, y: size.height*0.5 + size.width*0.06/2)
        rightArrowCredits.zPosition = 7
        rightArrowCredits.position.x = size.width*0.67
        rightArrowCredits.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        rightArrowCredits.size.width = size.width*0.06
        rightArrowCredits.size.height = size.width*0.06
        addChild(rightArrowCredits)
        creditsLabel.name = "Credits"
        creditsLabel.fontColor = playLabelColor
        creditsLabel.fontName = "Grand9K Pixel"
        creditsLabel.fontSize = size.width*0.06
        creditsLabel.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        creditsLabel.zPosition = 7
        addChild(creditsLabel)
        creditsLabelShadow.name = "Credits"
        creditsLabelShadow.fontColor = playLabelShadowColor
        creditsLabelShadow.fontName = "Grand9K Pixel"
        creditsLabelShadow.fontSize = size.width*0.06
        creditsLabelShadow.position = creditsLabel.position
        creditsLabelShadow.position.x -= creditsLabel.fontSize * 0.1
        creditsLabelShadow.position.y -= creditsLabel.fontSize * 0.1
        creditsLabelShadow.zPosition = 6
        addChild(creditsLabelShadow)
        rightArrowCredits.run(.repeatForever(.sequence([.moveBy(x: 3, y: 0, duration: 0.5), .moveBy(x: -3, y: 0, duration: 0.5)])))
        leftArrowCredits.run(.repeatForever(.sequence([.moveBy(x: -3, y: 0, duration: 0.5), .moveBy(x: 3, y: 0, duration: 0.5)])))
    }
    
    func creditsScreenSetup(){
        backLabel.position = centerBackground.position
        backLabel.position.y -= centerBackground.size.height*0.45
        backLabel.fontSize = size.width*0.08
        backLabel.fontName = "Grand9K Pixel"
        backLabel.fontColor = playLabelColor
        backLabel.zPosition = 10
        backLabel.name = "Back"
        
        backLabelShadow.position = pressPlayToStartLabel.position
        backLabelShadow.position.x -= backLabel.fontSize * 0.1
        backLabelShadow.position.y -= backLabel.fontSize * 0.1
        backLabelShadow.fontSize = backLabel.fontSize
        backLabelShadow.fontName = "Grand9K Pixel"
        backLabelShadow.fontColor = playLabelShadowColor
        backLabelShadow.zPosition = 9
        backLabelShadow.name = "Back"
        
        artAndCodeLabel.position = centerBackground.position
        artAndCodeLabel.position.x -= centerBackground.size.width*0.25
        artAndCodeLabel.position.y += centerBackground.size.height*0.25
        artAndCodeLabel.fontSize = size.width*0.038
        artAndCodeLabel.fontName = "Grand9K Pixel"
        artAndCodeLabel.fontColor = playLabelColor
        artAndCodeLabel.zPosition = 10
        artAndCodeLabel.name = "Back"
        
        name1Label.position = centerBackground.position
        name1Label.position.x += centerBackground.size.width*0.22
        name1Label.position.y += centerBackground.size.height*0.32
        name1Label.fontSize = size.width*0.038
        name1Label.fontName = "Grand9K Pixel"
        name1Label.fontColor = playLabelColor
        name1Label.zPosition = 10
        name1Label.name = "Back"
        
        andLabel.position = centerBackground.position
        andLabel.position.x += centerBackground.size.width*0.22
        andLabel.position.y += centerBackground.size.height*0.25
        andLabel.fontSize = size.width*0.038
        andLabel.fontName = "Grand9K Pixel"
        andLabel.fontColor = playLabelColor
        andLabel.zPosition = 10
        andLabel.name = "Back"
        
        name2Label.position = centerBackground.position
        name2Label.position.x += centerBackground.size.width*0.22
        name2Label.position.y += centerBackground.size.height*0.18
        name2Label.fontSize = size.width*0.038
        name2Label.fontName = "Grand9K Pixel"
        name2Label.fontColor = playLabelColor
        name2Label.zPosition = 10
        name2Label.name = "Back"
        
    }
}
