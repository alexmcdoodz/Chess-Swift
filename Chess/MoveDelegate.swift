//
//  File.swift
//  Chess
//
//  Created by alex McDonald on 18/12/2022.
//

import Foundation

protocol MoveDelegate {
    func movePiece(startCol: Int, startRow: Int, toCol: Int, toRow: Int);
    func castleShort(fromRow: Int);
    func castleLong(fromRow: Int);
}
