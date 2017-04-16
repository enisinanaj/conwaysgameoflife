//
//  GameSettings.swift
//  conwaygame
//
//  Created by Eni Sinanaj on 16/04/2017.
//  Copyright © 2017 NewlineCode. All rights reserved.
//

import Foundation

class GameSettings {
    
    var iteration: Int
    var iterationSpeed: Int
    var cols: Int
    var rows: Int
    
    init(_ iterationSpeed: Int, cols: Int, rows: Int) {
        self.iteration = 0
        self.iterationSpeed = iterationSpeed
        self.cols = cols
        self.rows = rows
    }
    
    func iterate() {
        self.iteration = self.iteration + 1
    }
    
    func incrementIterationSpeed() {
        self.iterationSpeed = self.iterationSpeed + 1
    }
    
    func decrementIterationSpeed() {
        self.iterationSpeed = self.iterationSpeed - 1
    }
}
