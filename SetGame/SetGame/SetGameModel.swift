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
    var cardOnBoard: [Card]
    var selectedCards: [Card]
    var score = 0
    var choosenCardsState = CardState.chosen

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
        self.cardOnBoard = [Card]()
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
            self.cardOnBoard.append(self.stackCards.randomElement()!)
            self.stackCards.remove(element: self.cardOnBoard[index])
        }
    }
    
    mutating func cardSelected(cardIndex: Int) {
        //if card selected not on board
        guard cardIndex < self.cardOnBoard.count else {
            print("ERROR: \(cardIndex) is out of range index in cardOnBoard")
            return
        }
        let currCard = self.cardOnBoard[cardIndex]
        //deselect card
        if self.selectedCards.contains(currCard) && self.selectedCards.count < 3 {
            self.deselectCard(currCard: currCard)
        }
        //new card selected
        else if self.selectedCards.count < 3 {
            self.selectedNewCard(currCard: currCard)
        }
        //new set start when 3 cards already selected
        else if self.selectedCards.count == 3 {
            self.startNewSetSelection(currCard: currCard)
        }
        
    }
    
    mutating private func deselectCard(currCard: Card) {
        self.selectedCards.remove(element: currCard)
        self.choosenCardsState = CardState.chosen
        self.score -= 1
    }
    
    mutating private func selectedNewCard(currCard: Card) {
        self.selectedCards.append(currCard)
        if self.selectedCards.count == 3 {
            if self.isSet() {
                self.score += 3
                self.choosenCardsState = CardState.match
            }
            else {
                self.score -= 5
                self.choosenCardsState = CardState.mismatch
            }
        }
    }

    mutating private func startNewSetSelection(currCard: Card) {
        //if selected cards were set - add new cards from stack to board
        if self.choosenCardsState == CardState.match {
            var tempSelected = [Card]()
            //if currCard is in selected no need to select it again (part of complete set)
            if !self.selectedCards.contains(currCard) {
                tempSelected.append(currCard)
            }
            self.clearSelectedSet()
            self.selectedCards = tempSelected
            self.addCardsToBoard()
        }
        //last set was not a match - choose new cards
        else {
            self.selectedCards = [Card]()
            self.selectedCards.append(currCard)
        }
        //update cards state
        self.choosenCardsState = .chosen
    }
    
    //add random 3 cards from stack to board
    mutating private func addCardsToBoard() {
        var countAddedCards = 0
        while self.stackCards.count > 0 && countAddedCards < 3 {
            let card = self.stackCards.randomElement()!
            self.cardOnBoard.append(card)
            self.stackCards.remove(element: card)
            countAddedCards += 1
        }
    }
    
    //check if selected cards are set -> replace them, else add three cards
    mutating func addThreeCardsButtonPressed() {
        self.clearSelectedSet()
        self.addCardsToBoard()
    }
    
    //if choosen cards are set - clear selected and change state to chosen
    private mutating func clearSelectedSet() {
        if self.choosenCardsState == CardState.match {
            for card in self.selectedCards {
                self.cardOnBoard.remove(element: card)
            }
            self.selectedCards = [Card]()
            self.choosenCardsState = .chosen
        }
    }
    
    func isSet() -> Bool {
        return compareCardsValues(by: {
            let b1 = ($0 == $1 && $1 == $2)
            let b2 = ($0 != $1 && $1 != $2 && $2 != $0)
            return b1 || b2 })
        //return compareCardsValues(by: { _,_,_ in return true })
    }
    
    //compare all selected cards attributes (color, filling, shape, shapeCount) by boolean comparison function
    private func compareCardsValues(by comparison: (CardProperty, CardProperty, CardProperty) -> Bool) -> Bool {
        return comparison(self.selectedCards[0].color, self.selectedCards[1].color, self.selectedCards[2].color) &&
            comparison(self.selectedCards[0].filling, self.selectedCards[1].filling, self.selectedCards[2].filling) &&
            comparison(self.selectedCards[0].shape, self.selectedCards[1].shape, self.selectedCards[2].shape) &&
            comparison(self.selectedCards[0].shapeCount, self.selectedCards[1].shapeCount, self.selectedCards[2].shapeCount)
    }
    
    //return 2 indexes of existing set, or nil if not exist
    mutating func getHint() -> (Int, Int)? {
        //if selected card already a match - first replace selected cards
        if self.choosenCardsState == .match {
            self.clearSelectedSet()
            self.addCardsToBoard()
        }
        //reduce score by one
        self.score -= 1
        return self.findSet()
    }
    
    //return 2 indexes of existing set, or nil if not exist
    private func findSet() -> (Int, Int)? {
        for var i in 0..<cardOnBoard.count {
            for var j in i+1..<cardOnBoard.count {
                if thirdCardForSetExist(index1: i, index2: j) != nil {
                    return (i, j)
                }
            }
        }
        return nil
    }
    
    //check if board have third card to complete the given 2 cards to a set
    func thirdCardForSetExist(index1: Int, index2: Int) -> Card? {
        let card1 = self.cardOnBoard[index1]
        let card2 = self.cardOnBoard[index2]
        //if cards are nill print error
        guard card1 != nil && card2 != nil else {
            return nil
        }
        //create complete card for set
        let shape = thirdPropertyForSet(prop1: card1.shape, prop2: card2.shape)
        let color = thirdPropertyForSet(prop1: card1.color, prop2: card2.color)
        let shapeCount = thirdPropertyForSet(prop1: card1.shapeCount, prop2: card2.shapeCount)
        let filling = thirdPropertyForSet(prop1: card1.filling, prop2: card2.filling)
        let card3 = Card(shape: shape, color: color, shapeCount: shapeCount, filling: filling)
        
        return self.cardOnBoard.contains(card3) ? card3 : nil
    }
    
    //return third property for given 2 to complete a set
    private func thirdPropertyForSet(prop1: CardProperty, prop2: CardProperty) -> CardProperty
    {
        //return the same property for "same" set
        if prop1 == prop2 {
            return prop1
        }
        //find the third property for "different" set
        else {
            let propertyValues = CardProperty.allCases
            for p in propertyValues {
                if p != prop1 && p != prop2 {
                    return p
                }
            }
        }
        return prop1
    }
    
    //shuffle cards on board
    public mutating func shuffleCards() {
        var tempCards: [Card] = []
        while self.cardOnBoard.count > 0 {
            //get random card and insert to temp list
            let card = self.cardOnBoard.randomElement()
            tempCards.append(card!)
            self.cardOnBoard.remove(element: card!)
        }
        self.cardOnBoard = tempCards
    }
    
}


//extention - remove element from array
extension Array where Iterator.Element : Equatable {
    mutating func remove(element: Element) {
        if let index = self.firstIndex(of: element) {
            self.remove(at: index)
        }
    }
}

