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
        
        for _ in 0...rows-1 {
            var rowValues = Array<Bool>()
            for _ in 0...cols-1 {
                rowValues.append(false)
            }
            
            board.append(rowValues)
        }
        
        gameSettings = GameSettings(2, cols: cols, rows: rows)
    }
    
    func switchOnAt(_ x: Int, _ y: Int) {
        board[x][y] = true
        //print(toString(board))
    }
    
    func switchOffAt(_ x: Int, _ y: Int) {
        board[x][y] = false
        //print(toString(board))
    }
    
    func passGeneration() {
        var newGeneration = Array<Array<Bool>>()
        for rowIndex in 0...gameSettings.rows-1 {
            var rowValues = Array<Bool>()
            for colIndex in 0...gameSettings.cols-1 {
                let value = CellProcessor(board: board, settings: gameSettings).processCellAt(row: rowIndex, col: colIndex, value: board[rowIndex][colIndex])
                rowValues.append(value)
            }
            
            newGeneration.append(rowValues)
        }
        
        board.removeAll()
        board.append(contentsOf: newGeneration)
        
        //print(toString(board))
    }
    
    func toString(_ board: Array<Array<Bool>>) -> String {
        var string: String = "_____________________________________\n"
        for rowIndex in 0...gameSettings.rows {
            string = string + "| "
            for colIndex in 0...gameSettings.cols {
                string = string + (board[rowIndex][colIndex] ? "true" : "false") + " |"
            }
            string = string + "\n"
        }
        
        return string
    }
}
