//
//  GameScene.swift
//  FollowTheOrder
//
//  Created by Oleh Study on 20.01.2022.
//

import SpriteKit
import GameplayKit

protocol GameLogicProtocol {
    func makeNodesAndStart() -> [String]
    func animateNodesin(array: [String])
    func recognizeTapsOnNodes()
    func addInArrayNode(index: Int)
    func compareArrays(game: [Int], user: [Int]) -> Bool
}


class GameScene: SKScene, GameLogicProtocol {
    
    var startLabel: SKLabelNode!
    var level = 1
    var levelLabel: SKLabelNode {
        let level = SKLabelNode(text: "Level \(level)")
      level.horizontalAlignmentMode = .center
      level.fontSize = 50
      level.fontName = "AvenirNext-Bold"
      level.fontColor = .white
      level.position = CGPoint(x: 0,
                               y: 550)
     return level
    }
    
    var rememberLabel: SKLabelNode!
    var countDownLabel: SKLabelNode!
    
    var presidentsArray: [String] = Presidents.allCases.map { $0.rawValue }
    
    var back: SKSpriteNode {
        var back = SKSpriteNode(imageNamed: Images.background.rawValue)
        back.position = CGPoint(x: 0, y: 0)
        back.size.width = 800
        back.size.height = 1500
        back.blendMode = .replace
        back.zPosition = -1
        return back
    }
    
    override func didMove(to view: SKView) {
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -320,
                                                         y: -640,
                                                         width: 640,
                                                         height: 1280))
        addChild(back)
  
        addChild(levelLabel)
      
        
        startLabel = SKLabelNode(text: "Touch for Start")
        startLabel.horizontalAlignmentMode = .center
        startLabel.fontSize = 75
        startLabel.fontName = "AvenirNext-Bold"
        startLabel.fontColor = .blue
        startLabel.position = CGPoint(x: 0,
                                 y: -550)
        
        addChild(startLabel)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else  { return }
        let location = touch.location(in: self)
        
        let objects = nodes(at: location)
     

        if objects.contains(startLabel) {
            var nodes = makeNodesAndStart()
            startLabel.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.animateNodesin(array: nodes)
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func makeNodesAndStart() -> [String] {
        let array = randomNumbersArray
        var gameArray = [String]()
        for item in 0...level + 8 {
            let randomPres = array[item]
          print(array)
            gameArray.append(presidentsArray[randomPres])
            let object = SKSpriteNode(imageNamed: presidentsArray[randomPres])
            object.name = presidentsArray[randomPres]
            object.physicsBody = SKPhysicsBody(circleOfRadius: 125)
            object.size = CGSize(width: 120,
                                 height: 120)
            object.position = CGPoint(x: Int.random(in: -320...320),
                                      y: Int.random(in: -620...440))
            addChild(object)
            
        }
        return gameArray
    }
    
    func animateNodesin(array: [String]) {
        for node in array {
            childNode(withName: node)?.physicsBody?.isDynamic = false
        }
        
        for (index,node) in array.enumerated() {
            let delay = SKAction.wait(forDuration: TimeInterval(index) * 1)
            let scaleUp = SKAction.scale(to: 2,
                                               duration: 0.25)
            let scaleDown = SKAction.scale(to: 1,
                                                 duration: 0.25)
            let wait = SKAction.wait(forDuration: 1)
            let scaleActionSequence = SKAction.sequence([scaleUp,
                                                         scaleDown,
                                                         wait])
            let actionSequence = SKAction.sequence([delay,
                                                   scaleActionSequence])
            childNode(withName: node)?.run(actionSequence)
        }
    }
    
    func recognizeTapsOnNodes() {
        
    }
    
    func addInArrayNode(index: Int) {
        
    }
    
    func compareArrays(game: [Int], user: [Int]) -> Bool {
        
        return true
    }
}
