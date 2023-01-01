//
//  piecesMoves.swift
//  Chess
//
//  Created by alex McDonald on 01/01/2023.
//

import Foundation

func findLegalBishopMoves(fromCol: Int, fromRow: Int, isWhitesMove: Bool, pieces: Array<Piece>) -> Array<(Int, Int)> {
    var legalMoves: Array<(Int, Int)> = [];
    var possibleMoves: Array<(Int, Int)> = [];
    
    // upwards left diagonal
    var i = fromCol, j = fromRow;
    while (i > 0 && j > 0) {
        i -= 1;
        j -= 1;
        possibleMoves.append((i , j));
        if (lookUpPiece(col: i, row: j, pieces: pieces) != nil) {
            break;
        }
    }
    i = fromCol; j = fromRow;
    while (i < 7 && j < 7) {
        i += 1;
        j += 1;
        possibleMoves.append((i, j));
        if (lookUpPiece(col: i, row: j, pieces: pieces) != nil) {
            break;
        }
    }
    
    i = fromCol; j = fromRow;
    while (i < 7 && j > 0) {
        i += 1;
        j -= 1;
        possibleMoves.append((i , j));
        if (lookUpPiece(col: i, row: j, pieces: pieces) != nil) {
            break;
        }
    }
    i = fromCol; j = fromRow;
    while (i > 0 && j < 7) {
        i -= 1;
        j += 1;
        possibleMoves.append((i , j));
        if (lookUpPiece(col: i, row: j, pieces: pieces) != nil) {
            break;
        }
    }
    
    for move in possibleMoves {
        if (lookUpPiece(col: move.0, row: move.1, pieces: pieces)?.isWhite != isWhitesMove) {
            legalMoves.append(move);
        }
    }
    return legalMoves;
}

func findLegalRookMoves(fromCol: Int, fromRow: Int, isWhitesMove: Bool, pieces: Array<Piece>) -> Array<(Int, Int)> {
    var legalMoves: Array<(Int, Int)> = [];
    var possibleMoves: Array<(Int, Int)> = [];
    
    var i = fromCol;
    while (i < 7) {
        i += 1;
        possibleMoves.append((i, fromRow));
        if (lookUpPiece(col: i, row: fromRow, pieces: pieces) != nil) {
            break;
        }
    }
    i = fromCol;
    while (i > 0) {
        i -= 1;
        possibleMoves.append((i, fromRow));
        if (lookUpPiece(col: i, row: fromRow, pieces: pieces) != nil) {
            break;
        }
    }
    
    var j = fromRow;
    while (j < 7) {
        j += 1;
        possibleMoves.append((fromCol, j));
        if (lookUpPiece(col: fromCol, row: j, pieces: pieces) != nil) {
            break;
        }
    }
    j = fromRow;
    while (j > 0) {
        j -= 1;
        possibleMoves.append((fromCol, j));
        if (lookUpPiece(col: fromCol, row: j, pieces: pieces) != nil) {
            break;
        }
    }
    
    for move in possibleMoves {
        if (lookUpPiece(col: move.0, row: move.1, pieces: pieces)?.isWhite != isWhitesMove) {
            legalMoves.append(move);
        }
    }
    return legalMoves;
}

func findLegalQueenMoves(fromCol: Int, fromRow: Int, isWhitesMove: Bool, pieces: Array<Piece>) -> Array<(Int, Int)> {
    var legalMoves: Array<(Int, Int)> = [];
    var possibleMoves: Array<(Int, Int)> = findLegalBishopMoves(fromCol: fromCol, fromRow: fromRow, isWhitesMove: isWhitesMove, pieces: pieces);
    possibleMoves += findLegalRookMoves(fromCol: fromCol, fromRow: fromRow, isWhitesMove: isWhitesMove, pieces: pieces);
    
    for move in possibleMoves {
        if (lookUpPiece(col: move.0, row: move.1, pieces: pieces)?.isWhite != isWhitesMove) {
                legalMoves.append(move);
        }
    }
    return legalMoves;
}

