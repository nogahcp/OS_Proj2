//
//  Card.swift
//  SetGame
//
//  Created by Nogah Melamed Cohen on 10/10/2019.
//  Copyright © 2019 Nogah Melamed Cohen. All rights reserved.
//

import Foundation

class Card: Equatable {
    
    var identifier: Int
    static var runID = 0 //run ID for new cards
    var shape: CardProperty
    var color: CardProperty
    var shapeCount: CardProperty
    var filling: CardProperty
    
    init(shape: CardProperty, color: CardProperty, shapeCount: CardProperty, filling: CardProperty) {
        self.identifier = Card.runID
        Card.runID += 1
        self.shape = shape
        self.color = color
        self.shapeCount = shapeCount
        self.filling = filling
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return (lhs.shape == rhs.shape) && (lhs.color == rhs.color) && (lhs.shapeCount == rhs.shapeCount) && (lhs.filling == rhs.filling)
    }
}

//enum represent if cards on board is choosen, match or mismatch
enum CardState {
    case chosen
    case match
    case mismatch
}

//enum represent card property (shape/color/filling/number)
enum CardProperty: CaseIterable{
    case p1
    case p2
    case p3
}
