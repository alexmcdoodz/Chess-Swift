//
//  ViewController.swift
//  Chess
//
//  Created by alex McDonald on 29/11/2022.
//

import UIKit

class ViewController: UIViewController, MoveDelegate {
    
    func castleShort(fromRow: Int) {
        gameEngine.castleShort(fromRow: fromRow);
        boardView.pieces = gameEngine.pieces;
        boardView.setNeedsDisplay();
    }
    
    func castleLong(fromRow: Int) {
        gameEngine.castleLong(fromRow: fromRow);
        boardView.pieces = gameEngine.pieces;
        boardView.setNeedsDisplay();
    }
    
    func movePiece(startCol: Int, startRow: Int, toCol: Int, toRow: Int) {
        gameEngine.movePiece(startCol: startCol, startRow: startRow, toCol: toCol, toRow: toRow);
        boardView.pieces = gameEngine.pieces;
        boardView.setNeedsDisplay();
    }
    
    var gameEngine: GameEngine = GameEngine();
    
    @IBOutlet weak var winnersText: UILabel!
    @IBOutlet weak var boardView: BoardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        winnersText.text = "";
        gameEngine.initGame();
        boardView.moveDelegate = self;
        boardView.pieces = gameEngine.pieces;
        boardView.setNeedsDisplay();
    }
    
    @IBAction func resetGame(_ sender: Any) {
        winnersText.text = "";
        gameEngine.initGame();
        gameEngine.isWhitesMove = true;
        boardView.isWhitesMove = true;
        boardView.pieces = gameEngine.pieces;
        boardView.setNeedsDisplay();
    }
}

