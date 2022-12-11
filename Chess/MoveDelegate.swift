//
//  moveDelegate.swift
//  Chess
//
//  Created by alex McDonald on 04/12/2022.
//

import Foundation

protocol MoveDelegate {
    func movePiece(startCol: Int, startRow: Int, toCol: Int, toRow: Int);
}
