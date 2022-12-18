//
//  ChessTests.swift
//  ChessTests
//
//  Created by alex McDonald on 29/11/2022.
//

import XCTest
@testable import Chess

class ChessTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCantCaptureOwnPiece() {
        let game = GameEngine();
        game.initGame();
        // assert king cant capture queen
        XCTAssertFalse(game.isLegalMove(startCol: 4, startRow: 7, toCol: 3, toRow: 7));
    }

}
