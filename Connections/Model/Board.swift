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

 1. Redefine 'Board' extension to conform to GKGameModel.
 2. Add vars for 'players' and 'activePlayer' (GKGameModelPlayer).
 3. Modify setGameModel function.
 4. Modify NSCopying function; adjust call to setGameModel().
 5. Modify isWin function.
 6. Modify gameModelUpdates function.
 7. Modify apply function.

 Demo 2

 8. Add code to isWin function.
 9. Add code to gameModelUpdates function.
 10. Add code to
 11. Modify score function.

 */


import GameplayKit

class Board: NSObject, GKGameModel {
  
  static var width = 7
  static var height = 6
  
  var spots = [StoneColor]()
  var currentPlayer: Player
  
  override init() {
    for _ in 0 ..< Board.width * Board.height {
      spots.append(.none)
    }
    currentPlayer = Player.allPlayers[0]
    
    super.init()
  }
  
  func stone(inColumn column: Int, row: Int) -> StoneColor {
    return spots[row + column * Board.height]
  }
  
  func set(stone: StoneColor, in column: Int, row: NSInteger) {
    spots[row + column * Board.height] = stone
  }
  
  func nextEmptySpot(in column: Int) -> Int? {
    for row in 0 ..< Board.height {
      if stone(inColumn: column, row: row) == .none {
        return row
      }
    }
    
    return nil
  }
  
  func canMove(in column: Int) -> Bool {
    return nextEmptySpot(in: column) != nil
  }
  
  func add(stone: StoneColor, in column: Int) {
    if let row = nextEmptySpot(in: column) {
      set(stone: stone, in: column, row: row)
    }
  }
  
  func isFull() -> Bool {
    for column in 0 ..< Board.width {
      if canMove(in: column) {
        return false
      }
    }
    
    return true
  }
  
  // MARK: - Check for win
  
  func stonesMatch(firstStone: StoneColor, row: Int, col: Int, moveX: Int, moveY: Int) -> Bool {
    // exit function if there is no winning connection
    if row + (moveY * 3) < 0 { return false }
    if row + (moveY * 3) >= Board.height { return false }
    if col + (moveX * 3) < 0 { return false }
    if col + (moveX * 3) >= Board.width { return false }
    
    // check for winning connection
    if stone(inColumn: col, row: row) != firstStone { return false }
    if stone(inColumn: col + moveX, row: row + moveY) != firstStone { return false }
    if stone(inColumn: col + (moveX * 2), row: row + (moveY * 2)) != firstStone { return false }
    if stone(inColumn: col + (moveX * 3), row: row + (moveY * 3)) != firstStone { return false }
    
    return true
  }
}

extension Board { // TODO: 1. redefine extension
  
  // MARK: - NSCopying
  func copy(with zone: NSZone? = nil) -> Any {
    let copy = Board()
    copy.setGameModel(self) // TODO: 4. modify call to setGameModel
    return copy
  }
  
  // MARK: - GKGameModel

  // TODO: 2. add vars 'players' and 'activePlayer'
  var players: [GKGameModelPlayer]? {
    return Player.allPlayers
  }
  var activePlayer: GKGameModelPlayer? {
    return currentPlayer
  }

  func setGameModel(_ gameModel: GKGameModel) { // TODO: 3. modify setGameModel function
    if let board = gameModel as? Board {
      spots = board.spots
      currentPlayer = board.currentPlayer
    }
  }

  func isWin(for player: GKGameModelPlayer) -> Bool { // TODO: 5. modify isWin function
    // TODO: 8. add code to isWin function.
  
    let stone = (player as! Player).stone

    for row in 0 ..< Board.height {
      for col in 0 ..< Board.width {
        if stonesMatch(firstStone: stone, row: row, col: col, moveX: 1, moveY: 0) {
          return true
        } else if stonesMatch(firstStone: stone, row: row, col: col, moveX: 0, moveY: 1) {
          return true
        } else if stonesMatch(firstStone: stone, row: row, col: col, moveX: 1, moveY: 1) {
          return true
        } else if stonesMatch(firstStone: stone, row: row, col: col, moveX: 1, moveY: -1) {
          return true
        }
      }
    }
    return false
  }

  func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? { // TODO: 6. modify gameModelUpdates function
    // TODO: 9. add code to gameModelUpdates function.
  
    if let playerObject = player as? Player {
      if isWin(for: playerObject) || isWin(for: playerObject.opponent) {
        return nil
      }

      var moves = [Move]()
      for column in 0 ..< Board.width {
        if canMove(in: column) {
          moves.append(Move(column: column))
        }
      }

      return moves
    }
  
    return nil
  }

  func apply(_ gameModelUpdate: GKGameModelUpdate) { // TODO: 7. modify apply function
    
    // TODO: 10. add code to apply function.
    if let move = gameModelUpdate as? Move {
      add(stone: currentPlayer.stone, in: move.column)
      currentPlayer = currentPlayer.opponent
    }
    
    
  }

  func score(for player: GKGameModelPlayer) -> Int { // TODO: 11. modify score function
    if let player = player as? Player {
      if isWin(for: player) { return 500 }
      else
      if isWin(for: player.opponent) { return -500 }
    }
    return 0
    }
}
