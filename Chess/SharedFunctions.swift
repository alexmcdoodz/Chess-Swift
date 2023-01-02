//
//  sharedFunctions.swift
//  Chess
//
//  Created by alex McDonald on 18/12/2022.
//

import Foundation

func canCastleShort(fromCol: Int, fromRow: Int, isWhitesMove: Bool, pieces: Array<Piece>) -> Bool {
    if (isInCheck(isWhitesMove: !isWhitesMove, pieces: pieces)) {
        return false;
    }
    if let king = lookUpPiece(col: fromCol, row: fromRow, pieces: pieces) {
        if let rook = lookUpPiece(col: 7, row: fromRow, pieces: pieces) {
            if (!king.hasMoved && !rook.hasMoved) {
                let fCol = lookUpPiece(col: fromCol + 1, row: fromRow, pieces: pieces);
                let gCol = lookUpPiece(col: fromCol + 2, row: fromRow, pieces: pieces);
                // Check there are no pieces between king and rook
                if (fCol == nil && gCol == nil) {
                    // Check king is not travelling through check
                    let attackedSquares = getAllAttackedSquares(isWhitesMove: !isWhitesMove, pieces: pieces);
                    for square in attackedSquares {
                        if (square == (fromCol + 1, fromRow) || square == (fromCol + 2, fromRow)) {
                            return false;
                        }
                    }
                    return true;
                }
            }
        }
    }
    return false;
}

func canCastleLong(fromCol: Int, fromRow: Int, isWhitesMove: Bool, pieces: Array<Piece>) -> Bool {
    
    if (isInCheck(isWhitesMove: !isWhitesMove, pieces: pieces)) {
        return false;
    }
    
    if let king = lookUpPiece(col: fromCol, row: fromRow, pieces: pieces) {
        if let rook = lookUpPiece(col: 0, row: fromRow, pieces: pieces) {
            if (!king.hasMoved && !rook.hasMoved) {
                let bCol = lookUpPiece(col: fromCol - 3, row: fromRow, pieces: pieces);
                let cCol = lookUpPiece(col: fromCol - 2, row: fromRow, pieces: pieces);
                let dCol = lookUpPiece(col: fromCol - 1, row: fromRow, pieces: pieces);
                if (bCol == nil && cCol == nil && dCol == nil) {
                    let attackedSquares = getAllAttackedSquares(isWhitesMove: !isWhitesMove, pieces: pieces);
                    for square in attackedSquares {
                        if (square == (fromCol - 1, fromRow) || square == (fromCol - 2, fromRow) || square == (fromCol - 3, fromRow)) {
                            return false;
                        }
                    }
                    return true;
                }
            }
        }
    }
    return false;
}

func filterIllegalMoves(moves: Array<(Int, Int)>, fromCol: Int, fromRow: Int, isWhitesMove: Bool, pieces: Array<Piece>) -> Array<(Int, Int)> {
    var possibleMoves: Array<(Int, Int)> = [];
    var legalMoves: Array<(Int, Int)> = [];
    if (isInCheck(isWhitesMove: !isWhitesMove, pieces: pieces)) {
        for move in moves {
            let tempPieces = pieces;
            if (doesMoveGetOutOfCheck(fromCol: fromCol, fromRow: fromRow, isWhitesMove: isWhitesMove, move: move, pieces: tempPieces)) {
                possibleMoves.append(move);
            }
        }
    } else {
        possibleMoves = moves;
    }
    
    for move in possibleMoves {
        let tempPieces = pieces;
        if (!doesMovePutYouInCheck(startCol: fromCol, startRow: fromRow, toCol: move.0, toRow: move.1, isWhitesMove: isWhitesMove, pieces: tempPieces)) {
            legalMoves.append(move);
        }
    }
    return legalMoves;
}

