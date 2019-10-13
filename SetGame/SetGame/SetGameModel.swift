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
    var choosenCardsState: CardState {
        get {
            if self.selectedCards.count < 3 {
                return CardState.chosen
            }
            else if self.isSet() {
                return CardState.match
            }
            else {
                return CardState.mismatch
            }
        }
    }
    var countCardsOnBoard: Int {
        get {
            var res = 0
            for card in self.cardOnBoard {
                if card != nil {
                    res += 1
                }
            }
            return res
        }
    }
    
    init() {
        self.stackCards = [Card]()
        self.cardOnBoard = [Card?]()
        self.selectedCards = [Card]()
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
    
    mutating func cardSelected(cardIndex: Int) {
        if let currCard = self.cardOnBoard[cardIndex] {
            //deselect card
            if self.selectedCards.contains(currCard) && self.selectedCards.count < 3 {
                self.selectedCards.remove(element: currCard)
            }
            //new card selected
            else if self.selectedCards.count < 3 {
                self.selectedCards.append(currCard)
            }
            //new set start
            else if self.selectedCards.count == 3 {
                //add new cards from stack to board
                if self.choosenCardsState == CardState.match {
                    for card in self.selectedCards {
                        if let index = self.cardOnBoard.firstIndex(of: card) {
                            self.cardOnBoard[index] = nil
                        }
                    }
                    self.selectedCards = [Card]()
                    self.addCardsToBoard()
                    
                    if !self.selectedCards.contains(currCard) {
                        self.selectedCards.append(currCard)
                    }
                }
                //choose new cards
                else {
                    self.selectedCards = [Card]()
                    self.selectedCards.append(currCard)
                }
            }
        }
    }

    //add random 3 cards from stack to board
    mutating private func addCardsToBoard() {
        var countAddedCards = 0
        if self.stackCards.count > 0 {
            for index in self.cardOnBoard.indices {
                if self.cardOnBoard[index] == nil {
                    self.cardOnBoard[index] = self.stackCards.randomElement()
                    self.stackCards.remove(element: self.cardOnBoard[index]!)
                    countAddedCards += 1
                }
                if countAddedCards == 3 {
                    break
                }
            }
        }
    }
    
    //check if selected cards are set -> replace them, else add three cards
    mutating func addThreeCardsButtonPressed() {
        if self.choosenCardsState == CardState.match {
            for card in self.selectedCards {
                if let index = self.cardOnBoard.firstIndex(of: card) {
                    self.cardOnBoard[index] = nil
                }
            }
            self.selectedCards = [Card]()
        }
        self.addCardsToBoard()
    }
    
    private func isSet() -> Bool{
        //check all attributes using checkAttributeForSet function
        if self.checkAttributeForSet(value1: self.selectedCards[0].color, value2: self.selectedCards[1].color, value3: self.selectedCards[2].color),
            self.checkAttributeForSet(value1: self.selectedCards[0].filling, value2: self.selectedCards[1].filling, value3: self.selectedCards[2].filling),
            self.checkAttributeForSet(value1: self.selectedCards[0].shape, value2: self.selectedCards[1].shape, value3: self.selectedCards[2].shape),
            self.checkAttributeForSet(value1:self.selectedCards[0].shapeCount, value2: self.selectedCards[1].shapeCount, value3: self.selectedCards[2].shapeCount)
        {
            return true
        }
        else {
            return false
        }
    }
    
    private func checkAttributeForSet(value1: CardProperty, value2: CardProperty, value3: CardProperty) -> Bool {
        return (value1 == value2 && value2 == value3) || (value1 != value2 && value2 != value3 && value3 != value2)
    }
    
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

