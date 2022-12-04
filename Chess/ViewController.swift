//
//  ViewController.swift
//  Chess
//
//  Created by alex McDonald on 29/11/2022.
//

import UIKit

class ViewController: UIViewController {
    
    var gameEngine: GameEngine = GameEngine();
    
    @IBOutlet weak var boardView: BoardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameEngine.initGame();
        boardView.pieces = gameEngine.pieces;

        if (boardView.moves.count == 2) {
            let from = boardView.moves[0];
            let to = boardView.moves[1];
            
            gameEngine.movePiece(startCol: from.x, startRow: from.y, toCol: to.x, toRow: to.y);
            boardView.pieces = gameEngine.pieces;
            boardView.setNeedsDisplay();
        }
    }
}

