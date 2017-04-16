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
    
    init(board: Array<Array<Bool>>, settings: GameSettings) {
        self.board = board
        borderingCells = Array<Bool>()
        self.gameSettings = settings
    }
    
    func processCellAt(row: Int, col: Int) -> Bool {
        let negativeRowIndex = row-1 < 0 ? 0 : row - 1
        let negativeColIndex = col-1 < 0 ? 0 : col - 1
        let positiveRowIndex = row+1 > gameSettings.rows-1 ? gameSettings.rows : row + 1
        let positiveColIndex = col+1 > gameSettings.cols-1 ? gameSettings.cols : col + 1
        
        borderingCells.append(board[negativeRowIndex][col])
        borderingCells.append(board[negativeRowIndex][negativeColIndex])
        borderingCells.append(board[row][negativeColIndex])
        borderingCells.append(board[positiveRowIndex][negativeColIndex])
        borderingCells.append(board[positiveRowIndex][col])
        borderingCells.append(board[positiveRowIndex][positiveColIndex])
        borderingCells.append(board[row][positiveColIndex])
        borderingCells.append(board[negativeRowIndex][positiveColIndex])
        
        return countLivingNeighbors() == 2
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
}
