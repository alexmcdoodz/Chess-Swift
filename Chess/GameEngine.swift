//
//  Game.swift
//  Chess
//
//  Created by alex McDonald on 01/12/2022.
//

import Foundation

class GameEngine {
    let startPosition: String = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
    
    init() {
        
    }
    
    var pieces: Array<Piece> = [];
    
    func initGame() {
        initPiecesFromFen(Fen: startPosition)
    }
    
    func movePiece(startCol: Int, startRow: Int, toCol: Int, toRow: Int) {
        if let piece = lookUpPiece(col: startCol, row: startRow) {
            piece.col = toCol;
            piece.row = toRow;
        }
    }
    
    func lookUpPiece(col: Int, row: Int) -> Piece? {
        for piece in pieces {
            if col == piece.col && row == piece.row {
                return piece;
            }
        }
        return nil;
    }
    
    func initPiecesFromFen(Fen: String) {
        var row: Int = 0;
        var col: Int = 0;
        
        for letter in startPosition {
            if (col >= 8) {
                col = 0;
            }
            var piece: Piece?;
            if (letter == "r") {
                piece = Piece(col: col, row: row, imageName: "black_rook", colour: 1);
                col += 1;
            } else if (letter == "n") {
                piece = Piece(col: col, row: row, imageName: "black_knight", colour: 1);
                col += 1;
            } else if (letter == "b") {
                piece = Piece(col: col, row: row, imageName: "black_bishop", colour: 1);
                col += 1;
            } else if (letter == "q") {
                piece = Piece(col: col, row: row, imageName: "black_queen", colour: 1);
                col += 1;
            } else if (letter == "k") {
                piece = Piece(col: col, row: row, imageName: "black_king", colour: 1);
                col += 1;
            } else if (letter == "p") {
                piece = Piece(col: col, row: row, imageName: "black_pawn", colour: 1);
                col += 1;
            } else if (letter == "P") {
                piece = Piece(col: col, row: row, imageName: "white_pawn", colour: 0);
                col += 1;
            } else if (letter == "R") {
                piece = Piece(col: col, row: row, imageName: "white_rook", colour: 0);
                col += 1;
            } else if (letter == "N") {
                piece = Piece(col: col, row: row, imageName: "white_knight", colour: 0);
                col += 1;
            } else if (letter == "B") {
                piece = Piece(col: col, row: row, imageName: "white_bishop", colour: 0);
                col += 1;
            } else if (letter == "Q") {
                piece = Piece(col: col, row: row, imageName: "white_queen", colour: 0);
                col += 1;
            } else if (letter == "K") {
                piece = Piece(col: col, row: row, imageName: "white_king", colour: 0);
                col += 1;
            } else if (letter == "/") {
                row += 1;
            } else if (letter == " ") {
                break;
            } else if (letter.isInt) {
                // forced unwrapping optional okay here as we have already checked letter is a lint
                col += Int(String(letter))!;
            }
            if let unwrapped = piece {
                pieces.append(unwrapped);
            }
        }
    }
}
