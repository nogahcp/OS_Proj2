//
//  SetGameTests.swift
//  SetGameTests
//
//  Created by Nogah Melamed Cohen on 15/10/2019.
//  Copyright © 2019 Nogah Melamed Cohen. All rights reserved.
//

import XCTest
@testable import SetGame

class SetGameTests: XCTestCase {
    
    var setGame = SetGameModel()
    
    override func setUp() {
        setGame = SetGameModel()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //check if after fill board (in init) 12 cards are on board and 69 on stack
    func testFillBoard() {
        let countOnStack = setGame.stackCards.count
        let countOnBoard = setGame.countCardsOnBoard
        XCTAssert(countOnBoard == 12 && countOnStack == 69)
    }
    
    //check if afted cardSelected card is in selected array
    func testCardSelected() {
        setGame.cardSelected(cardIndex: 0)
        XCTAssert(setGame.selectedCards.contains(setGame.cardOnBoard[0]))
    }
    
    //check if afted cardSelected twice card is not in selected array
    func testCardDeselect() {
        setGame.cardSelected(cardIndex: 0)
        setGame.cardSelected(cardIndex: 0)
        XCTAssert(!setGame.selectedCards.contains(setGame.cardOnBoard[0]))
    }
    
    //after adding 3 cards stack with 66 cards and board with 15
    func testAddThreeCards() {
        setGame.addThreeCardsButtonPressed()
        let countOnStack = setGame.stackCards.count
        let countOnBoard = setGame.countCardsOnBoard
        XCTAssert(countOnBoard == 15 && countOnStack == 66)
    }
    
    //after 4 times adding cards board should be filled
    func testFillAllBoard() {
        setGame.addThreeCardsButtonPressed()
        setGame.addThreeCardsButtonPressed()
        setGame.addThreeCardsButtonPressed()
        setGame.addThreeCardsButtonPressed()
        let countOnStack = setGame.stackCards.count
        let countOnBoard = setGame.countCardsOnBoard
        XCTAssert(countOnBoard == 24 && countOnStack == 57)
    }
    
    //after selecting 4 different cards, selectedCards contains only the last card added
    func testSelectFourCards() {
        setGame.cardSelected(cardIndex: 0)
        setGame.cardSelected(cardIndex: 1)
        setGame.cardSelected(cardIndex: 2)
        setGame.cardSelected(cardIndex: 3)
        XCTAssert(setGame.selectedCards.count == 1 && setGame.selectedCards.contains(setGame.cardOnBoard[3]))
    }
    
    //not set by shape
    func testCardCompare1() {
        let card1 = Card(shape: .p1, color: .p1, shapeCount: .p1, filling: .p1)
        let card2 = Card(shape: .p2, color: .p2, shapeCount: .p2, filling: .p2)
        let card3 = Card(shape: .p1, color: .p3, shapeCount: .p3, filling: .p3)
        self.setGame.selectedCards.append(card1)
        self.setGame.selectedCards.append(card2)
        self.setGame.selectedCards.append(card3)
        XCTAssertEqual(setGame.isSet(), false)
    }

    //not set by color
    func testCardCompare2() {
        let card1 = Card(shape: .p1, color: .p1, shapeCount: .p1, filling: .p1)
        let card2 = Card(shape: .p1, color: .p2, shapeCount: .p2, filling: .p2)
        let card3 = Card(shape: .p1, color: .p1, shapeCount: .p3, filling: .p3)
        self.setGame.selectedCards.append(card1)
        self.setGame.selectedCards.append(card2)
        self.setGame.selectedCards.append(card3)
        XCTAssertEqual(setGame.isSet(), false)
    }
    //not set by shape count
    func testCardCompare3() {
        let card1 = Card(shape: .p1, color: .p1, shapeCount: .p1, filling: .p1)
        let card2 = Card(shape: .p2, color: .p2, shapeCount: .p1, filling: .p2)
        let card3 = Card(shape: .p3, color: .p3, shapeCount: .p3, filling: .p3)
        self.setGame.selectedCards.append(card1)
        self.setGame.selectedCards.append(card2)
        self.setGame.selectedCards.append(card3)
        XCTAssertEqual(setGame.isSet(), false)
    }
    //not set by filling
    func testCardCompare4() {
        let card1 = Card(shape: .p1, color: .p1, shapeCount: .p1, filling: .p1)
        let card2 = Card(shape: .p1, color: .p2, shapeCount: .p2, filling: .p1)
        let card3 = Card(shape: .p1, color: .p3, shapeCount: .p3, filling: .p3)
        self.setGame.selectedCards.append(card1)
        self.setGame.selectedCards.append(card2)
        self.setGame.selectedCards.append(card3)
        XCTAssertEqual(setGame.isSet(), false)
    }
    //set
    func testCardCompare5() {
        let card1 = Card(shape: .p1, color: .p1, shapeCount: .p1, filling: .p3)
        let card2 = Card(shape: .p1, color: .p2, shapeCount: .p2, filling: .p3)
        let card3 = Card(shape: .p1, color: .p3, shapeCount: .p3, filling: .p3)
        self.setGame.selectedCards.append(card1)
        self.setGame.selectedCards.append(card2)
        self.setGame.selectedCards.append(card3)
        XCTAssertEqual(setGame.isSet(), true)
    }
    
    //check if given hint is true
    func testHint() {
        let setOfCards = setGame.getHint()
        if setOfCards != nil {
            setGame.cardSelected(cardIndex: setOfCards!.0)
            setGame.cardSelected(cardIndex: setOfCards!.1)
            setGame.cardSelected(cardIndex: setOfCards!.2)
            XCTAssert(setGame.isSet())
        }
        XCTAssert(true)
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
