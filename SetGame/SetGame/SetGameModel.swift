//
//  SetGameModel.swift
//  SetGame
//
//  Created by Nogah Melamed Cohen on 10/10/2019.
//  Copyright © 2019 Nogah Melamed Cohen. All rights reserved.
//

import Foundation

struct SetGameModel {
    var stackCards: [Card]
    var cardOnBoard: [Card?]
    var selectedCards: [Card]
    var choosenCardsState: CardState
    
    init() {
        self.stackCards = [Card]()
        self.cardOnBoard = [Card?]()
        self.selectedCards = [Card]()
        self.choosenCardsState = CardState.notChosen
        createStack()
        fillBoard()
    }
    
    //create 81 cards for stack
    mutating func createStack() {
        let propertyValues = CardProperty.allCases
        for color in propertyValues {
            for shape in propertyValues {
                for filling in propertyValues {
                    for shapeCount in propertyValues {
                        let currCard = Card(shape: shape, color: color, shapeCount: shapeCount, filling: filling)
                        self.stackCards.append(currCard)
                    }
                }
            }
        }
    }
    
    //add 12 cards from stack to board
    mutating func fillBoard() {
        for index in 0..<12 {
            self.cardOnBoard.append(self.stackCards.randomElement())
            self.stackCards.remove(element: self.cardOnBoard[index]!)
        }
        
        for _ in 12..<24 {
            self.cardOnBoard.append(nil)
        }
    }
    
//    mutating func cardSelected(cardIndex: Int) {
//        //case1: three card already selected
//        if self.selectedCards.count == 3 {
//            //if set - put new cards
//            if self.choosenCardsState == CardState.match {
//
//            }
//        }
//        //case2: selected card already chosen-unchose
//        else if let index = self.selectedCards.firstIndex(of: self.cardOnBoard[cardIndex]) {
//            self.selectedCards.remove(at: index)
//        }
//        //case3: first/second card selected - add card to selected
//        else if self.selectedCards.count < 2 {
//            self.selectedCards.append(self.cardOnBoard[cardIndex])
//        }
//        //case4: third card selected - add to selected and check if set
//        else if self.selectedCards.count == 2{
//            self.selectedCards.append(self.cardOnBoard[cardIndex])
//            self.isSet()
//        }
//    }
//
//    mutating func isSet() -> Bool{
//        //check color
//        if (self.selectedCards[0].color == self.selectedCards[1].color && self.selectedCards[1].color == self.selectedCards[2].color) || (self.selectedCards[0].color != self.selectedCards[1].color && self.selectedCards[1].color != self.selectedCards[2].color && self.selectedCards[2].color != self.selectedCards[1].color)
//        {
//            //TODO - check shape, number and filling
//            return true
//        }
//        else {
//            return false
//        }
//    }
    
}

//extention - remove element from array
extension Array where Iterator.Element : Equatable {
    mutating func remove(element: Element) {
        if let index = self.firstIndex(of: element)
        {
            self.remove(at: index)
        }
    }
}

