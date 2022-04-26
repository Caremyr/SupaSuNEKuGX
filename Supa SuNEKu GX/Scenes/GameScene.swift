//
//  GameScene.swift
//  Supa SuNEKu GX
//
//  Created by Salvatore Manna on 30/03/22.
//

import SpriteKit
import GameplayKit
import SwiftUI

func checkProportions(screenHeight: CGFloat, myRounded: inout CGFloat){
    
    var myDimension = screenHeight - screenHeight*0.8
    
    if(myRounded*32 < myDimension){
        myRounded += 1
        checkProportions(screenHeight: screenHeight, myRounded: &myRounded)
    } else {
        return
    }
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    @AppStorage("volume") var volume: Bool = true
    @AppStorage("highestScore") var highestScore: Int = 0
    
    //Variabili che determinano la parte giocabile dello schermo
    var playableHeight = 704
    var playableWidth = 384
    var numberOfRows: Int
    var numberOfColumns: Int
    var playableBackground: SKShapeNode
        
    //Variabili per vedere quante mura devo mettere in orizzontale e verticale
    var horizontalCornerWalls: Int
    var verticalCornerWalls: Int
    
    //Variabili interenti alla testa del serpente
    var snakeHead: SKShapeNode = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
    var nextDirection: String = ""
    var previousDirection: String = ""
    
    //Variabili per gestire il movimento della testa del serpente
    var xMovement: CGFloat = 0
    var yMovement: CGFloat = 0
    
    //Variabile per vedere se facendo il primo swipe per avviare il gioco
    var firstMove = true
    
    //Variabile che tiene traccia del numbero di collezionabili mesis in gioco per creare nomi univoci
    var collectibleCounter = 0
    
    //Variabile che fa partire il movimento, viene messa a falsa quando parte il movimento della testa poi aspetto che il movimento si propaghi al resto del corpo e dopo aver mosso tutto il corpo la rimetto a vera per far partire il prossimo movimento della testa.
    //La funzione che muove la testa si richiama e controlla questa variabile di continuo asincronamente in modo da non far bloccare tutto
    var snakeHeadMove = false
    
    
    //Elementi per gestire l'HUD e per l'HUD stesso
    var timerCounter = 60
    
    var timerLabel = SKLabelNode(text: "1:00")
    var scoreMultiplierLabel = SKLabelNode(text: "+1000")
    var totalScore = 0
    var myCalculatedScore = 0
    var lastSecond = 60
    //Variabili che mi fanno animare i punti
    var myAnimatedScore = SKLabelNode(text: "0")
    
    var startingLabel = SKLabelNode(text: "Swipe in a direction to Start")
    //Nodi che compongono l'HUD in alto per vedere quali potenziamenti sono attivi
    var xPowerUpReminder: SKSpriteNode = SKSpriteNode(imageNamed: "InvertXPowerUp")
    var xPowerUpReminderCover: SKShapeNode = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
    var yPowerUpReminder: SKSpriteNode = SKSpriteNode(imageNamed: "InvertYPowerUp")
    var yPowerUpReminderCover: SKShapeNode = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
    var speedUpPowerUpReminder: SKSpriteNode = SKSpriteNode(imageNamed: "SpeedUpPowerUp")
    var speedUpPowerUpReminderCover: SKShapeNode = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
    
    var logo = SKSpriteNode(imageNamed: "Logo")
    
    //Casella in basso in cui passano i nomi dei potenziamenti presi
    var bottomBox: SKShapeNode
    var bottomBoxBorder: SKShapeNode
    var rightCover: SKShapeNode
    var powerUpLabel: SKLabelNode = SKLabelNode(text: "")
    let menuButton = SKSpriteNode(imageNamed: "MenuButton")
    
    //Variabili dei powerup
    var invertXPowerUp = false
    var invertYPowerUp = false
    var speedUpCounter = 0
    var checkSpeedUp = false
    var checkWall = false
    var checkCornerWall = false
    
    var wallIndex = 0
    
    //Variabili per animare le mura
    var animateWalls = true
    var rightWall: Bool = false
    var downWall: Bool = false
    var leftWall: Bool = false
    var upperWall: Bool = false
    
    var gameOver: Bool = false
    

    
    var backgroundMusic: SKAudioNode = SKAudioNode(fileNamed: "Jeremy Blake - Powerup!")
    
    override init(size: CGSize) {
        if(UIDevice.modelName.contains("iPhone 8 Plus")){
            print("\(size.width) + \(size.height)")
            playableWidth = 384
            playableHeight = 576
            playableBackground = SKShapeNode(rectOf: CGSize(width: playableWidth+2, height: playableHeight+2))
            
            bottomBox = SKShapeNode(rectOf: CGSize(width: size.width*0.65, height: size.height*0.04))
            bottomBoxBorder = SKShapeNode(rectOf: CGSize(width: size.width*0.65, height: size.height*0.04))
            rightCover = SKShapeNode(rectOf: CGSize(width: (size.width - size.width*0.8)/2, height: size.height*0.04))
        } else {
            //Così aggiusto la griglia in orizzontale su tutti i dispositivi
            if(CGFloat(playableWidth) > UIScreen.main.bounds.size.width){
                let difference = CGFloat(playableWidth) - UIScreen.main.bounds.size.width
                
                let division = difference/32
                
                var myRounded2: CGFloat
                
                if(division < 1){
                    myRounded2 = 1
                } else {
                    myRounded2 = division.rounded()
                    if(myRounded2 > division){
                        myRounded2 -= 1
                    }
                }
                playableWidth = Int(CGFloat(playableWidth) - (myRounded2 * CGFloat(snakeSize)))
            }
            
            //Così aggiusto la griglia in verticale su tutti i dispositivi
            let differenceInHeight = UIScreen.main.bounds.size.height - CGFloat(playableHeight)
            if(CGFloat(playableHeight) > UIScreen.main.bounds.size.height){
                let differenceInHeight2 = CGFloat(playableHeight) - UIScreen.main.bounds.size.height
                
                let divisionInHeight = differenceInHeight2/CGFloat(snakeSize)
                
                var myRounded: CGFloat
                
                if(divisionInHeight < 1){
                    myRounded = 1
                    myRounded += 2
                } else {
                    myRounded = divisionInHeight.rounded()
                    if(myRounded < divisionInHeight){
                        myRounded += 1
                    }
                }
                
                checkProportions(screenHeight: UIScreen.main.bounds.size.height, myRounded: &myRounded)
                
                playableHeight -= Int(myRounded * CGFloat(snakeSize))
                
            } else if (differenceInHeight < 192){
                let divisionInHeight = differenceInHeight / CGFloat(snakeSize)
                
                var myRounded = divisionInHeight.rounded()
                
                if(myRounded < divisionInHeight){
                    myRounded += 1
                }
                
                playableHeight -= Int(myRounded * CGFloat(snakeSize))
            }
            
            playableBackground = SKShapeNode(rectOf: CGSize(width: playableWidth+2, height: playableHeight+2))
                    
            bottomBox = SKShapeNode(rectOf: CGSize(width: size.width*0.65, height: size.height*0.04))
            bottomBoxBorder = SKShapeNode(rectOf: CGSize(width: size.width*0.65, height: size.height*0.04))
            rightCover = SKShapeNode(rectOf: CGSize(width: (size.width - size.width*0.8)/2, height: size.height*0.04))
        }
        
        numberOfRows = Int(playableHeight/snakeSize)
        numberOfColumns = Int(playableWidth/snakeSize)
        
        
        //Controllo se il numero di caselle in orizzontale, cioè se il numero di colonne è pari o dispari, in base al caso calcolo il numero di mura che devo mettere in orizzontale a destra e a sinistra e il buco che devo lasciare in mezzo
        if(numberOfColumns % 2 == 0){
            let oneThird:CGFloat = CGFloat(numberOfColumns / 3)
            let myRounded: Int = Int(oneThird.rounded())
            
            if(myRounded % 2 == 0){
                horizontalCornerWalls = myRounded
            } else {
                if(CGFloat(myRounded) < oneThird){
                    horizontalCornerWalls = myRounded + 1
                } else {
                    horizontalCornerWalls = myRounded - 1
                }
            }
                        
        } else {
            let oneThird: CGFloat = CGFloat(numberOfColumns / 3)
            let myRounded: Int = Int(oneThird.rounded())
            
            if(myRounded % 2 == 0){
                if(CGFloat(myRounded) < oneThird){
                    horizontalCornerWalls = myRounded + 1
                } else {
                    horizontalCornerWalls = myRounded - 1
                }
            } else {
                horizontalCornerWalls = myRounded
            }
        }
        
        //Controllo se il numero di caselle verticali, cioè il numero di righe, è dispari o pari. In base al caso calcolo il numero di caselle che devo mettere sopra e sotto per gli angoli delle mura e quelle che devo lasciare al centro
        if(numberOfRows % 2 == 0){
            let oneThird:CGFloat = CGFloat(numberOfRows / 3)
            let myRounded: Int = Int(oneThird.rounded())
            
            if(myRounded % 2 == 0){
                verticalCornerWalls = myRounded
            } else {
                if(CGFloat(myRounded) < oneThird){
                    verticalCornerWalls = myRounded + 1
                } else {
                    verticalCornerWalls = myRounded - 1
                }
            }
            
        } else {
            let oneThird: CGFloat = CGFloat(numberOfRows / 3)
            let myRounded: Int = Int(oneThird.rounded())
            
            if(myRounded % 2 == 0){
                if(CGFloat(myRounded) < oneThird){
                    verticalCornerWalls = myRounded + 1
                } else {
                    verticalCornerWalls = myRounded - 1
                }
            } else {
                verticalCornerWalls = myRounded
            }
        }
        
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    let deathFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    let feedbackGenerator = UINotificationFeedbackGenerator()
    
    
    override func didMove(to view: SKView) {
        
        snakeBody.removeAll()
        
        gameOverType = "TimesUp"
        
        scoreLabel.text = String(0)
        
        timerLabel.position = CGPoint(x: size.width*0.12, y: size.height*0.92)
        timerLabel.fontSize = size.width*0.08
        addChild(timerLabel)
        
        scoreLabel.position = CGPoint(x: size.width*0.8, y: size.height*0.92)
        scoreLabel.fontName = "Grand9k Pixel"
        scoreLabel.fontSize = size.width*0.08
        addChild(scoreLabel)
    
        scoreMultiplierLabel.position = CGPoint(x: size.width*0.85, y: size.height*0.9)
        scoreMultiplierLabel.fontName = "Grand9K Pixel"
        scoreMultiplierLabel.fontSize = size.width*0.03
        
        myAnimatedScore.position = CGPoint(x: size.width*0.85, y: size.height*0.9)
        myAnimatedScore.fontName = "Grand9K Pixel"
        myAnimatedScore.fontSize = size.width*0.03
        
        startingLabel.position = CGPoint(x: size.width*0.5, y: size.height*0.4)
        startingLabel.color = .white
        startingLabel.fontName = "Grand9k Pixel"
        startingLabel.fontSize = CGFloat(CGFloat(playableWidth) * 0.06)
        addChild(startingLabel)
        
        logo.position = CGPoint(x: size.width*0.5, y: size.height*0.06)
        logo.size.width = size.width*0.135
        logo.size.height = size.width*0.135
        logo.zPosition = 55
        addChild(logo)
        
        powerUpLabel.position = CGPoint(x: size.width*0.5, y: size.height*0.06)
        powerUpLabel.fontSize = size.width*0.05
        powerUpLabel.position.y -= size.width*0.05/2
        powerUpLabel.fontName = "Grand9K Pixel"
        powerUpLabel.zPosition = 53
        powerUpLabel.fontColor = .cyan
        addChild(powerUpLabel)
        
        bottomBox.fillColor = UIColor(red: 138/255, green: 32/255, blue: 80/255, alpha: 1)
        bottomBox.strokeColor = .cyan
        bottomBox.position = CGPoint(x: size.width*0.5, y: size.height*0.06)
        bottomBox.zPosition = 50
        bottomBox.alpha = 0.8
        addChild(bottomBox)
        
        bottomBoxBorder.fillColor = .clear
        bottomBoxBorder.strokeColor = .cyan
        bottomBoxBorder.position = CGPoint(x: size.width*0.5, y: size.height*0.06)
        bottomBoxBorder.zPosition = 57
        bottomBoxBorder.alpha = 0.8
        addChild(bottomBoxBorder)
        
        rightCover.fillColor = .black
        rightCover.strokeColor = .black
        rightCover.position = CGPoint(x: size.width*0.5 + size.width*0.8*0.5 + ((size.width - size.width*0.8)/2)/2, y: size.height*0.06)
        rightCover.zPosition = 54
        rightCover.alpha = 1
        addChild(rightCover)
        
        menuButton.position = bottomBox.position
        menuButton.position.x += size.width*0.4
        menuButton.name = "MainMenu"
        menuButton.zPosition = 100
        menuButton.size.width = powerUpLabel.fontSize*2
        menuButton.size.height = powerUpLabel.fontSize*2
        addChild(menuButton)
        
        yPowerUpReminderCover.position = CGPoint(x: size.width*0.5, y: size.height*0.92 + CGFloat(snakeSize)/2)
        yPowerUpReminderCover.fillColor = .black
        yPowerUpReminderCover.strokeColor = .black
        yPowerUpReminderCover.alpha = 0.7
        yPowerUpReminderCover.zPosition = 51
        addChild(yPowerUpReminderCover)
        
        xPowerUpReminderCover.position = CGPoint(x: size.width*0.5 - CGFloat(snakeSize), y: size.height*0.92 + CGFloat(snakeSize)/2)
        xPowerUpReminderCover.fillColor = .black
        xPowerUpReminderCover.strokeColor = .black
        xPowerUpReminderCover.alpha = 0.7
        xPowerUpReminderCover.zPosition = 51
        addChild(xPowerUpReminderCover)
        
        speedUpPowerUpReminderCover.position = CGPoint(x: size.width*0.5 + CGFloat(snakeSize), y: size.height*0.92 + CGFloat(snakeSize)/2)
        speedUpPowerUpReminderCover.fillColor = .black
        speedUpPowerUpReminderCover.strokeColor = .black
        speedUpPowerUpReminderCover.alpha = 0.7
        speedUpPowerUpReminderCover.zPosition = 51
        addChild(speedUpPowerUpReminderCover)
        
        yPowerUpReminder.position = CGPoint(x: size.width*0.5, y: size.height*0.92)
        yPowerUpReminder.size.width = CGFloat(snakeSize)
        yPowerUpReminder.size.height = CGFloat(snakeSize)
        yPowerUpReminder.zPosition = 50
        yPowerUpReminder.anchorPoint = CGPoint(x: 0.5, y: 0)
        addChild(yPowerUpReminder)
        xPowerUpReminder.position = CGPoint(x: size.width*0.5 - CGFloat(snakeSize), y: size.height*0.92)
        xPowerUpReminder.size.width = CGFloat(snakeSize)
        xPowerUpReminder.size.height = CGFloat(snakeSize)
        xPowerUpReminder.anchorPoint = CGPoint(x: 0.5, y: 0)
        xPowerUpReminder.zPosition = 50
        addChild(xPowerUpReminder)
        speedUpPowerUpReminder.position = CGPoint(x: size.width*0.5 + CGFloat(snakeSize), y: size.height*0.92)
        speedUpPowerUpReminder.size.width = CGFloat(snakeSize)
        speedUpPowerUpReminder.size.height = CGFloat(snakeSize)
        speedUpPowerUpReminder.anchorPoint = CGPoint(x: 0.5, y: 0)
        speedUpPowerUpReminder.zPosition = 50
        addChild(speedUpPowerUpReminder)
        
        
        if(volume){
            addChild(backgroundMusic)
            backgroundMusic.run(.play())
        }
        
        timerLabel.fontName = "Grand9K Pixel"
        
        self.scene?.physicsWorld.contactDelegate = self
        
        addSwipeGestureRecognizers()
        
        backgroundColor = .black
        
        playableBackground.strokeColor = .systemGray3
        playableBackground.fillColor = .systemGray3
        playableBackground.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        playableBackground.fillTexture = SKTexture(imageNamed: "Background1")
        addChild(playableBackground)
        
//        snakeHead.strokeColor = .white
//        snakeHead.fillColor = .white
        snakeHead.fillColor = snakeHeadColor
        snakeHead.strokeColor = snakeHeadColor
        snakeHead.position = CGPoint(x: (size.width*0.5 - CGFloat(playableWidth/2)) + CGFloat(snakeSize/2), y: (size.height*0.5 + CGFloat(playableHeight/2)) - CGFloat(snakeSize/2) )
        snakeHead.position.x += CGFloat(Int(numberOfColumns/2)*snakeSize) + 1
        snakeHead.name = "SnakeHead"
        snakeHead.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: snakeSize, height: snakeSize))
        snakeHead.physicsBody?.affectedByGravity = false
        snakeHead.physicsBody?.restitution = 0
        snakeHead.physicsBody?.isDynamic = true
        snakeHead.physicsBody?.categoryBitMask = PhysicsBitMasks.snakeHeadBitMask
        snakeHead.physicsBody?.contactTestBitMask = PhysicsBitMasks.collectibleBitMask
        snakeHead.physicsBody?.collisionBitMask = PhysicsBitMasks.none
        
        snakeHead.position.y -= CGFloat(Int(numberOfRows/2)*snakeSize)
        addChild(snakeHead)
        
        //Test per calcolare la colonna i-esima in cui si trova la testa del serpente
//        myIndex = ((snakeHead.position.x - size.width/2 + CGFloat(playableWidth/2) - CGFloat(snakeSize) )/CGFloat(snakeSize))
        
        
        for index in 0...numberOfColumns{
            let column: SKShapeNode = SKShapeNode(rectOf: CGSize(width: 1, height: playableHeight))
            
            column.position = CGPoint(x: (size.width*0.5 - CGFloat(playableWidth/2) + 1), y: size.height*0.5)
            column.position.x += CGFloat(index*snakeSize)
            column.fillColor = .cyan
            column.strokeColor = .cyan
            column.alpha = 0.3
            column.name = "Column\(index)"
            addChild(column)
        }
        
        for index in 0...numberOfRows{
            let row: SKShapeNode = SKShapeNode(rectOf: CGSize(width: playableWidth, height: 1))
            
            row.position = CGPoint(x: (size.width*0.5), y: (size.height*0.5 - CGFloat(playableHeight/2)))
            row.position.y += CGFloat(index*snakeSize)
            row.fillColor = .cyan
            row.strokeColor = .cyan
            row.alpha = 0.3
            row.name = "Row\(index)"
            addChild(row)
        }
        
        spawnCollectible()
        
        snakeHeadMovement()
        
    }
    
    func myTimer(){
        run(.wait(forDuration: 1),completion: {
            self.timerCounter -= 1
//            self.speedUpCounter -= 1
            self.myTimer()
            
            let multiplier = self.lastSecond-self.timerCounter
            let holder: Int
            
            if(multiplier >= 10){
                self.scoreMultiplierLabel.text = "+\(String(100))"
            } else {
                self.scoreMultiplierLabel.text = "+\(String(1000 - (multiplier)*100))"
                
            }
            
            if(multiplier > 2){
//                self.powerUpLabel.run(.moveTo(x: 0, duration: 0.5))
            }
            
        })
    }
    
    func spawnCollectible(){
        let myRow: Int = Int.random(in: 1...numberOfRows-2)
        let myColumn: Int = Int.random(in: 1...numberOfColumns-2)
        
        let pick = Int.random(in: 0...6)
        
        var myCollectible: SKSpriteNode = SKSpriteNode(imageNamed: "NoWallPowerUp")
        
        if pick == 0 {
            myCollectible = SKSpriteNode(imageNamed: "InvertXPowerUp")
            myCollectible.name = "Collectible\(collectibleCounter)InvertXPowerUp"
        } else if pick == 1 {
            myCollectible = SKSpriteNode(imageNamed: "InvertYPowerUp")
            myCollectible.name = "Collectible\(collectibleCounter)InvertYPowerUp"
        }else if pick == 2 {
            myCollectible = SKSpriteNode(imageNamed: "SpeedUpPowerUp")
            myCollectible.name = "Collectible\(collectibleCounter)SpeedUpPowerUp"
        }else if pick == 3 {
            myCollectible = SKSpriteNode(imageNamed: "InvertXYPowerUp")
            myCollectible.name = "Collectible\(collectibleCounter)InvertXYPowerUp"
        }else if pick == 4 {
            myCollectible = SKSpriteNode(imageNamed: "WallPowerUp")
            myCollectible.name = "Collectible\(collectibleCounter)FullWallPowerUp"
        }else if pick == 5 {
            myCollectible = SKSpriteNode(imageNamed: "NoWallPowerUp")
            myCollectible.name = "Collectible\(collectibleCounter)NoWallPowerUp"
        }else if pick == 6 {
            myCollectible = SKSpriteNode(imageNamed: "CornerWallPowerUp")
            myCollectible.name = "Collectible\(collectibleCounter)CornerWallPowerUp"
        }
        
        myCollectible.size = CGSize(width: snakeSize, height: snakeSize)
        myCollectible.position = CGPoint(x: (size.width*0.5 - CGFloat(playableWidth/2) + CGFloat(snakeSize/2)), y: (size.height*0.5 + CGFloat(playableHeight/2)) - CGFloat(snakeSize/2))
        myCollectible.position.x += CGFloat(myColumn*snakeSize) + 1
        myCollectible.position.y -= CGFloat(myRow*snakeSize)
        
        myCollectible.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: snakeSize/2, height: snakeSize/2))
        myCollectible.physicsBody?.affectedByGravity = false
        myCollectible.physicsBody?.restitution = 0
        myCollectible.physicsBody?.isDynamic = true
        myCollectible.physicsBody?.categoryBitMask = PhysicsBitMasks.collectibleBitMask
        myCollectible.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask
        myCollectible.physicsBody?.collisionBitMask = PhysicsBitMasks.none
        
        
        if(myCollectible.position == snakeHead.position){
            print("Rerolling...")
            spawnCollectible()
        } else {
            addChild(myCollectible)
            collectibleCounter += 1
            spawnSecondCollectible(firstCollectible: myCollectible)
        }
        
