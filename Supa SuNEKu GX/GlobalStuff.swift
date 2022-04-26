//
//  GlobalStuff.swift
//  Supa SuNEKu GX
//
//  Created by Salvatore Manna on 30/03/22.
//

import Foundation
import SwiftUI
import SpriteKit


struct PhysicsBitMasks{
    static let snakeHeadBitMask: UInt32 = 1<<0
    static let collectibleBitMask: UInt32 = 1<<1
    static let snakeBodyMask: UInt32 = 1<<2
    static let wallBitMask: UInt32 = 1<<3
    static let invisibleBorder: UInt32 = 1<<4
    
    static let none: UInt32 = 1<<8
}

struct SnakeBodyPart{
    var snakeBodyPartNode: SKShapeNode
    
    
    var previousDirection: String?
    var nextDirection: String?
}

var snakeBody: [SnakeBodyPart] = []
var movementFrequency: Double = 0.1

var scoreLabel: SKLabelNode = SKLabelNode(text: "0")

let snakeSize = 32



var wallColor = UIColor(red: 243/255, green: 221/255, blue: 132/255, alpha: 1)

var playLabelColor = UIColor(red: 11/255, green: 149/255, blue: 229/255, alpha: 1)
var playLabelShadowColor = UIColor(red: 253/255, green: 42/255, blue: 253/255, alpha: 1)

var bottomBorderColor = UIColor(red: 105/255, green: 100/255, blue: 124/255, alpha: 1)
var leftAndRightBorderColor = UIColor(red: 73/255, green: 69/255, blue: 88/255, alpha: 1)
var upperBorderColor = UIColor(red: 35/255, green: 32/255, blue: 46/255, alpha: 1)

var gameOverType: String = "TimesUp"

var snakeHeadColor = UIColor(red: 105/255, green: 189/255, blue: 225/255, alpha: 1)
var snakeBodyColor = UIColor(red: 93/255, green: 136/255, blue: 174/255, alpha: 1)


