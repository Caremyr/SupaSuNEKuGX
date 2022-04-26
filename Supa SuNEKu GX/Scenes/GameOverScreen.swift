//
//  GameOverScreen.swift
//  Supa SuNEKu GX
//
//  Created by Salvatore Manna on 31/03/22.
//

import UIKit
import SpriteKit


class GameOverScreen: SKScene {

    
    let gameOverBackground = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width + 2, height: UIScreen.main.bounds.size.height + 2))
    
    let replayButton = SKSpriteNode(imageNamed: "ReplayButton")

    var gameOverMessage1 = SKLabelNode(text: "")
    var gameOverMessage2 = SKLabelNode(text: "")
    
    var mainMenuLabel = SKLabelNode(text: "Main Menu")
    var mainMenuLabelShadow = SKLabelNode(text: "Main Menu")
    
    
    override func didMove(to view: SKView) {
//        backgroundColor = .black
        scoreLabel.fontName = "Grand9K Pixel"
        
        gameOverBackground.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        gameOverBackground.fillColor = .systemGray2
        gameOverBackground.strokeColor = .systemGray2
        gameOverBackground.fillTexture = SKTexture(imageNamed: "Background2")
        addChild(gameOverBackground)
        
        presentGameOverType()
        
//        replayButton.fillColor = .white
        replayButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        replayButton.name = "Restart"
        replayButton.size.width = size.width*0.4
        replayButton.size.height = size.width*0.4
        self.addChild(replayButton)
        
        self.addChild(scoreLabel)
        scoreLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        
        mainMenuLabel.position = CGPoint(x: size.width*0.5, y: size.height*0.17)
        mainMenuLabel.zPosition = 5
        mainMenuLabel.name = "MainMenu"
        mainMenuLabel.fontSize = size.width*0.1
        mainMenuLabel.fontColor = playLabelColor
        mainMenuLabel.fontName = "Grand9K Pixel"
        addChild(mainMenuLabel)
        
        mainMenuLabelShadow.position = mainMenuLabel.position
        mainMenuLabelShadow.position.x -= mainMenuLabel.fontSize*0.1
        mainMenuLabelShadow.position.y -= mainMenuLabel.fontSize*0.1
        mainMenuLabelShadow.zPosition = 4
        mainMenuLabelShadow.name = "MainMenu"
        mainMenuLabelShadow.fontSize = size.width*0.1
        mainMenuLabelShadow.fontColor = playLabelShadowColor
        mainMenuLabelShadow.fontName = "Grand9K Pixel"
        addChild(mainMenuLabelShadow)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
        if(touchedNode.name == "Restart"){
            print("Ricomincia")
            print("\(snakeBody.count)")
            snakeBody.removeAll()
            print("\(snakeBody.count)")
            
            removeAllChildren()
            
            let scene = GameScene(size: size)
            view?.presentScene(scene, transition: .fade(withDuration: 1))
        }
        
        if(touchedNode.name == "MainMenu"){
            let scene = MainMenu(size: size)
            view?.presentScene(scene, transition: .fade(withDuration: 1))
        }
    }
    
    func presentGameOverType(){
        gameOverMessage1.fontSize = size.width*0.05
        gameOverMessage1.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.86)
        gameOverMessage1.fontName = "Grand9k Pixel"
        
        gameOverMessage2.fontSize = size.width*0.05
        gameOverMessage2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.8)
        gameOverMessage2.fontName = "Grand9k Pixel"
        
        switch gameOverType{
        case "TimesUp":
            print("GameOverTimesUp")
            gameOverMessage1.text = "Time's Up!"
            gameOverMessage2.text = "Let's see how you did"
            addChild(gameOverMessage2)
            addChild(gameOverMessage1)
        case "SnakeBody+Wall":
            print("GameOverSnakeBody+Wall")
            gameOverMessage1.text = "You got your body stuck in a wall..."
            gameOverMessage2.text = "...be careful next time"
            addChild(gameOverMessage2)
            addChild(gameOverMessage1)
        case "SnakeHead+SnakeBody":
            print("GameOverSnakeHead+SnakeBody")
            gameOverMessage1.text = "You tried to eat yourself ._."
            gameOverMessage2.text = "What the actual fuck!?"
            addChild(gameOverMessage2)
            addChild(gameOverMessage1)
        case "SnakeHead+Wall":
            print("GameOverSnakeHead+Wall")
            gameOverMessage1.text = "You bumped your head in a wall..."
            gameOverMessage2.text = "...you better be careful"
            addChild(gameOverMessage2)
            addChild(gameOverMessage1)
        default:
            return
        }
    }
    
}
