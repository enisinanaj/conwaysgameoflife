//
//  GameScene.swift
//  conwaygame
//
//  Created by Eni Sinanaj on 15/04/2017.
//  Copyright © 2017 NewlineCode. All rights reserved.
//

import SpriteKit
import GameplayKit
import GoogleMobileAds

class Playground: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String: GKGraph]()
    private var columnsInGrid: Int = 40
    private var rowsInGrid: Int = 20
    private var menuHeight: Int = 50
    private var offset: CGFloat?
    private var game: Engine?
    private var grid: Grid?
    private var lastUpdateTime: TimeInterval = 0
    private var isPlaying:Bool = false
    private var timer: Timer?
    
    var rootViewController: GameViewController?
    var interstitial: GADInterstitial!
    
    private var rectSize: CGSize?
    
    override func sceneDidLoad() {
        self.name = "Playground"
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        calculateGridParams()
        game = Engine(columnsInGrid, rowsInGrid)
        grid = Grid(blockSize: CGFloat((GameSettings.blockSize)), game: game!)
        grid?.name = "GameGrid"
        grid?.position = CGPoint (x:frame.midX, y: CGFloat(offset!))
        grid?.isUserInteractionEnabled = true
        
        addMenu()
        addChild(grid!)
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-6514681921761516/3323322983")
        interstitial.load(GADRequest())
    }
    
    func addMenu() {
        let menu = SKSpriteNode()
        menu.color = UIColor(displayP3Red: 0.8, green: 0.8, blue: 0.8, alpha: 0.3)
        menu.size = CGSize(width: self.frame.width, height: CGFloat(menuHeight))
        menu.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        menu.name = "menuContainer"
        menu.position.x = 0
        menu.position.y = 0
        menu.zPosition = 99
        
        let playButton = SKSpriteNode(imageNamed: "Play")
        playButton.name = "playGameNode"
        playButton.size = CGSize(width: 30.0, height: 30.0)
        playButton.position.x = self.frame.size.width - 100
        playButton.position.y = 25
        playButton.zPosition = 101
        
        let stopButton = SKSpriteNode(imageNamed: "Stop")//"StopDisabled")
        stopButton.name = "stopGameNode"
        stopButton.size = CGSize(width: 30.0, height: 30.0)
        stopButton.position.x = self.frame.size.width - 65
        stopButton.position.y = 25
        stopButton.zPosition = 101
        
        let speedUpButton = SKSpriteNode(imageNamed: "SpeedUp")
        speedUpButton.name = "speedGameNode"
        speedUpButton.size = CGSize(width: 30.0, height: 30.0)
        speedUpButton.position.x = self.frame.size.width - 30
        speedUpButton.position.y = 25
        speedUpButton.zPosition = 101
        
        let menuButton = SKSpriteNode(imageNamed: "Menu")
        menuButton.name = "backToMenuGameNode"
        menuButton.size = CGSize(width: 60.0, height: 30.0)
        menuButton.position.x = 50
        menuButton.position.y = 25
        menuButton.zPosition = 101
        
        let generationLabel = SKLabelNode()
        generationLabel.name = "generationLabel"
        generationLabel.position.x = 420
        generationLabel.position.y = 19
        generationLabel.fontColor = UIColor.black
        generationLabel.fontSize = 16
        generationLabel.zPosition = 101
        
        let speedLabel = SKLabelNode()
        speedLabel.name = "speedLabel"
        speedLabel.position.x = 230
        speedLabel.position.y = 19
        speedLabel.fontColor = UIColor.black
        speedLabel.fontSize = 16
        speedLabel.zPosition = 101
        
        addChild(playButton)
        addChild(stopButton)
        addChild(speedUpButton)
        addChild(generationLabel)
        addChild(speedLabel)
        addChild(menuButton)
        addChild(menu)
    }
    
    func calculateGridParams() {
        let width = self.frame.size.width //UIScreen.main.fixedCoordinateSpace.bounds.width * 1.9
        let height = self.frame.size.height //UIScreen.main.fixedCoordinateSpace.bounds.height / 1.5
        
        rectSize = CGSize(width: width, height: height)
        
        columnsInGrid = Int(width / CGFloat((GameSettings.blockSize)))
        rowsInGrid = Int((height - CGFloat(menuHeight)) / CGFloat(GameSettings.blockSize))
        
        let gridSize = (CGFloat(rowsInGrid)*CGFloat(GameSettings.blockSize))
        offset = (height - CGFloat(menuHeight)) - gridSize
        offset = (offset! / CGFloat(2)) + CGFloat(menuHeight) + (gridSize / CGFloat(2))
        
        print("frame width: " + String(describing: self.frame.size.width))
        print("frame height: " + String(describing: self.frame.size.height))
        print("uiscreen width: " + String(describing: UIScreen.main.bounds.width))
        print("uiscreen height: " + String(describing: UIScreen.main.bounds.height))
        print("rowsInGrid: " + String(rowsInGrid))
        print("offset height: " + String(describing: offset!))
        print("columnsInGrid: " + String(columnsInGrid))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let position = t.location(in:self)
            let node = atPoint(position)
            if node.name == "backToMenuGameNode" {
                rootViewController!.reloadBanner()
                presentInterstitial()
                self.presentMainMenu()
            }
            
            if node.name == "speedGameNode" {
                self.incrementGameSpeed()
            }
            
            if node.name == "stopGameNode" {
                stopGame(stopGenerationCount: true)
            }
            
            if node.name == "playGameNode" {
                startLife(firstGenerationStart: true)
            }
            
            print("touched node in playground: " + (node.name)!)
        }
    }
    
    func presentInterstitial() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self.rootViewController!)
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
    
    func startLife(firstGenerationStart: Bool) {
        if (firstGenerationStart) {
            let playNode = self.childNode(withName: "//playGameNode") as? SKSpriteNode
            playNode?.texture = SKTexture(imageNamed: "PlayDisabled")
        
            let pauseNode = self.childNode(withName: "//stopGameNode") as? SKSpriteNode
            pauseNode?.texture = SKTexture(image: UIImage(named: "Stop")!)
            
            updateSpeedLabel()
        }
        
        if !isPlaying {
            timer = Timer.scheduledTimer(
                timeInterval: 1 / Double((game?.gameSettings.iterationSpeed)!),
                target: self, selector: #selector(Playground.updateGrid),
                userInfo: nil,
                repeats: true
            )
        }
    }
    
    func incrementGameSpeed() {
        game?.gameSettings.incrementIterationSpeed()
        updateSpeedLabel()
        
        if isPlaying {
            stopGame(stopGenerationCount: false)
            startLife(firstGenerationStart: false)
        }
    }
    
    func updateSpeedLabel() {
        if let gameIterationSpeed = game?.gameSettings.iterationSpeed {
            let speedLabel = self.childNode(withName: "//speedLabel") as? SKLabelNode
            speedLabel?.text = "Speed: " + String(describing: gameIterationSpeed) + " generations per second."
        }
    }
    
    @objc func updateGrid() {
        isPlaying = true
        game?.gameSettings.iterate(label: self.childNode(withName: "//generationLabel") as! SKLabelNode)
        grid?.designBoard(board: (game?.board)!)
    }
    
    func stopGame(stopGenerationCount: Bool) {
        isPlaying = false
        timer?.invalidate()
        
        if stopGenerationCount {
            let pauseNode = self.childNode(withName: "stopGameNode") as? SKSpriteNode
            pauseNode?.texture = SKTexture(imageNamed: "StopDisabled")
        
            let playNode = self.childNode(withName: "playGameNode") as? SKSpriteNode
            playNode?.texture = SKTexture(imageNamed: "Play")
        
            game?.gameSettings.iteration = 0
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
