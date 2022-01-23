//
//  GameScene.swift
//  FollowTheOrder
//
//  Created by Oleh Study on 20.01.2022.
//

import SpriteKit
import GameplayKit

protocol GameLogicProtocol {
    var comparedCount: Int { get set }
    var touchesNodesArray: [String] { get set }
    var currentOrderArray: [String] { get set }
    
    func makeNodesAndStart() -> [String]
    func animateNodesin(array: [String])
    func recognizeAndTouch(object: SKSpriteNode, orderedNodes: [String]) -> Bool?
    func touchNodeAnimation() -> SKAction
    func runCountDownLabel(time: Int)
}

class GameScene: SKScene, GameLogicProtocol {
    
    
    var comparedCount: Int = 0
    var currentOrderArray: [String] = [String]()
    var touchesNodesArray: [String] = [String]()
    var startLabel: SKLabelNode!
    var level: Int {
        get {
            switch UserData.shared.level {
            case 0,6:
                UserData.shared.level = 5
                return UserData.shared.level!
            default:
                return UserData.shared.level!
            }
        }
        set {
            UserData.shared.level = newValue
        }
    }
    
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
    
    var repeatLbl: SKLabelNode {
        let repeatLbl = SKLabelNode(text: "Repeat the order")
        repeatLbl.horizontalAlignmentMode = .center
        repeatLbl.fontSize = 50
        repeatLbl.fontName = "AvenirNext-Bold"
        repeatLbl.fontColor = .red
        repeatLbl.position = CGPoint(x: 0,
                                     y: -600)
        return repeatLbl
    }
    

    
    var presidentsArray: [String] = Presidents.allCases.map { $0.rawValue }
    
    var back: SKSpriteNode {
        let back = SKSpriteNode(imageNamed: Images.background.rawValue)
        back.position = CGPoint(x: 0, y: 0)
        back.size.width = 800
        back.size.height = 1500
        back.blendMode = .replace
        back.zPosition = -1
        return back
    }
    
    func runCountDownLabel(time: Int) {
        var countDownLabel: SKLabelNode!
        countDownLabel = SKLabelNode(fontNamed: "Chalkduster")
        countDownLabel.fontSize = 150
        countDownLabel.fontColor = SKColor.red
        countDownLabel.horizontalAlignmentMode = .center
        countDownLabel.position = CGPoint(x: 0, y: 0)
        addChild(countDownLabel)
        var count = time + 1
        let target = 1
        nextIteration()
        func nextIteration(){
            if target != count {
                count -= 1
                countDownLabel.text = "\(count)"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    nextIteration()
                }
            } else {
                countDownLabel.removeFromParent()
            }
        }
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
        let node = atPoint(location) as? SKSpriteNode
        if objects.contains(startLabel) {
            startLabel.isHidden = true
            runCountDownLabel(time: 3)
            var nodes: [String]!
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                nodes = self.makeNodesAndStart()
                self.currentOrderArray = nodes

            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.35) {
                self.animateNodesin(array: nodes)
            }
            
        } else if let object = node {
            let result = recognizeAndTouch(object: object,
                                           orderedNodes: currentOrderArray)
            switch result {
            case true:
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameOverScene = ResultScene(size: self.size, won: true)
                self.view?.presentScene(gameOverScene, transition: reveal)
                guard level <= 5 else { return }
                level += 1
            case false:
                  let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                  let gameOverScene = ResultScene(size: self.size, won: false)
                  self.view?.presentScene(gameOverScene, transition: reveal)
            default:
                break
            }
        }
    }
    
    func recognizeAndTouch(object: SKSpriteNode,
                           orderedNodes: [String]) -> Bool? {
        guard let name = object.name else { return nil }
        print(name)
        guard name == currentOrderArray[comparedCount] else { return false }
        object.run(touchNodeAnimation())
        // Проверь может не нужно добавлять touches
        touchesNodesArray.append(name)
        comparedCount += 1
        guard touchesNodesArray.count == orderedNodes.count else { return nil }
        return  true
    }
    
    func makeNodesAndStart() -> [String] {
        let array = randomNumbersArray
        var gameArray = [String]()
        for item in 0...level + 3 {
            let randomPres = array[item]
            gameArray.append(presidentsArray[randomPres])
            let object = SKSpriteNode(imageNamed: presidentsArray[randomPres])
            object.name = presidentsArray[randomPres]
            object.physicsBody = SKPhysicsBody(circleOfRadius: 125)
            object.size = CGSize(width: 120,
                                 height: 120)
            object.position = CGPoint(x: Int.random(in: -320...320),
                                      y: Int.random(in: -300...300))
            addChild(object)
        }
        print(gameArray)
        return gameArray
    }
    
    func animateNodesin(array: [String]) {
        
        for node in array {
            childNode(withName: node)?.physicsBody?.isDynamic = false
        }
        self.isUserInteractionEnabled = false
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
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(array.count * 1)) {
            self.addChild(self.repeatLbl)
            self.isUserInteractionEnabled = true
        }
        
    }
    
    func touchNodeAnimation() -> SKAction {
        let scaleActionMax = SKAction.scale(to: 2, duration: 0.25)
        let waitAction = SKAction.wait(forDuration: 0.25)
        let scaleActionNorm = SKAction.scale(to: 1, duration: 0.25)
        let sequenceAction = SKAction.sequence([scaleActionMax, waitAction, scaleActionNorm])
        return sequenceAction
    }

}
