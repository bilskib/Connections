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

 1. Redefine class to conform to GKGameModelPlayer.
 2. Add required 'playerId' var.
 3. Set playerId to stone's raw value during init.

 */

import GameplayKit

enum StoneColor: Int {
  case none = 0
  case red
  case black
}

class Player: NSObject, GKGameModelPlayer { // TODO: 1. redefine class
  
  var stone: StoneColor
  var color: UIImage
  var name: String
  
    
 // TODO: 2. add var 'playerId'
  var playerId: Int
  
  static var allPlayers = [Player(stone: .red), Player(stone: .black)]
  
  var opponent: Player {
    if stone == .red {
      return Player.allPlayers[1]
    } else {
      return Player.allPlayers[0]
    }
  }
  
  init(stone: StoneColor) {
    self.stone = stone
 // TODO: 3. set playerId
    self.playerId = stone.rawValue
    
    if stone == .red {
      color = UIImage(named: "Red")!
      name = "Red Stone"
    } else {
      color = UIImage(named: "Black")!
      name = "Black Stone"
    }
    
    super.init()
  }
}
