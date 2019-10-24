//
//  SetBoardView.swift
//  SetGame
//
//  Created by Nogah Melamed Cohen on 17/10/2019.
//  Copyright © 2019 Nogah Melamed Cohen. All rights reserved.
//

import UIKit

//board view with grid and SetCardViews as subviews
class SetBoardView: UIView {
    //grid for positioning cards on board
    var boardGrid = Grid(layout: .dimensions(rowCount: 4, columnCount: 3)) { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    override func draw(_ rect: CGRect) {
        boardGrid.frame = rect
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}

