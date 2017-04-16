//
//  GameScene.swift
//  conwaygame
//
//  Created by Eni Sinanaj on 15/04/2017.
//  Copyright © 2017 NewlineCode. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var spinnyNode : SKShapeNode?

    override func sceneDidLoad() {
        self.name = "GameScene"
        self.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in:self)
            let node = atPoint(position)
            if node.name == "startGameNode" {
                print("starting game...")
                openPlayground()
            }
            
            print("touched node is: " + (node.name)!)
        }
        
        //startGameNode
    }
    
    func openPlayground() {
        if let scene = GKScene(fileNamed: "Playground") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! Playground? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                let reveal = SKTransition.push(with: .left, duration: 0.8) //flipHorizontal(withDuration: 0.5)
                let scene = sceneNode //(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
