//
//  GameScene.swift
//  Project11
//
//  Created by Falmer nightprowler Fahey on 17/04/2019.
//  Copyright © 2019 School21. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	//MARK: Properties
	var obstacles = [Obstacle]()
	
	var scoreLabel: SKLabelNode!
	let ballColors = ["ballRed", "ballGrey", "ballBlue", "ballCyan", "ballGreen", "ballYellow", "ballPurple"]
	
	var ballCountLabel: SKLabelNode!
	var ballCount = 5 {
		didSet {
			ballCountLabel.text = "Balls: \(ballCount)"
		}
	}
	
	var score = 0 {
		didSet {
			scoreLabel.text = "Score \(score)"
		}
	}
	
	var editLabel: SKLabelNode!
	
	var editingMode: Bool = false {
		didSet {
			if editingMode {
				editLabel.text = "Done"
			} else {
				editLabel.text = "Edit"
			}
		}
	}
	
	//MARK: override methods
	override func didMove(to view: SKView) {
		let background = SKSpriteNode(imageNamed: "background.jpg")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -1
		addChild(background)
		
		makeBouncer(at: CGPoint(x: 0, y: 0))
		makeBouncer(at: CGPoint(x: 256, y: 0))
		makeBouncer(at: CGPoint(x: 512, y: 0))
		makeBouncer(at: CGPoint(x: 768, y: 0))
		makeBouncer(at: CGPoint(x: 1024, y: 0))
		
		makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
		makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
		makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
		makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
		
		physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
		physicsWorld.contactDelegate = self
		
		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.text = "Score: 0"
		scoreLabel.horizontalAlignmentMode = .right
		scoreLabel.position = CGPoint(x: 980, y: 700)
		addChild(scoreLabel)
		
		editLabel = SKLabelNode(fontNamed: "Chalkduster")
		editLabel.text = "Edit"
		editLabel.position = CGPoint(x: 80, y: 700)
		addChild(editLabel)
		
		ballCountLabel = SKLabelNode(fontNamed: "Chalkduster")
		ballCountLabel.text = "Balls: 5"
		ballCountLabel.horizontalAlignmentMode = .right
		ballCountLabel.position = CGPoint(x: 800, y: 700)
		addChild(ballCountLabel)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		if let touch = touches.first {
			let location = touch.location(in: self)
			
			let object = nodes(at: location)
			
			if object.contains(editLabel) {
				editingMode = !editingMode
			} else {
				if editingMode {
					makeObstacle(at: location)
				} else {
					makeBall(at: location)
				}
			}
		}
	}
	
	func makeObstacle(at location: CGPoint) {
		let size = CGSize(width: Int(arc4random_uniform(112) + 16), height: 16)
		let box = SKSpriteNode(color: UIColor(red: CGFloat(Float(arc4random()) / Float(UINT32_MAX)),
											  green: CGFloat(Float(arc4random()) / Float(UINT32_MAX)),
											  blue: CGFloat(Float(arc4random()) / Float(UINT32_MAX)),
											  alpha: 1 ),
							   size: size)
		box.zRotation = CGFloat((Float)(arc4random_uniform(4)))
		box.position = location
		
		box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
		box.physicsBody?.isDynamic = false
		box.name = "Obst:\(location.x),\(location.y)"
		obstacles.append(Obstacle(obstacle: box))
		
		addChild(box)
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		guard let nodeA = contact.bodyA.node else { return }
		guard let nodeB = contact.bodyB.node else { return }
		
		if nodeA.name == "ball" {
			collisionBetween(ball: nodeA, object: nodeB)
		} else if nodeB.name == "ball" {
			collisionBetween(ball: nodeB, object: nodeA)
		}
	}
	
	//MARK: private methods
	func makeBall(at location: CGPoint) {
		
		if location.y < 600 || ballCount == 0 { return }
		
		let colorIndex = Int(arc4random_uniform(UInt32(ballColors.count)))
		let color = ballColors[colorIndex]
		
		let ball = SKSpriteNode(imageNamed: "\(color)")
		ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
		ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
		ball.physicsBody?.restitution = 0.4
		ball.position = location
		ball.name = "ball"
		ballCount -= 1
		addChild(ball)
	}
	
	func makeBouncer(at position: CGPoint) {
		
		let bouncer = SKSpriteNode(imageNamed: "bouncer")
		bouncer.position = position
		bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
		bouncer.physicsBody?.isDynamic = false
		addChild(bouncer)
	}
	
	func makeSlot(at position: CGPoint, isGood: Bool) {
		var slotBase: SKSpriteNode
		var slotGlow: SKSpriteNode
		
		if isGood {
			slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
			slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
			slotBase.name = "good"
		} else {
			slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
			slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
			slotBase.name = "bad"
		}
		
		slotBase.position = position
		slotGlow.position = position
		
		slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
		slotBase.physicsBody?.isDynamic = false
		
		addChild(slotBase)
		addChild(slotGlow)
		
		let spin = SKAction.rotate(byAngle: .pi, duration: 10)
		let spinForever = SKAction.repeatForever(spin)
		slotGlow.run(spinForever)
	}
	
	func collisionBetween(ball: SKNode, object: SKNode) {
		if object.name == "good" {
			destroy(ball: ball)
			score += 1
			ballCount += 1
		} else if object.name == "bad" {
			destroy(ball: ball)
			score -= 1
		} else if let obj = findObstacle(object) {
			obj.live -= 1
			if obj.live == 0 {
				if let index = obstacles.index(of: obj) {
					obstacles.remove(at: index)
					object.removeFromParent()
				}
			}
		}
	}
	
	func destroy(ball: SKNode) {
		if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
			fireParticles.position = ball.position
			addChild(fireParticles)
		}
		
		ball.removeFromParent()
	}
	func findObstacle(_ node: SKNode) -> Obstacle? {
		for obstacle in obstacles {
			if obstacle.obstacle.name == node.name {
				return obstacle
			}
		}
		return nil
	}
}
