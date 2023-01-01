//
//  sharedFunctions.swift
//  Chess
//
//  Created by alex McDonald on 18/12/2022.
//

import Foundation

func canCastleShort(fromCol: Int, fromRow: Int, pieces: Array<Piece>) -> Bool {
    if let king = lookUpPiece(col: fromCol, row: fromRow, pieces: pieces) {
        if let rook = lookUpPiece(col: 7, row: fromRow, pieces: pieces) {
            if (!king.hasMoved && !rook.hasMoved) {
                let fCol = lookUpPiece(col: fromCol + 1, row: fromRow, pieces: pieces);
                let gCol = lookUpPiece(col: fromCol + 2, row: fromRow, pieces: pieces);
                if (fCol == nil && gCol == nil) {
                    return true;
                }
            }
        }
    }
    return false;
}

func canCastleLong(fromCol: Int, fromRow: Int, pieces: Array<Piece>) -> Bool {
    if let king = lookUpPiece(col: fromCol, row: fromRow, pieces: pieces) {
        if let rook = lookUpPiece(col: 0, row: fromRow, pieces: pieces) {
            if (!king.hasMoved && !rook.hasMoved) {
                let bCol = lookUpPiece(col: fromCol - 3, row: fromRow, pieces: pieces);
                let cCol = lookUpPiece(col: fromCol - 2, row: fromRow, pieces: pieces);
                let dCol = lookUpPiece(col: fromCol - 1, row: fromRow, pieces: pieces);
                if (bCol == nil && cCol == nil && dCol == nil) {
                    return true;
                }
            }
        }
    }
    return false;
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

func findLegalKingMoves(fromCol: Int, fromRow: Int, isWhitesMove: Bool, pieces: Array<Piece>) -> Array<(Int, Int)> {
    var legalMoves: Array<(Int, Int)> = [];
    let possibleMoves: Array<(Int, Int)> = [(fromCol + 1, fromRow), (fromCol - 1, fromRow), (fromCol + 1, fromRow + 1), (fromCol + 1, fromRow - 1), (fromCol, fromRow + 1), (fromCol, fromRow - 1), (fromCol - 1, fromRow - 1), (fromCol - 1, fromRow + 1)];
    for move in possibleMoves {
        if (move.0 >= 0 && move.0 < 8 && move.1 >= 0 && move.1 < 8 && lookUpPiece(col: move.0, row: move.1, pieces: pieces)?.isWhite != isWhitesMove) {
            legalMoves.append(move)
        }
    }
    if (canCastleShort(fromCol: fromCol, fromRow: fromRow, pieces: pieces)) {
        legalMoves.append((fromCol + 2, fromRow));
    }
    if (canCastleLong(fromCol: fromCol, fromRow: fromRow, pieces: pieces)) {
        legalMoves.append((fromCol - 2, fromRow));
    }
    return legalMoves;
}

func doesMoveGetOutOfCheck(fromCol: Int, fromRow: Int, isWhitesMove: Bool, move: (Int, Int), pieces: Array<Piece>) -> Bool {
    var tempPieces = pieces;
    if let piece = lookUpPiece(col: fromCol, row: fromRow, pieces: tempPieces) {
        if let capturePiece = lookUpPiece(col: move.0, row: move.1, pieces: tempPieces) {
            let index = tempPieces.firstIndex{$0 === capturePiece};
            tempPieces.remove(at: index!);
            piece.col = move.0;
            piece.row = move.1;
            if (isInCheck(isWhitesMove: isWhitesMove, pieces: tempPieces)) {
                piece.col = fromCol;
                piece.row = fromRow;
                return true;
            }
            
        }
        piece.col = move.0;
        piece.row = move.1;
        if (isInCheck(isWhitesMove: !isWhitesMove, pieces: tempPieces)) {
            piece.col = fromCol;
            piece.row = fromRow;
            return false;
        }
        piece.col = fromCol;
        piece.row = fromRow;
    }
    return true;
}

func isInCheck(isWhitesMove: Bool, pieces: Array<Piece>) -> Bool {
    // loop through all pieces and if they are of opposite colour to isWhitesMove, add that pieces possible moves to attacked squares
    // if king is on any of the "attacked squares" king in check
    var attatckedSquares: Array<(Int, Int)> = [];
    for piece in pieces {
        if (piece.isWhite != !isWhitesMove) {
            if (piece.value == .bishop) {
                attatckedSquares += findLegalBishopMoves(fromCol: piece.col, fromRow: piece.row, isWhitesMove: isWhitesMove, pieces: pieces);
            } else if (piece.value == .knight) {
                attatckedSquares += findLegalKnightMoves(fromCol: piece.col, fromRow: piece.row, isWhitesMove: isWhitesMove, pieces: pieces);
            } else if (piece.value == .pawn) {
                attatckedSquares += findLegalPawnMoves(fromCol: piece.col, fromRow: piece.row, isWhitesMove: isWhitesMove, pieces: pieces);
            } else if (piece.value == .queen) {
                attatckedSquares += findLegalQueenMoves(fromCol: piece.col, fromRow: piece.row, isWhitesMove: isWhitesMove, pieces: pieces);
            } else if (piece.value == .rook) {
                attatckedSquares += findLegalRookMoves(fromCol: piece.col, fromRow: piece.row, isWhitesMove: isWhitesMove, pieces: pieces);
            }
        }
    }
    
    for square in attatckedSquares {
        if let piece = lookUpPiece(col: square.0, row: square.1, pieces: pieces) {
            if (piece.value == .king) {
                return true;
            }
        }
    }
    
    return false;
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

        if (isInCheck(isWhitesMove: !isWhitesMove, pieces: pieces)) {
            let tempPieces = pieces;
            if (!doesMoveGetOutOfCheck(fromCol: startCol, fromRow: startRow, isWhitesMove: isWhitesMove, move: (toCol, toRow), pieces: tempPieces)) {
                return false;
            }
        }
        
        // Check player is moving pieces correctly
        if (startPiece.value == .knight) {
            let possibleMoves = findLegalKnightMoves(fromCol: startCol, fromRow: startRow, isWhitesMove: isWhitesMove, pieces: pieces);
            let move = (toCol, toRow);
            if (!possibleMoves.contains(where: {$0 == move})) {
                return false;
            }
        } else if (startPiece.value == .bishop) {
            let possibleMoves = findLegalBishopMoves(fromCol: startCol, fromRow: startRow, isWhitesMove: isWhitesMove, pieces: pieces);
            let move = (toCol, toRow);
            if (!possibleMoves.contains(where: {$0 == move})) {
                return false;
            }
        } else if (startPiece.value == .rook) {
            let possibleMoves = findLegalRookMoves(fromCol: startCol, fromRow: startRow, isWhitesMove: isWhitesMove, pieces: pieces);
            let move = (toCol, toRow);
            if (!possibleMoves.contains(where: {$0 == move})) {
                return false;
            }
        } else if (startPiece.value == .queen) {
            let possibleMoves = findLegalQueenMoves(fromCol: startCol, fromRow: startRow, isWhitesMove: isWhitesMove, pieces: pieces);
            let move = (toCol, toRow);
            if (!possibleMoves.contains(where: {$0 == move})) {
                return false; 
            }
        } else if (startPiece.value == .king) {
            let possibleMoves = findLegalKingMoves(fromCol: startCol, fromRow: startRow, isWhitesMove: isWhitesMove, pieces: pieces);
            let move = (toCol, toRow);
            if (!possibleMoves.contains(where: {$0 == move})) {
                return false;
            }
        } else if (startPiece.value == .pawn) {
            let possibleMoves = findLegalPawnMoves(fromCol: startCol, fromRow: startRow, isWhitesMove: isWhitesMove, pieces: pieces);
            let move = (toCol, toRow);
            if (!possibleMoves.contains(where: {$0 == move})) {
                return false;
            }
        }
    }
    
    var tempPieces = pieces;
    
    
    return true;
}

func doesMovePutYouInCheck(startCol: Int, startRow: Int, toCol: Int, toRow: Int, isWhitesMove: Bool, pieces: Array<Piece>) -> Bool {
    if let piece = lookUpPiece(col: startCol, row: startRow, pieces: pieces) {
        if let capturedPiece = 
    }
    return true ;
}

func lookUpPiece(col: Int, row: Int, pieces: Array<Piece>) -> Piece? {
    for piece in pieces {
        if col == piece.col && row == piece.row {
            return piece;
        }
    }
    return nil;
}
