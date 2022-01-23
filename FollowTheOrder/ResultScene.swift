//
//  ResultScene.swift
//  FollowTheOrder
//
//  Created by Oleh Study on 22.01.2022.
//

import SpriteKit


class ResultScene: SKScene {
    
    var backActionNode: SKLabelNode!
    var level: Int {
        UserData.shared.level!
    }
    
    init(size: CGSize, won:Bool) {
        super.init(size: size)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        backgroundColor = SKColor.white

        var backMessage = won ? "Next level" : "Try again"
        if level == 5 {
            backMessage = "Start game again"
        }
        let message = "Oooops :[, \nYou stay in Russia"
        let constant: CGFloat = won ? 500 : 200
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 30
        label.preferredMaxLayoutWidth = 600
        label.numberOfLines = 0
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2,
                                 y: size.height - constant)
        
        let gameLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameLabel.text = "Congratulations, \ntake yout GreenCard"
        gameLabel.fontSize = 60
        gameLabel.numberOfLines = 3
        gameLabel.fontColor = SKColor.black
        gameLabel.position = CGPoint(x: size.width/2,
                                 y: size.height - 400)
        
        let greenCard = SKSpriteNode(imageNamed: Images.greenCard.rawValue)
        greenCard.size = CGSize(width: 300,
                                height: 300)
        greenCard.position = CGPoint(x: size.width/2,
                                     y: size.height/2)

        var putinNode = SKSpriteNode(imageNamed: Images.putin.rawValue)
        putinNode.size = CGSize(width: 640,
                                height: 860)
        putinNode.position = CGPoint(x: size.width/2,
                                     y: size.height/2)
        
        switch won {
        case true:
            switch level {
            case 1...4:
                if let  dollarParticles = SKEmitterNode(fileNamed: "DollarParticle") {
                    dollarParticles.position = CGPoint(x: size.width/2 ,
                                                        y: size.height/2 )
                    addChild(dollarParticles)
                }
            case 5:
                addChild(gameLabel)
                addChild(greenCard)
            default:
                break
            }
            NetworkManager.shared.getPrediction { prediction in
                let message = prediction.fortune
                label.text = message
                self.addChild(label)
            }
        case false:
            addChild(label)
            addChild(putinNode)
        }
        backActionNode = SKLabelNode(fontNamed: "Chalkduster")
        backActionNode.text = backMessage
        backActionNode.fontColor = SKColor.black
        backActionNode.fontSize = 70
        backActionNode.zPosition = 1
        backActionNode.position = CGPoint(x: size.width/2,
                                          y: 200)
        addChild(backActionNode)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else  { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        if objects.contains(backActionNode) {
            if let view = self.view as! SKView? {
                if let scene = SKScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    view.presentScene(scene)
                }
            }
        }
    }
}
