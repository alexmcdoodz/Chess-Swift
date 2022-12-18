//
//  ViewController.swift
//  Chess
//
//  Created by alex McDonald on 29/11/2022.
//

import UIKit

class ViewController: UIViewController, MoveDelegate {
    
    func movePiece(startCol: Int, startRow: Int, toCol: Int, toRow: Int) {
        gameEngine.movePiece(startCol: startCol, startRow: startRow, toCol: toCol, toRow: toRow);
        boardView.pieces = gameEngine.pieces;
        boardView.setNeedsDisplay();
    }
    
    var gameEngine: GameEngine = GameEngine();
    
    @IBOutlet weak var boardView: BoardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameEngine.initGame();
        boardView.moveDelegate = self;
        boardView.pieces = gameEngine.pieces;
        boardView.setNeedsDisplay();
    }
}

