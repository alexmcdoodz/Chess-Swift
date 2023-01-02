//
//  Game.swift
//  Chess
//
//  Created by alex McDonald on 01/12/2022.
//

import Foundation

class GameEngine {
    let startPosition: String = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
//    let startPosition: String = "4k3/4P3/8/4K3/8/8/8/8 w - - 0 1"
    var isWhitesMove: Bool = true;
    var pieces: Array<Piece> = [];
    
    init() {
        
    }

    func initGame() {
        initPiecesFromFen(Fen: startPosition)
    }
    
    func castleShort(fromRow: Int) {
        if let rook = lookUpPiece(col: 7, row: fromRow, pieces: pieces) {
            if let king = lookUpPiece(col: 4, row: fromRow, pieces: pieces) {
                king.col = 6;
                rook.col = 5;
            }
        }
        isWhitesMove = !isWhitesMove;
    }
    
    func castleLong(fromRow: Int) {
        if let rook = lookUpPiece(col: 0, row: fromRow, pieces: pieces) {
            if let king = lookUpPiece(col: 4, row: fromRow, pieces: pieces) {
                king.col = 2;
                rook.col = 3;
            }
        }
        isWhitesMove = !isWhitesMove;
    }
    
    func movePiece(startCol: Int, startRow: Int, toCol: Int, toRow: Int) {
        
        if (isLegalMove(startCol: startCol, startRow: startRow, toCol: toCol, toRow: toRow, isWhitesMove: isWhitesMove, pieces: pieces)) {
            if let startPiece = lookUpPiece(col: startCol, row: startRow, pieces: pieces) {
                if let targetPiece = lookUpPiece(col: toCol, row: toRow, pieces: pieces) {

                    // capture enemy piece
                    let index = pieces.firstIndex{$0 === targetPiece};
                    pieces.remove(at: index!);
                }
                startPiece.col = toCol;
                startPiece.row = toRow;
                if (startPiece.value == .pawn) {
                    // Pawn promotion logic
                    if (startPiece.row == 0 || startPiece.row == 7) {
                        // remove piece and add a queen with same stuff as pawn
                        let index = pieces.firstIndex{$0 === startPiece};
                        pieces.remove(at: index!);
                        
                        let queen = Piece(col: startPiece.col, row: startPiece.row, imageName: startPiece.isWhite ? "white_queen" : "black_queen", isWhite: startPiece.isWhite, value: .queen)
                        pieces.append(queen);
                    }
                }
            }
            // Flip who's move it is after each move
            isWhitesMove = !isWhitesMove;
        }
    }
    
    func initPiecesFromFen(Fen: String) {
        pieces = [];
        var row: Int = 0;
        var col: Int = 0;
        
        for letter in startPosition {
            if (col >= 8) {
                col = 0;
            }
            var piece: Piece?;
            if (letter == "r") {
                piece = Piece(col: col, row: row, imageName: "black_rook", isWhite: false, value: .rook);
                col += 1;
            } else if (letter == "n") {
                piece = Piece(col: col, row: row, imageName: "black_knight", isWhite: false, value: .knight);
                col += 1;
            } else if (letter == "b") {
                piece = Piece(col: col, row: row, imageName: "black_bishop", isWhite: false, value: .bishop);
                col += 1;
            } else if (letter == "q") {
                piece = Piece(col: col, row: row, imageName: "black_queen", isWhite: false, value: .queen);
                col += 1;
            } else if (letter == "k") {
                piece = Piece(col: col, row: row, imageName: "black_king", isWhite: false, value: .king);
                col += 1;
            } else if (letter == "p") {
                piece = Piece(col: col, row: row, imageName: "black_pawn", isWhite: false, value: .pawn);
                col += 1;
            } else if (letter == "P") {
                piece = Piece(col: col, row: row, imageName: "white_pawn", isWhite: true, value: .pawn);
                col += 1;
            } else if (letter == "R") {
                piece = Piece(col: col, row: row, imageName: "white_rook", isWhite: true, value: .rook);
                col += 1;
            } else if (letter == "N") {
                piece = Piece(col: col, row: row, imageName: "white_knight", isWhite: true, value: .knight);
                col += 1;
            } else if (letter == "B") {
                piece = Piece(col: col, row: row, imageName: "white_bishop", isWhite: true, value: .bishop);
                col += 1;
            } else if (letter == "Q") {
                piece = Piece(col: col, row: row, imageName: "white_queen", isWhite: true, value: .queen);
                col += 1;
            } else if (letter == "K") {
                piece = Piece(col: col, row: row, imageName: "white_king", isWhite: true, value: .king);
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
