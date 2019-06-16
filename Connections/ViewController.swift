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

 1. Modify updateGame's call to board.isWin().

 Demo 2

 2. Set strategist var.
 3. Set board var.
 4. Populate processAIMove function.
 
 */

import UIKit
import AVFoundation

class ViewController: UIViewController {
  
  // MARK: - Properties
  
  @IBOutlet weak var playerLabel: UILabel!
  @IBOutlet weak var gameBoard: UIStackView!
  @IBOutlet var columnButtons: [UIButton]!
  
  var board = Board()
  var strategist: Strategist!
  var stonesInPlay = [[UIImageView]]()
  var player: AVAudioPlayer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    for _ in 0 ..< Board.width {
      stonesInPlay.append([UIImageView]())
    }
    
    // TODO: 2. set strategist
    strategist = Strategist(board: board)
    resetBoard()
  }
  
  func resetBoard() {
    board = Board()
    // TODO: 3. set board
    strategist.board = board
    
    for i in 0 ..< stonesInPlay.count {
      for stone in stonesInPlay[i] {
        stone.removeFromSuperview()
      }
      stonesInPlay[i].removeAll(keepingCapacity: true)
    }
    
    playerLabel.font = UIFont(name: "DAZE", size: 34)
    playerLabel.text = "\(board.currentPlayer.name)'s Turn"
  }
  
  func updateGame() {
    var gameOverTitle: String? = nil

    if board.isWin(for: board.currentPlayer) { // TODO: 1. modify call to board.isWin()
      gameOverTitle = "\(board.currentPlayer.name) Wins!"
    } else if board.isFull() {
      gameOverTitle = "Draw!"
    }

    if gameOverTitle != nil {
      let alert = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "Play Again", style: .default) { _ in
        self.resetBoard()
      }
      
      alert.addAction(alertAction)
      present(alert, animated: true)
      
      return
    }
    
    board.currentPlayer = board.currentPlayer.opponent
    
    playerLabel.text = "\(board.currentPlayer.name)'s Turn"
    if board.currentPlayer.stone == .black {
      processAIMove()
    }
  }
  
  // MARK: - Game Logic
  
  // Human Player
  @IBAction func takeTurn(_ sender: UIButton) {
    let column = sender.tag
    print("takeTurn: \(column)")
    
    if let row = board.nextEmptySpot(in: column) {
      board.add(stone: board.currentPlayer.stone, in: column)
      addStone(inColumn: column, row: row, color: board.currentPlayer.color)
      updateGame()
    }
  }
  
  // Artificial Intelligence
  func processAIMove() {

    // TODO: 4. add code to process AI move
    
    columnButtons.forEach { $0.isEnabled = false } // wylacza przyciski dla interakcji uzytkownika

    DispatchQueue.global().async { [unowned self] in
      let strategistTime = CFAbsoluteTimeGetCurrent()

      guard let column = self.strategist.bestMoveForAI() else {
        return
      }

      let delta = CFAbsoluteTimeGetCurrent() - strategistTime

      let aiWaitTime = 1.0
      let delay = min(aiWaitTime - delta, aiWaitTime)

      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        self.makeAIMove(in: column)
      }
    }
    
  }
  
  func makeAIMove(in column: Int) {
    columnButtons.forEach { $0.isEnabled = true }
    
    if let row = board.nextEmptySpot(in: column) {
      board.add(stone: board.currentPlayer.stone, in: column)
      addStone(inColumn: column, row:row, color: board.currentPlayer.color)
      updateGame()
    }
  }
  
  // MARK: - Board Updates
  
  func positionForStone(inColumn column: Int, row: Int) -> CGPoint {
    let button = columnButtons[column]
    let size = min(button.frame.width, button.frame.height / 6)
    
    let xOffset = button.frame.midX + gameBoard.frame.minX
    var yOffset = button.frame.maxY - size / 2 + gameBoard.frame.minY
    yOffset -= size * CGFloat(row)
    
    print("\(CGPoint(x: xOffset, y: yOffset))")
    return CGPoint(x: xOffset, y: yOffset)
  }
  
  func addStone(inColumn column: Int, row: Int, color: UIImage) {
    let button = columnButtons[column]
    let size = min(button.frame.width, button.frame.height / 6)
    let rect = CGRect(x: 0, y: 0, width: size, height: size)
    
    if (stonesInPlay[column].count < row + 1) {
      let stone = UIImageView()
      stone.image = color
      stone.frame = rect
      stone.contentMode = .scaleAspectFit
      stone.isUserInteractionEnabled = false
      stone.backgroundColor = .clear
      stone.center = positionForStone(inColumn: column, row: row)
      stone.transform = CGAffineTransform(rotationAngle: CGFloat.pi).concatenating(CGAffineTransform(translationX: 0, y: -800))
      
      view.addSubview(stone)
      
      // Animate Drop
      UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
        self.playSound()
        stone.transform = CGAffineTransform.identity
      })
      
      stonesInPlay[column].append(stone)
    }
  }
  
  func playSound() {
    guard let sound = NSDataAsset(name: "whoop") else {
      print("asset not found")
      return
    }
    
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
      try AVAudioSession.sharedInstance().setActive(true)
        
        // BART: auto corrected to .rawValue
        player = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileType.mp3.rawValue)
      
      player!.play()
    } catch let error as NSError {
      print("error: \(error.localizedDescription)")
    }
  }
  
  // MARK: - View Controller
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}
