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
        let constant: CGFloat = won ? 850 : 200
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
        gameLabel.preferredMaxLayoutWidth = 500
        gameLabel.position = CGPoint(x: size.width/2,
                                 y: size.height - 400)
        
        let greenCard = SKSpriteNode(imageNamed: Images.greenCard.rawValue)
        greenCard.size = CGSize(width: 300,
                                height: 300)
        greenCard.position = CGPoint(x: size.width/2,
                                     y: size.height/2)

        let putinNode = SKSpriteNode(imageNamed: Images.putin.rawValue)
        putinNode.size = CGSize(width: 640,
                                height: 860)
        putinNode.position = CGPoint(x: size.width/2,
                                     y: size.height/2)
        
        let shtamp = SKSpriteNode(imageNamed: Images.shtamp.rawValue)
        shtamp.size = CGSize(width: 3750*1.1,
                             height: 3300*1.1)
        shtamp.position = CGPoint(x: size.width/2,
                                  y: size.height/2 - 100)
        shtamp.zPosition = 1
        
        switch won {
        case true:
            switch level {
            case 1...4:
                AudioPlayer.shared.play(SoundList.win)
                if let  dollarParticles = SKEmitterNode(fileNamed: "DollarParticle") {
                    dollarParticles.position = CGPoint(x: size.width/2 ,
                                                        y: size.height/2 )
                    addChild(dollarParticles)
                    NetworkManager.shared.getPrediction { prediction in
                        let message = prediction.fortune
                        label.text = message
                        self.addChild(label)
                    }
                }
            case 5:
                AudioPlayer.shared.play(SoundList.anthemUSA)
                addChild(gameLabel)
                addChild(greenCard)
                addChild(shtamp)
                shtamp.run(shtampAnimation())
                //
            default:
                break
            }
        case false:
            AudioPlayer.shared.play(SoundList.lose)
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
            AudioPlayer.shared.play(SoundList.click)

            if let view = self.view {
                if let scene = SKScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    view.presentScene(scene)
                }
            }
        }
    }
    func shtampAnimation() -> SKAction {
        let scaleActionMin = SKAction.scale(to: 0.33, duration: 0.5)
        let waitAction = SKAction.wait(forDuration: 0.5)
        let scaleActionNorm = SKAction.scale(to: 1, duration: 2)
        let outPositionAction = SKAction.moveBy(x: 3000, y: -1000, duration: 3)
        let groupOut = SKAction.group([scaleActionNorm, outPositionAction])
        let sequenceAction = SKAction.sequence([scaleActionMin, waitAction, groupOut])
        return sequenceAction
    }
}
