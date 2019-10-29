//
//  SetCardView.swift
//  SetGame
//
//  Created by Nogah Melamed Cohen on 23/10/2019.
//  Copyright © 2019 Nogah Melamed Cohen. All rights reserved.
//

import UIKit

class SetCardView: UIView {
    
    var cardContent: String = "?" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var color: UIColor = UIColor.white { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var filling: Double = 1 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    private lazy var cardLabel: UILabel = self.craeteCardLable()
    
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
            .strokeColor : self.color,
            .strokeWidth : -5.0,
            .paragraphStyle : paragraphStyle,
            .foregroundColor : (self.color.withAlphaComponent(CGFloat(self.filling))),
            .font : font
        ]
        return NSAttributedString(string: cardContent, attributes: attributes)
    }
    
    //create an empty lable and add it as a subview
    private func craeteCardLable() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.backgroundColor = UIColor.white
        self.addSubview(label)
        return label
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //set label in card
        self.setLabelText()
        cardLabel.frame = bounds.inset(by: UIEdgeInsets(top: 1.5, left: 1.5, bottom: 1.5, right: 1.5))
        
    }
    
    //set card label text with attributed text
    private func setLabelText() {
        self.cardLabel.attributedText = self.createCardAttributedString(fontSize: bounds.height * 0.25)
        self.cardLabel.sizeToFit()
    }
}
