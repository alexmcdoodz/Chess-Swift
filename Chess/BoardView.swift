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
    var boardSqaures: Array<Array<(UIBezierPath, UIColor)>> = [];
    var moveDelegate: MoveDelegate?;
    var startPos: (x: Int, y: Int) = (0,0);
    var moves: Array<(Int, Int)> = [];
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawBoard();
        drawSquares();
        drawPieces();
    }
    
    func lookUpPiece(col: Int, row: Int) -> Piece? {
        for piece in pieces {
            if col == piece.col && row == piece.row {
                return piece;
            }
        }
        return nil;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // forced unwrapping okay here as there will always be atleast one touch in touches
        let touch = touches.first!;
        let location = touch.location(in: self);
        
        let touchedCol: Int = Int(location.x / (bounds.width / 8));
        let touchedRow: Int = Int(location.y / (bounds.width / 8));
        
        startPos = (touchedCol, touchedRow);
        
        if (moves.count == 0 && lookUpPiece(col: touchedCol, row: touchedRow) != nil) {
            moves.append(startPos);
        } else if (moves.count > 0) {
            moves.append(startPos);
        }

        if (moves.count == 2) {
            moveDelegate?.movePiece(startCol: moves[0].0, startRow: moves[0].1, toCol: moves[1].0, toRow: moves[1].1);
            moves.removeAll();
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
    
    func drawSquares() {
        for i in 0..<8 {
            for j in 0..<8 {
                let square = boardSqaures[i][j]
                square.1.setFill();
                square.0.fill();
            }
        }
    }
    
    func drawBoard() {
        let squareSize: CGFloat = bounds.width / 8;
        for i in 0..<8 {
            var arr: Array<(UIBezierPath, UIColor)> = [];
            for j in 0..<8 {
                let square = UIBezierPath(rect: CGRect(x: x + CGFloat(i) * squareSize, y: y + CGFloat(j) * squareSize, width: squareSize, height: squareSize))
                let num = CGFloat(i) + CGFloat(j);
                let color: UIColor;
                if (num.truncatingRemainder(dividingBy: 2) == 0) {
                    color = UIColor.lightGray;
                } else {
                    color = UIColor.darkGray;
                }
                arr.append((square, color));
            }
            boardSqaures.append(arr)
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
