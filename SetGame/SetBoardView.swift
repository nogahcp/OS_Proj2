//
//  SetBoardView.swift
//  SetGame
//
//  Created by Nogah Melamed Cohen on 17/10/2019.
//  Copyright © 2019 Nogah Melamed Cohen. All rights reserved.
//

import UIKit

class SetBoardView: UIView {

    var boardGrid = Grid(layout: .dimensions(rowCount: 4, columnCount: 3)) { didSet { setNeedsDisplay(); setNeedsLayout() } }
//    var cardsViews: [SetCardView] = [] { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    override func draw(_ rect: CGRect) {
        boardGrid = Grid(layout: boardGrid.layout, frame: rect)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //set cards on board
//        for index in self.cardsViews.indices {
//            self.cardsViews[index].draw(self.boardGrid[index]!)
//        }
    }

}

class SetCardView: UIView {
    
    var cardContent: String = "?" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var color: UIColor = UIColor.white { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var filling: Double = 1 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    private lazy var cardLabel: UILabel = self.craeteCardLable() 
    var position: CGRect = CGRect() { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    override func draw(_ rect: CGRect) {
        bounds.origin = rect.origin
        
    }
    
    //create attributed string for card
    private func createCardAttributedString(fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key : Any] = [
            .strokeColor : color,
            .strokeWidth : -5.0,
            .paragraphStyle : paragraphStyle,
            .foregroundColor : (color.withAlphaComponent(CGFloat(filling))),
            .font : font
        ]
        return NSAttributedString(string: cardContent, attributes: attributes)
    }
    
    //create an empty lable and add it as a subview
    private func craeteCardLable() -> UILabel {
        var label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = UIColor.white
        self.addSubview(label)
        return label
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //set label in card
        self.setLabelText()
        cardLabel.frame = bounds.insetBy(dx: 3, dy: 3)
    }
    
    //set card label text with attributed text
    private func setLabelText() {
        //TODO: font size
        self.cardLabel.attributedText = self.createCardAttributedString(fontSize: 33)
        //self.cardLabel.frame.size = CGSize.zero
        self.cardLabel.sizeToFit()
    }
}
