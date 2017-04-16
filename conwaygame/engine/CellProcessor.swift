//
//  CellProcessor.swift
//  conwaygame
//
//  Created by Eni Sinanaj on 16/04/2017.
//  Copyright © 2017 NewlineCode. All rights reserved.
//

import Foundation

class CellProcessor {
    
    var gameSettings: GameSettings
    var board = Array<Array<Bool>>()
    var borderingCells = Array<Bool>()
    var originalValue: Bool = false
    
    init(board: Array<Array<Bool>>, settings: GameSettings) {
        self.board = board
        borderingCells = Array<Bool>()
        self.gameSettings = settings
    }
    
    func processCellAt(row: Int, col: Int, value: Bool) -> Bool {
        originalValue = value
        
        let negativeRowIndex = row-1 < 0 ? 0 : row - 1
        let negativeColIndex = col-1 < 0 ? 0 : col - 1
        let positiveRowIndex = row+1 > gameSettings.rows-1 ? gameSettings.rows-1 : row + 1
        let positiveColIndex = col+1 > gameSettings.cols-1 ? gameSettings.cols-1 : col + 1
        
        borderingCells.append(board[negativeRowIndex][col])
        borderingCells.append(board[negativeRowIndex][negativeColIndex])
        borderingCells.append(board[row][negativeColIndex])
        borderingCells.append(board[positiveRowIndex][negativeColIndex])
        borderingCells.append(board[positiveRowIndex][col])
        borderingCells.append(board[positiveRowIndex][positiveColIndex])
        borderingCells.append(board[row][positiveColIndex])
        borderingCells.append(board[negativeRowIndex][positiveColIndex])
        
        return getStatus(countLivingNeighbors())
    }
    
    func countLivingNeighbors() -> Int {
        var result = 0;
        for cell in borderingCells {
            if (cell) {
                result = result + 1
            }
        }
        
        return result
    }
    
    func getStatus(_ neighbors: Int) -> Bool {
        if originalValue {
            return neighbors == 2 || neighbors == 3
        } else if !originalValue {
            return neighbors == 3
        }
        
        return false
    }
}
