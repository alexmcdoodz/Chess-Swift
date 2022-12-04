//
//  Piece.swift
//  Chess
//
//  Created by alex McDonald on 30/11/2022.
//

import Foundation
import UIKit

class Piece {
    var col: Int;
    var row: Int;
    let image: UIImage;
    // 1 represents black piece, 0 represents white piece
    let colour: Int;
    
    init(col: Int, row: Int, imageName: String, colour: Int) {
        self.col = col;
        self.row = row;
        self.colour = colour;
        // Forced optional unwrapping is okay here, as if image is missing app is in bad state and should crash.
        self.image = UIImage(named: imageName)!;
    }
}
