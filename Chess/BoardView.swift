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
    var highlightedSquare = CAShapeLayer();
    var isWhitesMove: Bool = true;
    var highlightedPossibleMoves: Array<CAShapeLayer> = [];
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawBoard();
        drawSquares();
        drawPieces();
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for square in highlightedPossibleMoves {
            square.removeFromSuperlayer();
        }
        
        highlightedPossibleMoves = [];

        // forced unwrapping okay here as there will always be atleast one touch in touches
        let touch = touches.first!;
        let location = touch.location(in: self);
        
        let touchedCol: Int = Int(location.x / (bounds.width / 8));
        let touchedRow: Int = Int(location.y / (bounds.width / 8));
        let lookedUpPiece = lookUpPiece(col: touchedCol, row: touchedRow, pieces: pieces);
        
        startPos = (touchedCol, touchedRow);

        
        if let piece = lookedUpPiece {
            if (piece.isWhite == isWhitesMove) {
                
                // highlight touched square
                let touchedSquare = boardSqaures[touchedCol][touchedRow].0;
                highlightedSquare.path = touchedSquare.cgPath
                highlightedSquare.fillColor = UIColor.yellow.cgColor
                highlightedSquare.opacity = 0.25;
                self.layer.addSublayer(highlightedSquare);
                
                // highlight possible moves if piece selected
                if (piece.value == .knight) {
                    let moves = findLegalKnightMoves(fromCol: touchedCol, fromRow: touchedRow, isWhitesMove: isWhitesMove, pieces: pieces);
                    highlightPossibleMoves(moves: moves);
                } else if (piece.value == .bishop) {
                    let moves = findLegalBishopMoves(fromCol: touchedCol, fromRow: touchedRow, isWhitesMove: isWhitesMove, pieces: pieces);
                    highlightPossibleMoves(moves: moves);
                    
                }
            }
        }
        
        if (moves.count == 0 && lookedUpPiece != nil) {
            moves.append(startPos);
        } else if (moves.count > 0) {
            if (startPos != moves[0]) {
                moves.append(startPos);
            } else {
                moves.removeAll();
            }
        }
        
        if (moves.count == 2) {
            if (isLegalMove(startCol: moves[0].0, startRow: moves[0].1, toCol: moves[1].0, toRow: moves[1].1, isWhitesMove: isWhitesMove, pieces: pieces)) {
                moveDelegate?.movePiece(startCol: moves[0].0, startRow: moves[0].1, toCol: moves[1].0, toRow: moves[1].1);
                isWhitesMove = !isWhitesMove;
                print("move made - boardView")
            }
            moves.removeAll();
            highlightedSquare.removeFromSuperlayer();
            
        }
    }
    
    func highlightPossibleMoves(moves: Array<(Int, Int)>) {
        for move in moves {
            let square = boardSqaures[move.0][move.1].0;
            let highlightedSquare = CAShapeLayer();
            highlightedSquare.path = square.cgPath;
            highlightedSquare.fillColor = UIColor.blue.cgColor;
            highlightedSquare.opacity = 0.25;
            self.layer.addSublayer(highlightedSquare);
            highlightedPossibleMoves.append(highlightedSquare);
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
