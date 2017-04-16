//
//  GamEengine.swift
//  conwaygame
//
//  Created by Eni Sinanaj on 15/04/2017.
//  Copyright © 2017 NewlineCode. All rights reserved.
//

import Foundation

class Engine {
    
    var board: Array<Array<Bool>>
    var gameSettings: GameSettings
    
    init(_ cols: Int,_ rows: Int) {
        board = Array<Any>() as! Array<Array<Bool>>
        
        for _ in 0...rows {
            var rowValues = Array<Bool>()
            for _ in 0...cols {
                rowValues.append(false)
            }
            
            board.append(rowValues)
        }
        
        gameSettings = GameSettings(2, cols: cols, rows: rows)
    }
    
    func switchOnAt(_ x: Int, _ y: Int) {
        board.removeAll()
        
        for rowIndex in 0...gameSettings.rows {
            var rowValues = Array<Bool>()
            for colIndex in 0...gameSettings.cols {
                var value: Bool = false
                if (rowIndex == y && colIndex == x) {
                    value = true
                }
                
                rowValues.append(value)
            }
            
            board.append(rowValues)
        }
    }
    
    func switchOffAt(_ x: Int, _ y: Int) {
        board.removeAll()
        
        for rowIndex in 0...gameSettings.rows {
            var rowValues = Array<Bool>()
            for colIndex in 0...gameSettings.cols {
                var value: Bool = false
                if (rowIndex == y && colIndex == x) {
                    value = false
                }
                
                rowValues.append(value)
            }
            
            board.append(rowValues)
        }
    }
    
    func passGeneration() {
        var newGeneration = Array<Array<Bool>>()
        for rowIndex in 0...gameSettings.rows {
            var rowValues = Array<Bool>()
            for colIndex in 0...gameSettings.cols {
                let value = CellProcessor(board: board, settings: gameSettings).processCellAt(row: rowIndex, col: colIndex)
                rowValues.append(value)
            }
            
            newGeneration.append(rowValues)
        }
        
        board.removeAll()
        board.append(contentsOf: newGeneration)
    }
}
