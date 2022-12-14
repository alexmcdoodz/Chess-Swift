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
    // true represents white
    let isWhite: Bool;
    
    init(col: Int, row: Int, imageName: String, isWhite: Bool) {
        self.col = col;
        self.row = row;
        self.isWhite = isWhite;
        // Forced optional unwrapping is okay here, as if image is missing app is in bad state and should crash.
        self.image = UIImage(named: imageName)!;
    }
}
