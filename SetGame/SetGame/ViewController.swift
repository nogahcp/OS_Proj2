//
//  ViewController.swift
//  SetGame
//
//  Created by Nogah Melamed Cohen on 10/10/2019.
//  Copyright © 2019 Nogah Melamed Cohen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cardsOnBoard: [UIButton]!
    var setGame = SetGameModel()
    let cardColorDict = [CardProperty.p1 : #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1), CardProperty.p2 : #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), CardProperty.p3 : #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)]
    let cardFillingDict = [CardProperty.p1 : 0, CardProperty.p2 : 0.15, CardProperty.p3: 1]
    let cardShapeDict = [CardProperty.p1 : "▲", CardProperty.p2 : "●", CardProperty.p3: "■"]
    let cardShapeCountDict = [CardProperty.p1 : 1, CardProperty.p2 : 2, CardProperty.p3: 3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in setGame.cardOnBoard.indices {
            if setGame.cardOnBoard[index] == nil {
                self.cardsOnBoard[index].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                let emptyText = NSAttributedString(string: "   ")
                self.cardsOnBoard[index].setAttributedTitle(emptyText, for: UIControl.State.normal)
            }
            else {
                let currCard = setGame.cardOnBoard[index]!
                let attributes: [NSAttributedString.Key : Any] = [
                    .strokeColor : cardColorDict[currCard.color] as! UIColor,
                    .strokeWidth : -5.0,
                    .foregroundColor : (cardColorDict[currCard.color] as! UIColor).withAlphaComponent(CGFloat(cardFillingDict[currCard.filling]!))
                ]
                let atriText = NSAttributedString(string: getCardString(card: currCard), attributes: attributes)
                self.cardsOnBoard[index].setAttributedTitle(atriText, for: UIControl.State.normal)
                self.cardsOnBoard[index].backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
    }
    
    private func getCardString(card: Card) -> String{
        var res = ""
        for _ in 0..<(self.cardShapeCountDict[card.shapeCount] ?? 0) {
            res += self.cardShapeDict[card.shape] ?? "?"
        }
        return res
    }
    
    @IBAction func buttonTouched(_ sender: Any) {
        if let cardNumber = cardsOnBoard.firstIndex(of: sender as! UIButton)
        {
//            setGame.cardSelected(cardIndex: cardNumber)
//            updateViewFromModel()
        }
        else
        {
            print("error: card was not in cards")
        }
    }
}

