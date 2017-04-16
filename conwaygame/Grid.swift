//
//  Grid.swift
//  conwaygame
//
//  Created by Eni Sinanaj on 15/04/2017.
//  Copyright © 2017 NewlineCode. All rights reserved.
//

import SpriteKit
import GameplayKit

class Grid: SKSpriteNode {
    var game: Engine!
    var spinnyNode: SKShapeNode?
    var currentSpinnyNode: SKShapeNode?
    
    convenience init?(blockSize:CGFloat, game: Engine) {
        guard let texture = Grid.gridTexture(blockSize: blockSize,
                                             rows: game.gameSettings.rows,
                                             cols: game.gameSettings.cols) else {
            return nil
        }
        
        self.init(texture: texture, color:SKColor.clear, size: texture.size())
        
        self.game = game
        initLifeForm()
    }
    
    class func gridTexture(blockSize:CGFloat,rows:Int,cols:Int) -> SKTexture? {
        // Add 1 to the height and width to ensure the borders are within the sprite
        let size = CGSize(width: CGFloat(cols)*blockSize+1.0, height: CGFloat(rows)*blockSize+1.0)
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        let bezierPath = UIBezierPath()
        let offset:CGFloat = 0.5
        
        // Draw vertical lines
        for i in 0...cols {
            let x = CGFloat(i)*blockSize + offset
            bezierPath.move(to: CGPoint(x: x, y: 0))
            bezierPath.addLine(to: CGPoint(x: x, y: size.height))
        }
        
        // Draw horizontal lines
        for i in 0...rows {
            let y = CGFloat(i)*blockSize + offset
            bezierPath.move(to: CGPoint(x: 0, y: y))
            bezierPath.addLine(to: CGPoint(x: size.width, y: y))
        }
        
        SKColor.white.setStroke()
        bezierPath.lineWidth = 1.0
        bezierPath.stroke()
        context.addPath(bezierPath.cgPath)
        context.setStrokeColor(UIColor(colorLiteralRed: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image!)
    }
    
    func gridPosition(row:Int, col:Int) -> CGPoint {
        let offset = Double(GameSettings.blockSize) / 2.0 + 0.5
        
        let cols = game.gameSettings.cols
        let x = CGFloat(col) * CGFloat(GameSettings.blockSize) - (CGFloat(GameSettings.blockSize) * CGFloat(cols)) / CGFloat(2.0) + CGFloat(offset)
        
        let rows = game.gameSettings.rows
        let y = CGFloat(rows - row - 1) * CGFloat(GameSettings.blockSize) - (CGFloat(GameSettings.blockSize) * CGFloat(rows)) / CGFloat(2.0) + CGFloat(offset)
        
        return CGPoint(x:x, y:y)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in:self)
            let node = atPoint(position)
            if node != self {
//                let action = SKAction.rotate(by:CGFloat.pi*2, duration: 1)
//                node.run(action)
            }
            else {
                let x = size.width / 2 + position.x
                let y = size.height / 2 - position.y
                let col = Int(floor(x / CGFloat(GameSettings.blockSize)))
                let row = Int(floor(y / CGFloat(GameSettings.blockSize)))
                addLifeForms(atRow: row, atColumn: col)
                game.switchOnAt(row, col)
                print("\(row) \(col)")
            }
            
            print("touch listened in grid")
        }
    }
    
    func initLifeForm() {
        //Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.015
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.0
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.position = (self.gridPosition(row: 0, col: 0))
            spinnyNode.strokeColor = generateRandomColor()
        }
    }
    
    func addLifeForms(atRow: Int, atColumn: Int) {
        currentSpinnyNode = self.spinnyNode?.copy() as? SKShapeNode
        currentSpinnyNode?.position = (self.gridPosition(row: atRow, col: atColumn))
        currentSpinnyNode?.strokeColor = generateRandomColor()
        currentSpinnyNode?.fillColor = (currentSpinnyNode?.strokeColor)!
        self.addChild((currentSpinnyNode)!)
    }
    
    func designBoard(board: Array<Array<Bool>>) {
        clearChildren()
        game.passGeneration()
        
        for rowIndex in 0...game.gameSettings.rows-1 {
            for colIndex in 0...game.gameSettings.cols-1 {
                if (game.board[rowIndex][colIndex]) {
                    addLifeForms(atRow: rowIndex, atColumn: colIndex)
                }
            }
        }
    }
    
    func clearChildren() {
        self.removeAllChildren()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        //currentSpinnyNode?.strokeColor = SKColor.green
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        //currentSpinnyNode?.strokeColor = SKColor.blue
    }
    
    func touchUp(atPoint pos : CGPoint) {
        //currentSpinnyNode?.strokeColor = SKColor.red
    }
    
    func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