//        lastSecond = timerCounter
    }
    
    
    func spawnSecondCollectible(firstCollectible: SKSpriteNode){
//        let myRow: Int = Int.random(in: 1...numberOfRows-2)
//        let myColumn: Int = Int.random(in: 1...numberOfColumns-2)
        
        let pick = Int.random(in: 0...6)
        
        var myCollectible: SKSpriteNode = SKSpriteNode(imageNamed: "NoWallPowerUp")
        
        if pick == 0 {
            myCollectible = SKSpriteNode(imageNamed: "InvertXPowerUp")
            myCollectible.name = "Collectible\(collectibleCounter)InvertXPowerUp"
        } else if pick == 1 {
            myCollectible = SKSpriteNode(imageNamed: "InvertYPowerUp")
            myCollectible.name = "Collectible\(collectibleCounter)InvertYPowerUp"
        }else if pick == 2 {
            myCollectible = SKSpriteNode(imageNamed: "SpeedUpPowerUp")
            myCollectible.name = "Collectible\(collectibleCounter)SpeedUpPowerUp"
        }else if pick == 3 {
            myCollectible = SKSpriteNode(imageNamed: "InvertXYPowerUp")
            myCollectible.name = "Collectible\(collectibleCounter)InvertXYPowerUp"
        }else if pick == 4 {
            myCollectible = SKSpriteNode(imageNamed: "WallPowerUp")
            myCollectible.name = "Collectible\(collectibleCounter)FullWallPowerUp"
        }else if pick == 5 {
            myCollectible = SKSpriteNode(imageNamed: "NoWallPowerUp")
            myCollectible.name = "Collectible\(collectibleCounter)NoWallPowerUp"
        }else if pick == 6 {
            myCollectible = SKSpriteNode(imageNamed: "CornerWallPowerUp")
            myCollectible.name = "Collectible\(collectibleCounter)CornerWallPowerUp"
        }
        
        myCollectible.size = CGSize(width: snakeSize, height: snakeSize)
        myCollectible.position = CGPoint(x: (size.width*0.5 - CGFloat(playableWidth/2) + CGFloat(snakeSize/2)), y: (size.height*0.5 + CGFloat(playableHeight/2)) - CGFloat(snakeSize/2))
        myCollectible.position.x += CGFloat(Int.random(in: 1...numberOfColumns-2)*snakeSize) + 1
        myCollectible.position.y -= CGFloat(Int.random(in: 1...numberOfRows-2)*snakeSize)
        
        myCollectible.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: snakeSize/2, height: snakeSize/2))
        myCollectible.physicsBody?.affectedByGravity = false
        myCollectible.physicsBody?.restitution = 0
        myCollectible.physicsBody?.isDynamic = true
        myCollectible.physicsBody?.categoryBitMask = PhysicsBitMasks.collectibleBitMask
        myCollectible.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask
        myCollectible.physicsBody?.collisionBitMask = PhysicsBitMasks.none
        
        if(myCollectible.position == snakeHead.position || myCollectible.position == firstCollectible.position){
            print("Rerolling...")
            spawnSecondCollectible(firstCollectible: firstCollectible)
        } else {
            addChild(myCollectible)
            collectibleCounter += 1
        }
        
        lastSecond = timerCounter

    }
    
    func snakeHeadMovement(){
        
        if(!gameOver){
            if(snakeHeadMove){
                snakeHeadMove = false
                switch nextDirection{
                case "Up":
                    yMovement = CGFloat(snakeSize)
                    xMovement = 0
                case "Down":
                    yMovement = CGFloat(-snakeSize)
                    xMovement = 0
                case "Right":
                    xMovement = CGFloat(snakeSize)
                    yMovement = 0
                case "Left":
                    xMovement = CGFloat(-snakeSize)
                    yMovement = 0
                default:
                    return
                }
                
                snakeHead.position.x += xMovement
                snakeHead.position.y += yMovement
                
                
                if(snakeBody.count != 0){
                    for index in 0...snakeBody.count-1{
                        if(index == 0){
                            snakeBody[index].nextDirection = previousDirection
                            moveBody(index: index)
                        } else {
                            snakeBody[index].nextDirection = snakeBody[index-1].previousDirection
                            moveBody(index: index)
                        }
                    }
                    
                    for index in 0...snakeBody.count-1{
                        if(index == snakeBody.count-1){
                            snakeBody[index].previousDirection = snakeBody[index].nextDirection
                            
                            snakeHeadMove = true
                        } else {
                            snakeBody[index].previousDirection = snakeBody[index].nextDirection
                            
                        }
                    }
                    
                } else {
                    snakeHeadMove = true
                }
                
                previousDirection = nextDirection
                
                DispatchQueue.main.asyncAfter(deadline: .now()+movementFrequency, execute: {
                    self.snakeHeadMovement()
                })
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    self.snakeHeadMovement()
                })
            }
        } else {
            return
        }
        
    }
    
    func moveBody(index: Int){
        var snakeBodyXMovement: CGFloat = 0
        var snakeBodyYMovement: CGFloat = 0
                
        switch snakeBody[index].nextDirection{
        case "Up":
            snakeBodyYMovement = CGFloat(snakeSize)
            snakeBodyXMovement = 0
        case "Down":
            snakeBodyYMovement = CGFloat(-snakeSize)
            snakeBodyXMovement = 0
        case "Right":
            snakeBodyXMovement = CGFloat(snakeSize)
            snakeBodyYMovement = 0
        case "Left":
            snakeBodyXMovement = CGFloat(-snakeSize)
            snakeBodyYMovement = 0
        default:
            return
        }
        
        snakeBody[index].snakeBodyPartNode.position.x += snakeBodyXMovement
        snakeBody[index].snakeBodyPartNode.position.y += snakeBodyYMovement
        
    }

    //*****************
    //FUNZIONI PER GESTIRE LO SWIPE
    func addSwipeGestureRecognizers(){
        let swipeGestureDirections: [UISwipeGestureRecognizer.Direction] = [.up, .down, .right, .left]
        
        for direction in swipeGestureDirections{
            let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            gestureRecognizer.direction = direction
            self.view?.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer){
        if let gesture = gesture as? UISwipeGestureRecognizer{
            switch gesture.direction {
            case .up:
                    if(previousDirection != "Down" && previousDirection != "Up"){
                        
                        if(!invertYPowerUp){
                            nextDirection = "Up"
                            
                            firstMoveFunction()
                            
                        } else {
                            nextDirection = "Down"
                            
                            firstMoveFunction()
                        }
                }
            case .down:
                    if(previousDirection != "Up" && previousDirection != "Down"){
                        
                        if(!invertYPowerUp){
                            nextDirection = "Down"
                            
                            firstMoveFunction()
                        } else {
                            nextDirection = "Up"
                            
                            firstMoveFunction()
                        }
                }
            case .right:
                    if(previousDirection != "Left" && previousDirection != "Rigth"){
                        
                        if(!invertXPowerUp){
                            nextDirection = "Right"
                            
                            firstMoveFunction()
                        } else {
                            nextDirection = "Left"
                            
                            firstMoveFunction()
                        }
                    }
            case .left:
                    if(previousDirection != "Left" && previousDirection != "Right"){
                        
                        if(!invertXPowerUp){
                            nextDirection = "Left"
                            
                            firstMoveFunction()
                        } else {
                            nextDirection = "Right"
                            
                            firstMoveFunction()
                        }
                }
            default:
                return
            }
        }
        
    }
    
    func firstMoveFunction(){
        
        if(firstMove){
            firstMove = false
            snakeHeadMove = true
            myTimer()
            logo.run(.moveTo(x: size.width*0.095, duration: 0.7))
            addChild(scoreMultiplierLabel)
            startingLabel.run(.fadeOut(withDuration: 0.1),completion: {
                self.startingLabel.removeFromParent()
            })
            addChild(myAnimatedScore)
            myAnimatedScore.alpha = 0
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
        
        if(touchedNode.name == "MainMenu"){
            movementFrequency = 0.1
            
            if(snakeBody.count != 0){
                for i in 0...snakeBody.count-1{
                    snakeBody[i].snakeBodyPartNode.removeAllActions()
                    snakeBody[i].previousDirection = ""
                    snakeBody[i].nextDirection = ""
                }
                snakeBody.removeAll()
            }
            
            
            self.previousDirection = ""
            self.nextDirection = ""
            self.snakeHead.removeAllActions()
            
            self.removeAllChildren()
            let scene = MainMenu(size: size)
            view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
        }
        
        
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if(invertXPowerUp){
            xPowerUpReminderCover.alpha = 0
        } else {
            xPowerUpReminderCover.alpha = 0.7
        }
        
        if(invertYPowerUp){
            yPowerUpReminderCover.alpha = 0
        } else {
            yPowerUpReminderCover.alpha = 0.7
        }
        
        if(movementFrequency != 0.1){
            speedUpPowerUpReminderCover.alpha = 0
        } else {
            speedUpPowerUpReminderCover.alpha = 0.7
        }
        
        if(checkSpeedUp){
            if(speedUpCounter - timerCounter >= 5){
                checkSpeedUp = false
                movementFrequency = movementFrequency * 2
            }
        }
        
        if(timerCounter < 10){
            timerLabel.text = "0:0\(timerCounter)"
        }
        else if(timerCounter <= 59){
            timerLabel.text = "0:\(timerCounter)"
        }
        
        
        if(timerCounter < 0){
            if(snakeBody.count != 0){
                for i in 0...snakeBody.count-1{
                    snakeBody[i].snakeBodyPartNode.removeAllActions()
                    snakeBody[i].previousDirection = ""
                    snakeBody[i].nextDirection = ""
                }
            }
            self.previousDirection = ""
            self.nextDirection = ""
            self.snakeHead.removeAllActions()
            self.removeAllChildren()
            
            gameOver = true
            
            if(highestScore < totalScore){
                highestScore = totalScore
            }
            
            let gameOverScene = GameOverScreen(size: self.size)
            view?.presentScene(gameOverScene)
        }
        
        scoreLabel.text = "\(totalScore)"
        
        
        if(snakeHead.position.x > (playableBackground.position.x + CGFloat(playableWidth/2) )){
            snakeHead.position.x = playableBackground.position.x - CGFloat(playableWidth/2) + CGFloat(snakeSize/2)
        }
        if(snakeHead.position.x < (playableBackground.position.x - CGFloat(playableWidth/2) )){
            snakeHead.position.x = playableBackground.position.x + CGFloat(playableWidth/2) - CGFloat(snakeSize/2)
        }
        if(snakeHead.position.y > (playableBackground.position.y + CGFloat(playableHeight/2)  )){
            snakeHead.position.y = playableBackground.position.y - CGFloat(playableHeight/2) + CGFloat(snakeSize/2)
        }
        if(snakeHead.position.y < (playableBackground.position.y - CGFloat(playableHeight/2) )){
            snakeHead.position.y = playableBackground.position.y + CGFloat(playableHeight/2) - CGFloat(snakeSize/2)
        }

        if(snakeBody.count != 0){
            for index in 0...snakeBody.count-1{
                if(snakeBody[index].snakeBodyPartNode.position.x > (playableBackground.position.x + CGFloat(playableWidth/2) )){
                    snakeBody[index].snakeBodyPartNode.position.x = playableBackground.position.x - CGFloat(playableWidth/2) + CGFloat(snakeSize/2)
                }
                if(snakeBody[index].snakeBodyPartNode.position.x < (playableBackground.position.x - CGFloat(playableWidth/2) )){
                    snakeBody[index].snakeBodyPartNode.position.x = playableBackground.position.x + CGFloat(playableWidth/2) - CGFloat(snakeSize/2)
                }
                if(snakeBody[index].snakeBodyPartNode.position.y > (playableBackground.position.y + CGFloat(playableHeight/2)  )){
                    snakeBody[index].snakeBodyPartNode.position.y = playableBackground.position.y - CGFloat(playableHeight/2) + CGFloat(snakeSize/2)
                }
                if(snakeBody[index].snakeBodyPartNode.position.y < (playableBackground.position.y - CGFloat(playableHeight/2) )){
                    snakeBody[index].snakeBodyPartNode.position.y = playableBackground.position.y + CGFloat(playableHeight/2) - CGFloat(snakeSize/2)
                }
            }
        }

    }
    
    func createWallWithAnimation(){
        print("Entering")
        let wallAnimationDelay: CGFloat = 0.01
        
        for index in 0...numberOfRows-1{
            let myInvisibleWall = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myInvisibleWall.position = CGPoint(x: size.width*0.5 - (CGFloat(playableWidth)*0.5) + (CGFloat(snakeSize)*0.5) ,y: size.height*0.5 + (CGFloat(playableHeight)*0.5) - (CGFloat(snakeSize)*0.5))
            myInvisibleWall.fillColor = wallColor
            myInvisibleWall.strokeColor = wallColor
            myInvisibleWall.position.y -= CGFloat((index)*(snakeSize))
            myInvisibleWall.position.x += 1
            myInvisibleWall.xScale = 0
            myInvisibleWall.yScale = 0
            addChild(myInvisibleWall)
            myInvisibleWall.zPosition = 100
            
            myInvisibleWall.run(.scale(to: 1, duration: 0.2))
            
            myInvisibleWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(snakeSize)*0.8, height: CGFloat(snakeSize)*0.8))
            myInvisibleWall.physicsBody?.affectedByGravity = false
            myInvisibleWall.physicsBody?.restitution = 0
            myInvisibleWall.physicsBody?.isDynamic = false
            myInvisibleWall.physicsBody?.categoryBitMask = PhysicsBitMasks.wallBitMask
            myInvisibleWall.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask
            
            myInvisibleWall.name = "myWall"
        }
        
        for index in 1...numberOfColumns-1{
            let myInvisibleWall = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myInvisibleWall.position = CGPoint(x: size.width*0.5 - (CGFloat(playableWidth)*0.5) + (CGFloat(snakeSize)*0.5) ,y: size.height*0.5 - (CGFloat(playableHeight)*0.5) + (CGFloat(snakeSize)*0.5))
            myInvisibleWall.fillColor = wallColor
            myInvisibleWall.strokeColor = wallColor
            myInvisibleWall.position.x += CGFloat((index)*(snakeSize))
            myInvisibleWall.position.x += 1
            myInvisibleWall.xScale = 0
            myInvisibleWall.yScale = 0
            addChild(myInvisibleWall)
            myInvisibleWall.zPosition = 101
            
            myInvisibleWall.run(.scale(to: 1, duration: 0.2))
            
            myInvisibleWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(snakeSize)*0.8, height: CGFloat(snakeSize)*0.8))
            myInvisibleWall.physicsBody?.affectedByGravity = false
            myInvisibleWall.physicsBody?.restitution = 0
            myInvisibleWall.physicsBody?.isDynamic = false
            myInvisibleWall.physicsBody?.categoryBitMask = PhysicsBitMasks.wallBitMask
            myInvisibleWall.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask
            
            myInvisibleWall.name = "myWall"
        }
        
        for index in 1...numberOfRows-1{
            let myInvisibleWall = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myInvisibleWall.position = CGPoint(x: size.width*0.5 + (CGFloat(playableWidth)*0.5) - (CGFloat(snakeSize)*0.5) ,y: size.height*0.5 - (CGFloat(playableHeight)*0.5) + (CGFloat(snakeSize)*0.5))
            myInvisibleWall.fillColor = wallColor
            myInvisibleWall.strokeColor = wallColor
            myInvisibleWall.position.y += CGFloat((index)*(snakeSize))
            myInvisibleWall.position.x -= 1
            myInvisibleWall.zPosition = 102
            myInvisibleWall.xScale = 0
            myInvisibleWall.yScale = 0
            addChild(myInvisibleWall)
            
            myInvisibleWall.run(.scale(to: 1, duration: 0.2))
            
            myInvisibleWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(snakeSize)*0.8, height: CGFloat(snakeSize)*0.8))
            myInvisibleWall.physicsBody?.affectedByGravity = false
            myInvisibleWall.physicsBody?.restitution = 0
            myInvisibleWall.physicsBody?.isDynamic = false
            myInvisibleWall.physicsBody?.categoryBitMask = PhysicsBitMasks.wallBitMask
            myInvisibleWall.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask
            
            myInvisibleWall.name = "myWall"

        }
        
        for index in 1...numberOfColumns-2{
            let myInvisibleWall = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))

            myInvisibleWall.position = CGPoint(x: size.width*0.5 + (CGFloat(playableWidth)*0.5) - (CGFloat(snakeSize)*0.5) ,y: size.height*0.5 + (CGFloat(playableHeight)*0.5) - (CGFloat(snakeSize)*0.5))
            myInvisibleWall.fillColor = wallColor
            myInvisibleWall.strokeColor = wallColor
            myInvisibleWall.position.x -= CGFloat((index)*(snakeSize))
            myInvisibleWall.position.x -= 1
            myInvisibleWall.zPosition = 10
            myInvisibleWall.xScale = 0
            myInvisibleWall.yScale = 0
            addChild(myInvisibleWall)
            
            myInvisibleWall.run(.scale(to: 1, duration: 0.2))
            
            myInvisibleWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(snakeSize)*0.8, height: CGFloat(snakeSize)*0.8))
            myInvisibleWall.physicsBody?.affectedByGravity = false
            myInvisibleWall.physicsBody?.restitution = 0
            myInvisibleWall.physicsBody?.isDynamic = false
            myInvisibleWall.physicsBody?.categoryBitMask = PhysicsBitMasks.wallBitMask
            myInvisibleWall.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask
            
            myInvisibleWall.name = "myWall"
        }
    }
    
    func createWall(){
        
        
        for index in 0...numberOfRows-1{
            var myWall = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myWall.position = CGPoint(x: size.width*0.5 - (CGFloat(playableWidth)*0.5) + (CGFloat(snakeSize)*0.5) ,y: size.height*0.5 + (CGFloat(playableHeight)*0.5) - (CGFloat(snakeSize)*0.5))
            myWall.fillColor = wallColor
            myWall.strokeColor = wallColor
            myWall.position.y -= CGFloat((index)*(snakeSize))
            myWall.name = "myWall"
            myWall.xScale = 0
            myWall.yScale = 0
            addChild(myWall)
            myWall.run(.scaleX(to: 1, duration: 1))
            myWall.run(.scaleY(to: 1, duration: 1))
        }
        
        for index in 0...numberOfRows-1{
            var myWall = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myWall.position = CGPoint(x: size.width*0.5 + (CGFloat(playableWidth)*0.5) - (CGFloat(snakeSize)*0.5) ,y: size.height*0.5 + (CGFloat(playableHeight)*0.5) - (CGFloat(snakeSize)*0.5))
            myWall.fillColor = wallColor
            myWall.strokeColor = wallColor
            myWall.position.y -= CGFloat((index)*(snakeSize))
            myWall.name = "myWall"
            myWall.xScale = 0
            myWall.yScale = 0
            addChild(myWall)
            myWall.run(.scaleX(to: 1, duration: 1))
            myWall.run(.scaleY(to: 1, duration: 1))
        }
        
        for index in 1...numberOfColumns-2{
            var myWall = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myWall.position = CGPoint(x: size.width*0.5 - (CGFloat(playableWidth)*0.5) + (CGFloat(snakeSize)*0.5) ,y: size.height*0.5 + (CGFloat(playableHeight)*0.5) - (CGFloat(snakeSize)*0.5))
            myWall.fillColor = wallColor
            myWall.strokeColor = wallColor
            myWall.position.x += CGFloat((index)*(snakeSize))
            myWall.position.x += 1
            myWall.name = "myWall"
            myWall.xScale = 0
            myWall.yScale = 0
            addChild(myWall)
            myWall.run(.scaleX(to: 1, duration: 1))
            myWall.run(.scaleY(to: 1, duration: 1))
        }
        
        for index in 1...numberOfColumns-2{
            var myWall = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myWall.position = CGPoint(x: size.width*0.5 - (CGFloat(playableWidth)*0.5) + (CGFloat(snakeSize)*0.5) ,y: size.height*0.5 - (CGFloat(playableHeight)*0.5) + (CGFloat(snakeSize)*0.5))
            myWall.fillColor = wallColor
            myWall.strokeColor = wallColor
            myWall.position.x += CGFloat((index)*(snakeSize))
            myWall.position.x += 1
            myWall.name = "myWall"
            myWall.xScale = 0
            myWall.yScale = 0
            addChild(myWall)
            myWall.run(.scaleX(to: 1, duration: 1))
            myWall.run(.scaleY(to: 1, duration: 1))
        }
        
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if(contact.bodyA.node?.name == "SnakeHead"){
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else if(contact.bodyB.node?.name == "SnakeHead"){
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        } else if(contact.bodyB.node?.name == "SnakeBody"){
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        } else if(contact.bodyB.node?.name == "SnakeBody"){
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        let secondBodyName = secondBody.node?.name
        
        guard secondBodyName != nil else{
            return
        }
        
        if(firstBody.node?.name == "SnakeHead" && secondBodyName!.contains("Collectible")){
            feedbackGenerator.notificationOccurred(.success)
            if(secondBodyName!.contains("InvertXPowerUp")){
                invertXPowerUp.toggle()
                powerUpLabel.text = "Inverted X"
            } else if(secondBodyName!.contains("InvertYPowerUp")){
                invertYPowerUp.toggle()
                powerUpLabel.text = "Inverted Y"
            } else if(secondBodyName!.contains("SpeedUpPowerUp")){
                if(!checkSpeedUp){
                    movementFrequency = movementFrequency/2
                }
                checkSpeedUp = true
                speedUpCounter = timerCounter
                powerUpLabel.text = "Speeding up"
            } else if(secondBodyName!.contains("InvertXYPowerUp")){
                invertYPowerUp.toggle()
                invertXPowerUp.toggle()
                powerUpLabel.text = "Inverted X and Y"
            }
            else if(secondBodyName!.contains("FullWallPowerUp")){
                powerUpLabel.text = "Creating walls"
                if(!checkWall){
                    if(!checkCornerWall){
                        createWallWithAnimation()
                        checkWall = true
                    } else {
                        fillWall()
                        checkWall = true
                        checkCornerWall = false
                    }
                }
            }else if(secondBodyName!.contains("NoWallPowerUp")){
                powerUpLabel.text = "Removing walls"
                if(checkWall || checkCornerWall){
                    removeWall()
                    checkWall = false
                    checkCornerWall = false
                }
            }else if(secondBodyName!.contains("CornerWallPowerUp")){
                powerUpLabel.text = "Creating corner walls"
                if(!checkCornerWall){
                    print("Checking CORNERWALL")
                    print("\(checkCornerWall) + \(checkWall)")
                    if(!checkWall){
                        createCornerWalls()
                        checkCornerWall = true
                    } else {
                        removeCenterWall()
                        checkWall = false
                        checkCornerWall = true
                    }
                }
            }
            
            enumerateChildNodes(withName: "*"){node, _ in
                let nodeName = node.name
                if nodeName != nil {
                    if(nodeName!.contains("Collectible")){
                        node.removeFromParent()
                        
                    }
                }

            }
            
            let multiplier = self.lastSecond-self.timerCounter
            if(multiplier > 10){
                self.totalScore += 100
            } else if(multiplier == 0){
                self.myCalculatedScore = 100*10
                self.totalScore += self.myCalculatedScore
            } else {
                self.myCalculatedScore = 100*(10-multiplier)
                self.totalScore += self.myCalculatedScore
            }
            
            
            if(myAnimatedScore.alpha == 0){
                myAnimatedScore.alpha = 1
                myAnimatedScore.text = scoreMultiplierLabel.text
                myAnimatedScore.run(.moveTo(y: scoreLabel.position.y + scoreLabel.fontSize, duration: 1.5))
                myAnimatedScore.run(.fadeOut(withDuration: 1.5), completion: {
                    self.myAnimatedScore.removeAllActions()
                    self.myAnimatedScore.alpha = 0
                    self.myAnimatedScore.position = self.scoreMultiplierLabel.position
                })
            } else {
                myAnimatedScore.removeAllActions()
                myAnimatedScore.alpha = 0
                myAnimatedScore.position = scoreMultiplierLabel.position
                
                myAnimatedScore.alpha = 1
                myAnimatedScore.text = scoreMultiplierLabel.text
                myAnimatedScore.run(.moveTo(y: scoreLabel.position.y + scoreLabel.fontSize, duration: 1.5))
                myAnimatedScore.run(.fadeOut(withDuration: 1.5), completion: {
                    self.myAnimatedScore.removeAllActions()
                    self.myAnimatedScore.alpha = 0
                    self.myAnimatedScore.position = self.scoreMultiplierLabel.position
                })
            }
            
            
            self.spawnCollectible()
            
            self.addSnakePart()
            
        }
        
        if(firstBody.node?.name == "SnakeHead" && secondBodyName!.contains("SnakeBody")){
            gameOverType = "SnakeHead+SnakeBody"
            
            gameOver = true
            
            if(highestScore < totalScore){
                highestScore = totalScore
            }
            
            movementFrequency = 0.1
            
            if(snakeBody.count != 0){
                for i in 0...snakeBody.count-1{
                    snakeBody[i].snakeBodyPartNode.removeAllActions()
                    snakeBody[i].previousDirection = ""
                    snakeBody[i].nextDirection = ""
                }
                snakeBody.removeAll()
            }
            
            self.previousDirection = ""
            self.nextDirection = ""
            self.snakeHead.removeAllActions()
            self.removeAllChildren()

            
            let gameOverScene = GameOverScreen(size: self.size)
            view?.presentScene(gameOverScene)
        }
        
        if(firstBody.node?.name == "SnakeHead" && secondBodyName!.contains("myWall")){
            gameOverType = "SnakeHead+Wall"
            
            deathFeedbackGenerator.impactOccurred()
            
            gameOver = true
            
            if(highestScore < totalScore){
                highestScore = totalScore
            }
            
            movementFrequency = 0.1
            
            if(snakeBody.count != 0){
                
                
                
                for i in 0...snakeBody.count-1{
                    snakeBody[i].snakeBodyPartNode.removeAllActions()
                    snakeBody[i].previousDirection = ""
                    snakeBody[i].nextDirection = ""
                }
                snakeBody.removeAll()
            }
            
            
            self.previousDirection = ""
            self.nextDirection = ""
            self.snakeHead.removeAllActions()
            self.removeAllChildren()

            let gameOverScene = GameOverScreen(size: self.size)
            view?.presentScene(gameOverScene)
            
        }
        
        if (firstBody.node?.name == "SnakeBody" && secondBodyName!.contains("myWall")){
            gameOverType = "SnakeBody+Wall"
            
            gameOver = true
            
            if(highestScore < totalScore){
                highestScore = totalScore
            }
            
            movementFrequency = 0.1
            
            if(snakeBody.count != 0){
                
                
                
                for i in 0...snakeBody.count-1{
                    snakeBody[i].snakeBodyPartNode.removeAllActions()
                    snakeBody[i].previousDirection = ""
                    snakeBody[i].nextDirection = ""
                }
                snakeBody.removeAll()
            }
            
            
            self.previousDirection = ""
            self.nextDirection = ""
            self.snakeHead.removeAllActions()
            self.removeAllChildren()

            let gameOverScene = GameOverScreen(size: self.size)
            view?.presentScene(gameOverScene)
        }
        
        
    }
    
    func removeWall(){
        enumerateChildNodes(withName: "*"){node, _ in
            if(node.name == "myWall"){
                node.run(.scale(to: 0, duration: 0.2), completion: {
                    node.removeFromParent()
                })
            }
            
        }
    }
    
    
    func addSnakePart(){
        if(snakeBody.count == 0){
            snakeBody.append(SnakeBodyPart(snakeBodyPartNode: SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))))
            switch previousDirection{
            case "Up":
                snakeBody[snakeBody.count-1].snakeBodyPartNode.position.x = snakeHead.position.x
                snakeBody[snakeBody.count-1].snakeBodyPartNode.position.y = snakeHead.position.y - CGFloat(snakeSize)
            case "Down":
                snakeBody[snakeBody.count-1].snakeBodyPartNode.position.x = snakeHead.position.x
                snakeBody[snakeBody.count-1].snakeBodyPartNode.position.y = snakeHead.position.y + CGFloat(snakeSize)
            case "Right":
                snakeBody[snakeBody.count-1].snakeBodyPartNode.position.x = snakeHead.position.x - CGFloat(snakeSize)
                snakeBody[snakeBody.count-1].snakeBodyPartNode.position.y = snakeHead.position.y
            case "Left":
                snakeBody[snakeBody.count-1].snakeBodyPartNode.position.x = snakeHead.position.x + CGFloat(snakeSize)
                snakeBody[snakeBody.count-1].snakeBodyPartNode.position.y = snakeHead.position.y
            default:
                return
            }
            snakeBody[snakeBody.count-1].snakeBodyPartNode.strokeColor = snakeBodyColor
            snakeBody[snakeBody.count-1].snakeBodyPartNode.fillColor = snakeBodyColor
            
            snakeBody[snakeBody.count-1].snakeBodyPartNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: snakeSize/2, height: snakeSize/2))
            snakeBody[snakeBody.count-1].snakeBodyPartNode.physicsBody?.affectedByGravity = false
            snakeBody[snakeBody.count-1].snakeBodyPartNode.physicsBody?.restitution = 0
            snakeBody[snakeBody.count-1].snakeBodyPartNode.physicsBody?.isDynamic = true
            snakeBody[snakeBody.count-1].snakeBodyPartNode.physicsBody?.categoryBitMask = PhysicsBitMasks.snakeBodyMask
            snakeBody[snakeBody.count-1].snakeBodyPartNode.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask | PhysicsBitMasks.wallBitMask
            snakeBody[snakeBody.count-1].snakeBodyPartNode.physicsBody?.collisionBitMask = PhysicsBitMasks.none
            snakeBody[snakeBody.count-1].snakeBodyPartNode.name = "SnakeBody"
            addChild(snakeBody[snakeBody.count-1].snakeBodyPartNode)
        } else {
            snakeBody.append(SnakeBodyPart(snakeBodyPartNode: SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))))
            switch snakeBody[snakeBody.count-2].previousDirection{
            case "Up":
                snakeBody[snakeBody.count-1].snakeBodyPartNode.position.x = snakeBody[snakeBody.count-2].snakeBodyPartNode.position.x
                snakeBody[snakeBody.count-1].snakeBodyPartNode.position.y = snakeBody[snakeBody.count-2].snakeBodyPartNode.position.y - CGFloat(snakeSize)
            case "Down":
                snakeBody[snakeBody.count-1].snakeBodyPartNode.position.x = snakeBody[snakeBody.count-2].snakeBodyPartNode.position.x
                snakeBody[snakeBody.count-1].snakeBodyPartNode.position.y = snakeBody[snakeBody.count-2].snakeBodyPartNode.position.y + CGFloat(snakeSize)
            case "Right":
                snakeBody[snakeBody.count-1].snakeBodyPartNode.position.x = snakeBody[snakeBody.count-2].snakeBodyPartNode.position.x - CGFloat(snakeSize)
                snakeBody[snakeBody.count-1].snakeBodyPartNode.position.y = snakeBody[snakeBody.count-2].snakeBodyPartNode.position.y
            case "Left":
                snakeBody[snakeBody.count-1].snakeBodyPartNode.position.x = snakeBody[snakeBody.count-2].snakeBodyPartNode.position.x + CGFloat(snakeSize)
                snakeBody[snakeBody.count-1].snakeBodyPartNode.position.y = snakeBody[snakeBody.count-2].snakeBodyPartNode.position.y
            default:
                return
            }
            snakeBody[snakeBody.count-1].snakeBodyPartNode.strokeColor = snakeBodyColor
            snakeBody[snakeBody.count-1].snakeBodyPartNode.fillColor = snakeBodyColor
            
            snakeBody[snakeBody.count-1].snakeBodyPartNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: snakeSize/2, height: snakeSize/2))
            snakeBody[snakeBody.count-1].snakeBodyPartNode.physicsBody?.affectedByGravity = false
            snakeBody[snakeBody.count-1].snakeBodyPartNode.physicsBody?.restitution = 0
            snakeBody[snakeBody.count-1].snakeBodyPartNode.physicsBody?.isDynamic = true
            snakeBody[snakeBody.count-1].snakeBodyPartNode.physicsBody?.categoryBitMask = PhysicsBitMasks.snakeBodyMask
            snakeBody[snakeBody.count-1].snakeBodyPartNode.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask | PhysicsBitMasks.wallBitMask
            snakeBody[snakeBody.count-1].snakeBodyPartNode.physicsBody?.collisionBitMask = PhysicsBitMasks.none
            snakeBody[snakeBody.count-1].snakeBodyPartNode.name = "SnakeBody"
            addChild(snakeBody[snakeBody.count-1].snakeBodyPartNode)
                
        }
    }
    
    func createCornerWalls(){
        for index in 0...horizontalCornerWalls-1{
            let myWall: SKShapeNode = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myWall.position = CGPoint(x: size.width*0.5 - CGFloat(playableWidth)*0.5 + CGFloat(snakeSize/2), y: size.height*0.5 + CGFloat(playableHeight)*0.5 - CGFloat(snakeSize/2))
            myWall.position.x += CGFloat(index*snakeSize)
            myWall.strokeColor = wallColor
            myWall.fillColor = wallColor
            myWall.yScale = 0
            myWall.xScale = 0
            myWall.zPosition = 50
            myWall.name = "myWall"
            myWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(snakeSize)*0.8, height: CGFloat(snakeSize)*0.8))
            myWall.physicsBody?.affectedByGravity = false
            myWall.physicsBody?.restitution = 0
            myWall.physicsBody?.isDynamic = false
            myWall.physicsBody?.categoryBitMask = PhysicsBitMasks.wallBitMask
            myWall.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask
            addChild(myWall)
            myWall.run(.scale(to: 1, duration: 0.2))
            
            
            let myWall2: SKShapeNode = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myWall2.position = CGPoint(x: size.width*0.5 + CGFloat(playableWidth)*0.5 - CGFloat(snakeSize/2), y: size.height*0.5 + CGFloat(playableHeight)*0.5 - CGFloat(snakeSize/2))
            myWall2.position.x -= CGFloat(index*snakeSize)
            myWall2.strokeColor = wallColor
            myWall2.fillColor = wallColor
            myWall2.yScale = 0
            myWall2.xScale = 0
            myWall2.zPosition = 50
            myWall2.name = "myWall"
            myWall2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(snakeSize)*0.8, height: CGFloat(snakeSize)*0.8))
            myWall2.physicsBody?.affectedByGravity = false
            myWall2.physicsBody?.restitution = 0
            myWall2.physicsBody?.isDynamic = false
            myWall2.physicsBody?.categoryBitMask = PhysicsBitMasks.wallBitMask
            myWall2.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask
            addChild(myWall2)
            myWall2.run(.scale(to: 1, duration: 0.2))
            
            
            let myWall3: SKShapeNode = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myWall3.position = CGPoint(x: size.width*0.5 - CGFloat(playableWidth)*0.5 + CGFloat(snakeSize/2), y: size.height*0.5 - CGFloat(playableHeight)*0.5 + CGFloat(snakeSize/2))
            myWall3.position.x += CGFloat(index*snakeSize)
            myWall3.strokeColor = wallColor
            myWall3.fillColor = wallColor
            myWall3.yScale = 0
            myWall3.xScale = 0
            myWall3.zPosition = 50
            myWall3.name = "myWall"
            myWall3.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(snakeSize)*0.8, height: CGFloat(snakeSize)*0.8))
            myWall3.physicsBody?.affectedByGravity = false
            myWall3.physicsBody?.restitution = 0
            myWall3.physicsBody?.isDynamic = false
            myWall3.physicsBody?.categoryBitMask = PhysicsBitMasks.wallBitMask
            myWall3.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask
            addChild(myWall3)
            myWall3.run(.scale(to: 1, duration: 0.2))
            
            
            let myWall4: SKShapeNode = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myWall4.position = CGPoint(x: size.width*0.5 + CGFloat(playableWidth)*0.5 - CGFloat(snakeSize/2), y: size.height*0.5 - CGFloat(playableHeight)*0.5 + CGFloat(snakeSize/2))
            myWall4.position.x -= CGFloat(index*snakeSize)
            myWall4.strokeColor = wallColor
            myWall4.fillColor = wallColor
            myWall4.yScale = 0
            myWall4.xScale = 0
            myWall4.zPosition = 50
            myWall4.name = "myWall"
            myWall4.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(snakeSize)*0.8, height: CGFloat(snakeSize)*0.8))
            myWall4.physicsBody?.affectedByGravity = false
            myWall4.physicsBody?.restitution = 0
            myWall4.physicsBody?.isDynamic = false
            myWall4.physicsBody?.categoryBitMask = PhysicsBitMasks.wallBitMask
            myWall4.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask
            addChild(myWall4)
            myWall4.run(.scale(to: 1, duration: 0.2))
        }
        
        for index in 1...verticalCornerWalls-1{
            let myWall: SKShapeNode = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myWall.position = CGPoint(x: size.width*0.5 - CGFloat(playableWidth)*0.5 + CGFloat(snakeSize/2), y: size.height*0.5 + CGFloat(playableHeight)*0.5 - CGFloat(snakeSize/2))
            myWall.position.y -= CGFloat(index*snakeSize)
            myWall.strokeColor = wallColor
            myWall.fillColor = wallColor
            myWall.yScale = 0
            myWall.xScale = 0
            myWall.zPosition = 50
            myWall.name = "myWall"
            myWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(snakeSize)*0.8, height: CGFloat(snakeSize)*0.8))
            myWall.physicsBody?.affectedByGravity = false
            myWall.physicsBody?.restitution = 0
            myWall.physicsBody?.isDynamic = false
            myWall.physicsBody?.categoryBitMask = PhysicsBitMasks.wallBitMask
            myWall.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask
            addChild(myWall)
            myWall.run(.scale(to: 1, duration: 0.2))
            
            let myWall2: SKShapeNode = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myWall2.position = CGPoint(x: size.width*0.5 + CGFloat(playableWidth)*0.5 - CGFloat(snakeSize/2), y: size.height*0.5 + CGFloat(playableHeight)*0.5 - CGFloat(snakeSize/2))
            myWall2.position.y -= CGFloat(index*snakeSize)
            myWall2.strokeColor = wallColor
            myWall2.fillColor = wallColor
            myWall2.yScale = 0
            myWall2.xScale = 0
            myWall2.zPosition = 50
            myWall2.name = "myWall"
            myWall2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(snakeSize)*0.8, height: CGFloat(snakeSize)*0.8))
            myWall2.physicsBody?.affectedByGravity = false
            myWall2.physicsBody?.restitution = 0
            myWall2.physicsBody?.isDynamic = false
            myWall2.physicsBody?.categoryBitMask = PhysicsBitMasks.wallBitMask
            myWall2.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask
            addChild(myWall2)
            myWall2.run(.scale(to: 1, duration: 0.2))
            
            
            let myWall3: SKShapeNode = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myWall3.position = CGPoint(x: size.width*0.5 - CGFloat(playableWidth)*0.5 + CGFloat(snakeSize/2), y: size.height*0.5 - CGFloat(playableHeight)*0.5 + CGFloat(snakeSize/2))
            myWall3.position.y += CGFloat(index*snakeSize)
            myWall3.strokeColor = wallColor
            myWall3.fillColor = wallColor
            myWall3.yScale = 0
            myWall3.xScale = 0
            myWall3.zPosition = 50
            myWall3.name = "myWall"
            myWall3.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(snakeSize)*0.8, height: CGFloat(snakeSize)*0.8))
            myWall3.physicsBody?.affectedByGravity = false
            myWall3.physicsBody?.restitution = 0
            myWall3.physicsBody?.isDynamic = false
            myWall3.physicsBody?.categoryBitMask = PhysicsBitMasks.wallBitMask
            myWall3.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask
            addChild(myWall3)
            myWall3.run(.scale(to: 1, duration: 0.2))
            
            
            let myWall4: SKShapeNode = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myWall4.position = CGPoint(x: size.width*0.5 + CGFloat(playableWidth)*0.5 - CGFloat(snakeSize/2), y: size.height*0.5 - CGFloat(playableHeight)*0.5 + CGFloat(snakeSize/2))
            myWall4.position.y += CGFloat(index*snakeSize)
            myWall4.strokeColor = wallColor
            myWall4.fillColor = wallColor
            myWall4.yScale = 0
            myWall4.xScale = 0
            myWall4.zPosition = 50
            myWall4.name = "myWall"
            myWall4.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(snakeSize)*0.8, height: CGFloat(snakeSize)*0.8))
            myWall4.physicsBody?.affectedByGravity = false
            myWall4.physicsBody?.restitution = 0
            myWall4.physicsBody?.isDynamic = false
            myWall4.physicsBody?.categoryBitMask = PhysicsBitMasks.wallBitMask
            myWall4.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask
            addChild(myWall4)
            myWall4.run(.scale(to: 1, duration: 0.2))
        }
    }
    
    func fillWall(){
        for index in horizontalCornerWalls...numberOfColumns-horizontalCornerWalls-1{
            let myWall: SKShapeNode = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myWall.position = CGPoint(x: size.width*0.5 - CGFloat(playableWidth)*0.5 + CGFloat(snakeSize/2), y: size.height*0.5 + CGFloat(playableHeight)*0.5 - CGFloat(snakeSize/2))
            myWall.position.x += CGFloat(index*snakeSize)
            myWall.strokeColor = wallColor
            myWall.fillColor = wallColor
            myWall.yScale = 0
            myWall.xScale = 0
            myWall.zPosition = 50
            myWall.name = "myWall"
            myWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(snakeSize)*0.8, height: CGFloat(snakeSize)*0.8))
            myWall.physicsBody?.affectedByGravity = false
            myWall.physicsBody?.restitution = 0
            myWall.physicsBody?.isDynamic = false
            myWall.physicsBody?.categoryBitMask = PhysicsBitMasks.wallBitMask
            myWall.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask
            addChild(myWall)
            myWall.run(.scale(to: 1, duration: 0.2))
            
            let myWall2: SKShapeNode = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myWall2.position = CGPoint(x: size.width*0.5 - CGFloat(playableWidth)*0.5 + CGFloat(snakeSize/2), y: size.height*0.5 - CGFloat(playableHeight)*0.5 + CGFloat(snakeSize/2))
            myWall2.position.x += CGFloat(index*snakeSize)
            myWall2.strokeColor = wallColor
            myWall2.fillColor = wallColor
            myWall2.yScale = 0
            myWall2.xScale = 0
            myWall2.zPosition = 50
            myWall2.name = "myWall"
            myWall2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(snakeSize)*0.8, height: CGFloat(snakeSize)*0.8))
            myWall2.physicsBody?.affectedByGravity = false
            myWall2.physicsBody?.restitution = 0
            myWall2.physicsBody?.isDynamic = false
            myWall2.physicsBody?.categoryBitMask = PhysicsBitMasks.wallBitMask
            myWall2.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask
            addChild(myWall2)
            myWall2.run(.scale(to: 1, duration: 0.2))
        }
        
        for index in verticalCornerWalls...numberOfRows-verticalCornerWalls-1{
            let myWall: SKShapeNode = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myWall.position = CGPoint(x: size.width*0.5 - CGFloat(playableWidth)*0.5 + CGFloat(snakeSize/2), y: size.height*0.5 + CGFloat(playableHeight)*0.5 - CGFloat(snakeSize/2))
            myWall.position.y -= CGFloat(index*snakeSize)
            myWall.strokeColor = wallColor
            myWall.fillColor = wallColor
            myWall.yScale = 0
            myWall.xScale = 0
            myWall.zPosition = 50
            myWall.name = "myWall"
            myWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(snakeSize)*0.8, height: CGFloat(snakeSize)*0.8))
            myWall.physicsBody?.affectedByGravity = false
            myWall.physicsBody?.restitution = 0
            myWall.physicsBody?.isDynamic = false
            myWall.physicsBody?.categoryBitMask = PhysicsBitMasks.wallBitMask
            myWall.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask
            addChild(myWall)
            myWall.run(.scale(to: 1, duration: 0.2))
            
            let myWall2: SKShapeNode = SKShapeNode(rectOf: CGSize(width: snakeSize, height: snakeSize))
            myWall2.position = CGPoint(x: size.width*0.5 + CGFloat(playableWidth)*0.5 - CGFloat(snakeSize/2), y: size.height*0.5 + CGFloat(playableHeight)*0.5 - CGFloat(snakeSize/2))
            myWall2.position.y -= CGFloat(index*snakeSize)
            myWall2.strokeColor = wallColor
            myWall2.fillColor = wallColor
            myWall2.yScale = 0
            myWall2.xScale = 0
            myWall2.zPosition = 50
            myWall2.name = "myWall"
            myWall2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(snakeSize)*0.8, height: CGFloat(snakeSize)*0.8))
            myWall2.physicsBody?.affectedByGravity = false
            myWall2.physicsBody?.restitution = 0
            myWall2.physicsBody?.isDynamic = false
            myWall2.physicsBody?.categoryBitMask = PhysicsBitMasks.wallBitMask
            myWall2.physicsBody?.contactTestBitMask = PhysicsBitMasks.snakeHeadBitMask
            addChild(myWall2)
            myWall2.run(.scale(to: 1, duration: 0.2))
        }
    }
    
    func removeCenterWall(){
        removeWall()
        createCornerWalls()
    }
    
    
}
