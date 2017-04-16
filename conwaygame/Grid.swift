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
    var blockSize:CGFloat!
    var spinnyNode: SKShapeNode?
    
    convenience init?(blockSize:CGFloat, game: Engine) {
        guard let texture = Grid.gridTexture(blockSize: blockSize,
                                             rows: game.gameSettings.rows,
                                             cols: game.gameSettings.cols) else {
            return nil
        }
        
        self.init(texture: texture, color:SKColor.clear, size: texture.size())
        
        self.blockSize = blockSize
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
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image!)
    }
    
    func gridPosition(row:Int, col:Int) -> CGPoint {
        let offset = blockSize / 2.0 + 0.5
        
        let cols = game.gameSettings.cols
        let x = CGFloat(col) * blockSize - (blockSize * CGFloat(cols)) / 2.0 + offset
        
        let rows = game.gameSettings.rows
        let y = CGFloat(rows - row - 1) * blockSize - (blockSize * CGFloat(rows)) / 2.0 + offset
        
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
                let row = Int(floor(x / blockSize))
                let col = Int(floor(y / blockSize))
                addLifeForms(atRow: row, atColumn: col)
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
        }
    }
    
    func addLifeForms(atRow: Int, atColumn: Int) {
        let spinnyNode: SKNode = self.spinnyNode?.copy() as! SKNode
        spinnyNode.position = (self.gridPosition(row: atColumn, col: atRow))
        self.addChild(spinnyNode)
        game.switchOnAt(atColumn, atRow)
    }
    
    func designBoard(board: Array<Array<Bool>>) {
        clearChildren()
        game.passGeneration()
        
        for rowIndex in 0...game.gameSettings.rows {
            for colIndex in 0...game.gameSettings.cols {
                if (game.board[rowIndex][colIndex]) {
                    addLifeForms(atRow: rowIndex, atColumn: colIndex)
                }
            }
        }
    }
    
    func clearChildren() {
        self.removeAllChildren()
    }
}
