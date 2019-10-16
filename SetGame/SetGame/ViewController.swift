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
    let borderColorDict : [CardState : CGColor] = [CardState.chosen : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), CardState.match : #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), CardState.mismatch : #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)]
    
    @IBOutlet weak var dealThreeMoreCardsButton: UIButton!
    @IBOutlet weak var scoreText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViewFromModel()
    }
    
    func updateViewFromModel() {
        //set cards
        for index in setGame.cardOnBoard.indices {
            //places on board not fill with cards (if less than 24 cards on board)
            if setGame.cardOnBoard[index] == nil {
                self.cardsOnBoard[index].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                let emptyText = NSAttributedString(string: "   ")
                self.cardsOnBoard[index].setAttributedTitle(emptyText, for: UIControl.State.normal)
                self.cardsOnBoard[index].layer.borderWidth = 0
            }
            //set cards color, filling, shape and border
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
                
                //set card outline
                if setGame.selectedCards.contains(currCard) {
                    self.cardsOnBoard[index].layer.borderWidth = 2.0
                    self.cardsOnBoard[index].layer.borderColor = borderColorDict[setGame.choosenCardsState]
                }
                else {
                    self.cardsOnBoard[index].layer.borderWidth = 0
                }
            }
        }
        //set button "3 more cards" access
        self.dealThreeMoreCardsButton.isEnabled = (setGame.stackCards.count > 0) && (setGame.countCardsOnBoard < 24)
        //set score text
        self.scoreText.text = "Score: \(setGame.score)"
    }
    
    //return card shapes as string
    private func getCardString(card: Card) -> String{
        var res = ""
        for _ in 0..<(self.cardShapeCountDict[card.shapeCount] ?? 0) {
            res += self.cardShapeDict[card.shape] ?? "?"
        }
        return res
    }
    
    //card button touched
    @IBAction func buttonTouched(_ sender: Any) {
        if let cardIndex = cardsOnBoard.firstIndex(of: sender as! UIButton) {
            setGame.cardSelected(cardIndex: cardIndex)
            updateViewFromModel()
        }
        else {
            print("error: card was not in cards")
        }
    }
    
    @IBAction func addThreeCards(_ sender: Any) {
        setGame.addThreeCardsButtonPressed()
        self.updateViewFromModel()
    }
    
    @IBAction func NewGame(_ sender: Any) {
        self.setGame = SetGameModel()
        self.updateViewFromModel()
    }
    
    //if there is set - colol 2 cards in yellow
    @IBAction func getHint(_ sender: Any) {
        var indexes = setGame.getHint()
        self.updateViewFromModel()
        if indexes != nil {
            self.cardsOnBoard![indexes!.0].layer.borderWidth = 2.0
            self.cardsOnBoard![indexes!.0].layer.borderColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
            self.cardsOnBoard![indexes!.1].layer.borderWidth = 2.0
            self.cardsOnBoard![indexes!.1].layer.borderColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        }
    }
}