func findAllPossibleMoves(isWhitesMove: Bool, pieces: Array<Piece>) -> Array<(Int, Int)> {
    var possibleMoves: Array<(Int, Int)> = [];
    for piece in pieces {
        if (piece.isWhite == isWhitesMove) {
            var moves: Array<(Int, Int)> = [];
            if (piece.value == .knight) {
                moves = findLegalKnightMoves(fromCol: piece.col, fromRow: piece.row, isWhitesMove: isWhitesMove, pieces: pieces);
                moves = filterIllegalMoves(moves: moves, fromCol: piece.col, fromRow: piece.row, isWhitesMove: isWhitesMove, pieces: pieces);
            } else if (piece.value == .bishop) {
                moves = findLegalBishopMoves(fromCol: piece.col, fromRow: piece.row, isWhitesMove: isWhitesMove, pieces: pieces);
                moves = filterIllegalMoves(moves: moves, fromCol: piece.col, fromRow: piece.row, isWhitesMove: isWhitesMove, pieces: pieces);
            } else if (piece.value == .rook) {
                moves = findLegalRookMoves(fromCol: piece.col, fromRow: piece.row, isWhitesMove: isWhitesMove, pieces: pieces);
                moves = filterIllegalMoves(moves: moves, fromCol: piece.col, fromRow: piece.row, isWhitesMove: isWhitesMove, pieces: pieces);
            } else if (piece.value == .queen) {
                moves = findLegalQueenMoves(fromCol: piece.col, fromRow: piece.row, isWhitesMove: isWhitesMove, pieces: pieces);
                moves = filterIllegalMoves(moves: moves, fromCol: piece.col, fromRow: piece.row, isWhitesMove: isWhitesMove, pieces: pieces);
            } else if (piece.value == .king) {
                moves = findLegalKingMoves(fromCol: piece.col, fromRow: piece.row, isWhitesMove: isWhitesMove, pieces: pieces);
                moves = filterIllegalMoves(moves: moves, fromCol: piece.col, fromRow: piece.row, isWhitesMove: isWhitesMove, pieces: pieces);
            } else if (piece.value == .pawn) {
                moves = findLegalPawnMoves(fromCol: piece.col, fromRow: piece.row, isWhitesMove: isWhitesMove, pieces: pieces);
                moves = filterIllegalMoves(moves: moves, fromCol: piece.col, fromRow: piece.row, isWhitesMove: isWhitesMove, pieces: pieces);
            }
            possibleMoves += moves;
        }
    }
    return possibleMoves;
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

func getAllAttackedSquares(isWhitesMove: Bool, pieces: Array<Piece>) -> Array<(Int, Int)> {
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
            } else if (piece.value == .king) {
                attatckedSquares.append((piece.col + 1, piece.row));
                attatckedSquares.append((piece.col - 1, piece.row));
                attatckedSquares.append((piece.col + 1, piece.row + 1));
                attatckedSquares.append((piece.col + 1, piece.row - 1));
                attatckedSquares.append((piece.col, piece.row + 1));
                attatckedSquares.append((piece.col, piece.row - 1));
                attatckedSquares.append((piece.col - 1, piece.row - 1));
                attatckedSquares.append((piece.col - 1, piece.row + 1));
            }
        }
    }
    return attatckedSquares;
}

func isInCheck(isWhitesMove: Bool, pieces: Array<Piece>) -> Bool {
    // loop through all pieces and if they are of opposite colour to isWhitesMove, add that pieces possible moves to attacked squares
    // if king is on any of the "attacked squares" king in check
    let attatckedSquares: Array<(Int, Int)> = getAllAttackedSquares(isWhitesMove: isWhitesMove, pieces: pieces);
    
    for square in attatckedSquares {
        if let piece = lookUpPiece(col: square.0, row: square.1, pieces: pieces) {
            if (piece.value == .king) {
                return true;
            }
        }
    }
    return false;
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
    
    let tempPieces = pieces;
    if (doesMovePutYouInCheck(startCol: startCol, startRow: startRow, toCol: toCol, toRow: toRow, isWhitesMove: isWhitesMove, pieces: tempPieces)) {
        return false;
    }
    
    return true;
}

func doesMovePutYouInCheck(startCol: Int, startRow: Int, toCol: Int, toRow: Int, isWhitesMove: Bool, pieces: Array<Piece>) -> Bool {
    var tempPieces = pieces;
    if let piece = lookUpPiece(col: startCol, row: startRow, pieces: tempPieces) {
        if let capturePiece = lookUpPiece(col: toCol, row: toRow, pieces: tempPieces) {
            let index = tempPieces.firstIndex{$0 === capturePiece};
            tempPieces.remove(at: index!);
            piece.col = toCol;
            piece.row = toRow;
            if (isInCheck(isWhitesMove: !isWhitesMove, pieces: tempPieces)) {
                piece.col = startCol;
                piece.row = startRow;
                return true;
            }
        } else {
            piece.col = toCol;
            piece.row = toRow;
            if (isInCheck(isWhitesMove: !isWhitesMove, pieces: tempPieces)) {
                piece.col = startCol;
                piece.row = startRow;
                return true;
            }
        }
        piece.col = startCol;
        piece.row = startRow;
    }
    return false;
}

func lookUpPiece(col: Int, row: Int, pieces: Array<Piece>) -> Piece? {
    for piece in pieces {
        if col == piece.col && row == piece.row {
            return piece;
        }
    }
    return nil;
}
