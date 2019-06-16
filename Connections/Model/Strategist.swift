/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/**

 THINGS TO DO

 Demo 1

 1. Create private let for 'strategist' (type = GKMinmaxStrategist).
 2. Create var for 'board' and set gameModel.

 Demo 2

 3. Populate bestMoveForAI() function in order to determine the next move for the AI.
 4. Set maxLookAheadDepth and randomSource.

 */

import GameplayKit

struct Strategist {

  // TODO: 1. add private let 'strategist' & 4. set options
  private let strategist: GKMinmaxStrategist = {
    let strategist = GKMinmaxStrategist()
    //strategist.maxLookAheadDepth = 7
    
    
    // Adding a random source helps to make the AI more 'human'
    let sharedRandomSource = GKRandomSource.sharedRandom()
    
    let linearCongruential = GKLinearCongruentialRandomSource() // faster, less random
    let arc4RandomSource = GKARC4RandomSource() // balanced speed & randomness
    let mersenneTwister = GKMersenneTwisterRandomSource() // slower, more random
    
    strategist.randomSource = mersenneTwister
    strategist.maxLookAheadDepth = 7
    // End of random source
    
    
    return strategist
  }()

  // TODO: 2. add var 'board' & set gameModel
  var board: Board {
    didSet {
      strategist.gameModel = board
    }
  }

  func bestMoveForAI() -> Int? {
    if let move = strategist.randomMove(for: board.currentPlayer, fromNumberOfBestMoves: 3) as? Move {
      return move.column
    }
    
    return nil
  }
  
  
//  func bestMoveForAI() -> Int? {
//  // TODO: 3. add code to get best move for AI
//
//    if let move = strategist.bestMove(for: board.currentPlayer) as? Move {
//      return move.column
//    }
//    return nil
//  }
}
