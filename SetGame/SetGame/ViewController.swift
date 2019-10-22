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
    var hintIndexes: (Int, Int)? = nil
    
    @IBOutlet weak var dealThreeMoreCardsButton: UIButton!
    @IBOutlet weak var scoreText: UITextField!
    @IBOutlet weak var setBoardView: SetBoardView! {
        didSet {
            //when tap - select card
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnCard))
            setBoardView.addGestureRecognizer(tap)
        }
    }
    @IBOutlet var screen: UIView! {
        didSet {
            //when swipe down - add three cards to board
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(addThreeCards(_:)))
            swipe.direction = .down
            screen.addGestureRecognizer(swipe)
            //when rotate - shuffle cards
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards))
            screen.addGestureRecognizer(rotate)

        } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViewFromModel()
    }
    
    //recalculate grid and draw when phone rotates
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.updateViewFromModel()
    }
    
    //shuffle cards on board
    @objc private func shuffleCards() {
        setGame.shuffleCards()
        self.updateViewFromModel()
    }
    
    //select card by position
    @objc private func tapOnCard(touch: UITapGestureRecognizer) {
        let touchLocation = touch.location(in: self.setBoardView)
        //find which card was taped by position in grid
        let cardIndex = getCardIndexFromGrid(location: touchLocation)
        self.cardTouched(index: cardIndex)
    }
    
    //return card index on board by position on grid
    private func getCardIndexFromGrid(location: CGPoint) -> Int? {
        for index in 0..<self.setBoardView!.boardGrid.cellCount {
            let currCard = self.setBoardView!.boardGrid[index]
            if currCard!.contains(location) {
                return index
            }
        }
        return nil
    }
    
    func updateViewFromModel() {
        let cardsCount = setGame.cardOnBoard.count
        //remove old cards from view
        setBoardView.subviews.forEach { $0.removeFromSuperview() }
        //calculate grid
        setBoardView.boardGrid = Grid(layout: .aspectRatio(1), frame: setBoardView.frame)
        setBoardView.boardGrid.cellCount = cardsCount
        //add cards to board
        self.createNewCardsViewFromGrid()
        //set button "3 more cards" access
        self.dealThreeMoreCardsButton.isEnabled = (setGame.stackCards.count > 0)
        //set score text
        self.scoreText.text = "Score: \(setGame.score)"
    }
    
    //go through cardOnBoard and grid and create cards for view
    private func createNewCardsViewFromGrid() {
        for index in setGame.cardOnBoard.indices {
            let card = setGame.cardOnBoard[index]
            let frame = setBoardView.boardGrid[index]!
            let cardView =  SetCardView(frame: frame)
            //set cardView parameters
            cardView.cardContent = self.getCardString(card: card)
            cardView.color = cardColorDict[card.color] as! UIColor
            cardView.filling = cardFillingDict[card.filling]!
            //cardView.position = setBoardView.boardGrid[index]!
            //add cardView to board
            self.setBoardView.addSubview(cardView)
            //add mark if needed
            self.updateCardOutline(to: cardView, at: index)
        }
    }
    
    //set empty card view
    private func updateEmptyCardView(at index: Int) {
        self.cardsOnBoard[index].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        let emptyText = NSAttributedString(string: "   ")
        self.cardsOnBoard[index].setAttributedTitle(emptyText, for: UIControl.State.normal)
        self.cardsOnBoard[index].layer.borderWidth = 0
    }
    
    //set cards color, filling, shape
    private func updateCardView(at index: Int) {
        let currCard = setGame.cardOnBoard[index]
        let attributes: [NSAttributedString.Key : Any] = [
            .strokeColor : cardColorDict[currCard.color] as! UIColor,
            .strokeWidth : -5.0,
            .foregroundColor : (cardColorDict[currCard.color] as! UIColor).withAlphaComponent(CGFloat(cardFillingDict[currCard.filling]!))
        ]
        let atriText = NSAttributedString(string: getCardString(card: currCard), attributes: attributes)
        self.cardsOnBoard[index].setAttributedTitle(atriText, for: UIControl.State.normal)
        self.cardsOnBoard[index].backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    //set card outline if selected (color by choosenCardState)
    private func updateCardOutline(to card: SetCardView, at index:Int) {
        let currCard = setGame.cardOnBoard[index]
        //if is hint - mark in yellow
        if self.hintIndexes != nil && (self.hintIndexes?.0 == index || self.hintIndexes?.1 == index)
        {
            card.layer.borderWidth = 2.0
            card.layer.borderColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
            return
        }
        
        if setGame.selectedCards.contains(currCard) {
            card.layer.borderWidth = 2.0
            card.layer.borderColor = borderColorDict[setGame.choosenCardsState]
        }
        else {
            card.layer.borderWidth = 0
        }
    }
    
    //return card shapes as string
    private func getCardString(card: Card) -> String{
        var res = ""
        for _ in 0..<(self.cardShapeCountDict[card.shapeCount] ?? 0) {
            res += self.cardShapeDict[card.shape] ?? "?"
        }
        return res
    }
    
    //card touched
    private func cardTouched(index: Int?) {
        if let cardIndex = index {
            setGame.cardSelected(cardIndex: cardIndex)
            updateViewFromModel()
        }
        else {
            print("touch not on card")
        }
        //if only 3 card and a match - game ended
        if setGame.countCardsOnBoard == 3 && setGame.choosenCardsState == .match {
            self.gameEnded()
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
        self.hintIndexes = setGame.getHint()
        self.updateViewFromModel()
        self.hintIndexes = nil
    }
    
    //pop alert when game is ended
    func gameEnded() {
        let alert = UIAlertController(title: "Game Ended!", message: "your score: \(setGame.score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: { action in
            self.setGame = SetGameModel()
            self.updateViewFromModel()
        }))
        self.present(alert, animated: true)
    }
}

