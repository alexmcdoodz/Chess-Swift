//
//  Piece.swift
//  Chess
//
//  Created by alex McDonald on 30/11/2022.
//

import Foundation
import UIKit

enum Value {
    case pawn, knight, bishop, rook, queen, king
}

class Piece {
    var col: Int;
    var row: Int;
    let image: UIImage;
    // true represents white
    let isWhite: Bool;
    let value: Value;
    var hasMoved: Bool = false;
    
    init(col: Int, row: Int, imageName: String, isWhite: Bool, value: Value) {
        self.col = col;
        self.row = row;
        self.isWhite = isWhite;
        // Forced optional unwrapping is okay here, as if image is missing app is in bad state and should crash.
        self.image = UIImage(named: imageName)!;
        self.value = value;
    }
}
