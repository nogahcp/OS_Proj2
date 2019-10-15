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
    //var cardState: CardState
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
        return (lhs.identifier == rhs.identifier)
        //TODO shape, color, filing, count ??
    }
}

//enum represent if card is choosen, notChosen, match or mismatch
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
