//
//  BoardView.swift
//  Chess
//
//  Created by alex McDonald on 29/11/2022.
//

import UIKit

// extending Character class to see if Character can be represented as an Int
extension Character {
    var isInt: Bool {
        return Int(String(self)) != nil
    }
}

class BoardView: UIView {
    // probably make these private
    let x: CGFloat = 0;
    let y: CGFloat = 0;
    var pieces: Array<Piece> = [];
    var moves: [(x: Int, y: Int)] = [];
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawBoard();
        drawPieces();
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // forced unwrapping okay here as there will always be atleast one touch in touches
        let touch = touches.first!;
        let location = touch.location(in: self);
        
        let touchedCol: Int = Int(location.x / (bounds.width / 8));
        let touchedRow: Int = Int(location.y / (bounds.width / 8));
        
        if (moves.count >= 2) {
            moves.removeAll()
        } else {
            let coordinates = (touchedCol, touchedRow);
            moves.append(coordinates);
        }
        
        for piece in pieces {
            if (piece.col == touchedCol && piece.row == touchedRow) {
                print("You touched a piece ")
            }
        }
    }

    func drawPieces() {
        for piece in pieces {
            piece.image.draw(in: CGRect(x: piece.col * Int((bounds.width / 8)), y: piece.row * Int((bounds.width / 8)), width: Int(bounds.width / 8), height: Int(bounds.width / 8)));
        }
    }
    
    func drawBoard() {
        for i in 0..<8 {
            for j in 0..<8 {
                drawSquare(row: CGFloat(i), col: CGFloat(j));
            }
        }
    }
    
    func drawSquare(row: CGFloat, col: CGFloat) {
        let squareSize: CGFloat = bounds.width / 8;
        let square = UIBezierPath(rect: CGRect(x: x + row * squareSize, y: y + col * squareSize, width: squareSize, height: squareSize));
        let num = row + col;
        if (num.truncatingRemainder(dividingBy: 2) == 0) {
            UIColor.lightGray.setFill();
        } else {
            UIColor.darkGray.setFill();
        }
        square.fill();
    }
}
