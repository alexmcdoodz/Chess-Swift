//
//  sharedFunctions.swift
//  Chess
//
//  Created by alex McDonald on 18/12/2022.
//

import Foundation

func findLegalKnightMoves(fromCol: Int, fromRow: Int, isWhitesMove: Bool, pieces: Array<Piece>) -> Array<(Int, Int)> {
    var legalMoves: Array<(Int, Int)> = [];
    let possibleMoves: Array<(Int, Int)> = [(fromCol + 1, fromRow - 2), (fromCol - 1, fromRow + 2), (fromCol + 2, fromRow - 1), (fromCol - 2, fromRow + 1), (fromCol + 1, fromRow + 2), (fromCol - 1, fromRow - 2), (fromCol - 2, fromRow - 1), (fromCol + 2, fromRow + 1)];
    
    for move in possibleMoves {
        if (move.0 >= 0 && move.0 < 8 && move.1 >= 0 && move.1 < 8 && lookUpPiece(col: move.0, row: move.1, pieces: pieces)?.isWhite != isWhitesMove) {
            legalMoves.append(move);
        }
    }
    return legalMoves;
}

func isLegalMove(startCol: Int, startRow: Int, toCol: Int, toRow: Int, isWhitesMove: Bool, pieces: Array<Piece>) -> Bool {
    if let startPiece = lookUpPiece(col: startCol, row: startRow, pieces: pieces) {
        // make sure right person is taking turn
        if (isWhitesMove != startPiece.isWhite) {
            return false;
        }
        if let targetPiece = lookUpPiece(col: toCol, row: toRow, pieces: pieces) {
            // check that player is not moving piece to a square occupied by a piece of the same colour
            // also checks if player accidentally moves piece to same square it was on
            if (targetPiece.isWhite == startPiece.isWhite) {
                return false;
            }
        }
        if (startPiece.value == .knight) {
            let possibleMoves = findLegalKnightMoves(fromCol: startCol, fromRow: startRow, isWhitesMove: isWhitesMove, pieces: pieces);
            let move = (toCol, toRow);
            if (!possibleMoves.contains(where: {$0 == move})) {
                return false;
            }
        }
    }
    return true;
}

func lookUpPiece(col: Int, row: Int, pieces: Array<Piece>) -> Piece? {
    for piece in pieces {
        if col == piece.col && row == piece.row {
            return piece;
        }
    }
    return nil;
}
