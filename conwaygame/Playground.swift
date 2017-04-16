//
//  GameScene.swift
//  conwaygame
//
//  Created by Eni Sinanaj on 15/04/2017.
//  Copyright © 2017 NewlineCode. All rights reserved.
//

import SpriteKit
import GameplayKit

class Playground: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String: GKGraph]()
    private var columnsInGrid: Int = 40
    private var rowsInGrid: Int = 20
    private var game: Engine?
    private var grid: Grid?
    private var lastUpdateTime: TimeInterval = 0
    
    override func sceneDidLoad() {
        self.name = "Playground"
        
        calculateGridParams()
        game = Engine(columnsInGrid, rowsInGrid)
        grid = Grid(blockSize: 40.0, game: game!)
        grid?.name = "GameGrid"
        
        grid?.position = CGPoint (x:frame.midX + 30, y:frame.midY)
        grid?.isUserInteractionEnabled = true
        addChild(grid!)
    }
    
    func calculateGridParams() {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        columnsInGrid = Int(width / 40) - 2
        rowsInGrid = Int(height / 40) - 1
        
        print("rowsInGrid: " + String(rowsInGrid))
        print("columnsInGrid: " + String(columnsInGrid))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let position = t.location(in:self)
            let node = atPoint(position)
            if node.name == "backToMenuGameNode" {
                self.presentMainMenu()
            }
            
            if node.name == "speedIncrementGameNode" {
                self.incrementGameSpeed()
            }
            
            if node.name == "speedReduxGameNode" {
                self.decrementGameSpeed()
            }
            
            if node.name == "playGameNode" {
                self.updateGrid()
            }
            
            print("touched node in playground: " + (node.name)!)
        }
    }
    
    func presentMainMenu() {
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                let reveal = SKTransition.push(with: .right, duration: 0.8) //flipHorizontal(withDuration: 0.5)
                let scene = sceneNode //(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
        }
    }
    
    func incrementGameSpeed() {
        game?.gameSettings.incrementIterationSpeed()
        updateSpeedLabel()
    }
    
    func decrementGameSpeed() {
        game?.gameSettings.decrementIterationSpeed()
        updateSpeedLabel()
    }
    
    func updateSpeedLabel() {
        let speedLabel = self.childNode(withName: "//speedGameNode") as? SKLabelNode
        
        print(String(describing: game?.gameSettings.iterationSpeed))
        speedLabel?.text = String(describing: (game?.gameSettings.iterationSpeed)!)
    }
    
    func updateGrid() {
        grid?.designBoard(board: (game?.board)!)
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
