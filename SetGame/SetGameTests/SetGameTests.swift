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

    //not set by shape
    func testCardCompare1() {
        let card1 = Card(shape: .p1, color: .p1, shapeCount: .p1, filling: .p1)
        let card2 = Card(shape: .p2, color: .p2, shapeCount: .p2, filling: .p2)
        let card3 = Card(shape: .p1, color: .p3, shapeCount: .p3, filling: .p3)
        self.setGame.selectedCards.append(card1)
        self.setGame.selectedCards.append(card2)
        self.setGame.selectedCards.append(card3)
        let res = self.setGame.choosenCardsState
        XCTAssertEqual(res, CardState.mismatch)
    }

    //not set by color
    func testCardCompare2() {
        let card1 = Card(shape: .p1, color: .p1, shapeCount: .p1, filling: .p1)
        let card2 = Card(shape: .p1, color: .p2, shapeCount: .p2, filling: .p2)
        let card3 = Card(shape: .p1, color: .p1, shapeCount: .p3, filling: .p3)
        self.setGame.selectedCards.append(card1)
        self.setGame.selectedCards.append(card2)
        self.setGame.selectedCards.append(card3)
        let res = self.setGame.choosenCardsState
        XCTAssertEqual(res, CardState.mismatch)
    }
    //not set by shape count
    func testCardCompare3() {
        let card1 = Card(shape: .p1, color: .p1, shapeCount: .p1, filling: .p1)
        let card2 = Card(shape: .p2, color: .p2, shapeCount: .p1, filling: .p2)
        let card3 = Card(shape: .p3, color: .p3, shapeCount: .p3, filling: .p3)
        self.setGame.selectedCards.append(card1)
        self.setGame.selectedCards.append(card2)
        self.setGame.selectedCards.append(card3)
        let res = self.setGame.choosenCardsState
        XCTAssertEqual(res, CardState.mismatch)
    }
    //not set by filling
    func testCardCompare4() {
        let card1 = Card(shape: .p1, color: .p1, shapeCount: .p1, filling: .p1)
        let card2 = Card(shape: .p1, color: .p2, shapeCount: .p2, filling: .p1)
        let card3 = Card(shape: .p1, color: .p3, shapeCount: .p3, filling: .p3)
        self.setGame.selectedCards.append(card1)
        self.setGame.selectedCards.append(card2)
        self.setGame.selectedCards.append(card3)
        let res = self.setGame.choosenCardsState
        XCTAssertEqual(res, CardState.mismatch)
    }
    //set
    func testCardCompare5() {
        let card1 = Card(shape: .p1, color: .p1, shapeCount: .p1, filling: .p3)
        let card2 = Card(shape: .p1, color: .p2, shapeCount: .p2, filling: .p3)
        let card3 = Card(shape: .p1, color: .p3, shapeCount: .p3, filling: .p3)
        self.setGame.selectedCards.append(card1)
        self.setGame.selectedCards.append(card2)
        self.setGame.selectedCards.append(card3)
        let res = self.setGame.choosenCardsState
        XCTAssertEqual(res, CardState.match)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
