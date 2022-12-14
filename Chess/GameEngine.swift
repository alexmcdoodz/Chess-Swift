//
//  Game.swift
//  Chess
//
//  Created by alex McDonald on 01/12/2022.
//

import Foundation

class GameEngine {
    let startPosition: String = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
    var isWhitesMove: Bool = true;
    
    init() {
        
    }
    
    var pieces: Array<Piece> = [];
    
    func initGame() {
        initPiecesFromFen(Fen: startPosition)
    }
    
    func movePiece(startCol: Int, startRow: Int, toCol: Int, toRow: Int) {
        
        if (isLegalMove(startCol: startCol, startRow: startRow, toCol: toCol, toRow: toRow)) {
            if let startPiece = lookUpPiece(col: startCol, row: startRow) {
                if let targetPiece = lookUpPiece(col: toCol, row: toRow) {
                    // check that player is not moving piece to a square occupied by a piece of the same colour
                    // also checks if player accidentally moves piece to same square it was on
                    if (targetPiece.isWhite == startPiece.isWhite) {
                        return;
                    }
                    // capture enemy piece
                    let index = pieces.firstIndex{$0 === targetPiece};
                    pieces.remove(at: index!);
                }
                startPiece.col = toCol;
                startPiece.row = toRow;
            }
            // Flip who's move it is after each move
            isWhitesMove = !isWhitesMove;
        }
    }
    
    func isLegalMove(startCol: Int, startRow: Int, toCol: Int, toRow: Int) -> Bool {
        if let startPiece = lookUpPiece(col: startCol, row: startRow) {
            // make sure right person is taking turn
            if (isWhitesMove != startPiece.isWhite) {
                return false;
            }
        }
        
        return true;
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
                piece = Piece(col: col, row: row, imageName: "black_rook", isWhite: false);
                col += 1;
            } else if (letter == "n") {
                piece = Piece(col: col, row: row, imageName: "black_knight", isWhite: false);
                col += 1;
            } else if (letter == "b") {
                piece = Piece(col: col, row: row, imageName: "black_bishop", isWhite: false);
                col += 1;
            } else if (letter == "q") {
                piece = Piece(col: col, row: row, imageName: "black_queen", isWhite: false);
                col += 1;
            } else if (letter == "k") {
                piece = Piece(col: col, row: row, imageName: "black_king", isWhite: false);
                col += 1;
            } else if (letter == "p") {
                piece = Piece(col: col, row: row, imageName: "black_pawn", isWhite: false);
                col += 1;
            } else if (letter == "P") {
                piece = Piece(col: col, row: row, imageName: "white_pawn", isWhite: true);
                col += 1;
            } else if (letter == "R") {
                piece = Piece(col: col, row: row, imageName: "white_rook", isWhite: true);
                col += 1;
            } else if (letter == "N") {
                piece = Piece(col: col, row: row, imageName: "white_knight", isWhite: true);
                col += 1;
            } else if (letter == "B") {
                piece = Piece(col: col, row: row, imageName: "white_bishop", isWhite: true);
                col += 1;
            } else if (letter == "Q") {
                piece = Piece(col: col, row: row, imageName: "white_queen", isWhite: true);
                col += 1;
            } else if (letter == "K") {
                piece = Piece(col: col, row: row, imageName: "white_king", isWhite: true);
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