func findLegalKingMoves(fromCol: Int, fromRow: Int, isWhitesMove: Bool, pieces: Array<Piece>) -> Array<(Int, Int)> {
    var legalMoves: Array<(Int, Int)> = [];
    let possibleMoves: Array<(Int, Int)> = [(fromCol + 1, fromRow), (fromCol - 1, fromRow), (fromCol + 1, fromRow + 1), (fromCol + 1, fromRow - 1), (fromCol, fromRow + 1), (fromCol, fromRow - 1), (fromCol - 1, fromRow - 1), (fromCol - 1, fromRow + 1)];
    for move in possibleMoves {
        if (move.0 >= 0 && move.0 < 8 && move.1 >= 0 && move.1 < 8 && lookUpPiece(col: move.0, row: move.1, pieces: pieces)?.isWhite != isWhitesMove) {
            legalMoves.append(move)
        }
    }
    if (canCastleShort(fromCol: fromCol, fromRow: fromRow, isWhitesMove: isWhitesMove, pieces: pieces)) {
        legalMoves.append((fromCol + 2, fromRow));
    }
    if (canCastleLong(fromCol: fromCol, fromRow: fromRow, isWhitesMove: isWhitesMove, pieces: pieces)) {
        legalMoves.append((fromCol - 2, fromRow));
    }
    return legalMoves;
}

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

func findLegalPawnMoves(fromCol: Int, fromRow: Int, isWhitesMove: Bool, pieces: Array<Piece>) -> Array<(Int, Int)> {
    var legalMoves: Array<(Int, Int)> = [];
    var possibleMoves: Array<(Int, Int)> = [];
    
    if let piece = lookUpPiece(col: fromCol, row: fromRow, pieces: pieces) {
        if (piece.isWhite) {
            if (lookUpPiece(col: fromCol, row: fromRow - 1, pieces: pieces) == nil) {
                possibleMoves.append((fromCol, fromRow - 1));
            }
            if (piece.row == 6) {
                if (lookUpPiece(col: fromCol, row: fromRow - 2, pieces: pieces) == nil) {
                    possibleMoves.append((fromCol, fromRow - 2));
                }
            }
            if let leftPiece = lookUpPiece(col: fromCol - 1, row: fromRow - 1, pieces: pieces) {
                if (!leftPiece.isWhite) {
                    possibleMoves.append((fromCol - 1, fromRow - 1));
                }
            }
            if let rightPiece = lookUpPiece(col: fromCol + 1, row: fromRow - 1, pieces: pieces) {
                if (!rightPiece.isWhite) {
                    possibleMoves.append((fromCol + 1, fromRow - 1));
                }
            }
            
        } else {
            if (lookUpPiece(col: fromCol, row: fromRow + 1, pieces: pieces) == nil) {
                possibleMoves.append((fromCol, fromRow + 1));
            }
            if (piece.row == 1) {
                if (lookUpPiece(col: fromCol, row: fromRow + 2, pieces: pieces) == nil) {
                    possibleMoves.append((fromCol, fromRow + 2));
                }
            }
            if let leftPiece = lookUpPiece(col: fromCol - 1, row: fromRow + 1, pieces: pieces) {
                if (leftPiece.isWhite) {
                    possibleMoves.append((fromCol - 1, fromRow + 1));
                }
            }
            if let rightPiece = lookUpPiece(col: fromCol + 1, row: fromRow + 1, pieces: pieces) {
                if (rightPiece.isWhite) {
                    possibleMoves.append((fromCol + 1, fromRow + 1));
                }
            }
        }
    }
    for move in possibleMoves {
        if (move.0 < 8 && move.0 >= 0 && move.1 < 8 && move.1 >= 0) {
            legalMoves.append(move);
        }
    }
    return legalMoves;
}
