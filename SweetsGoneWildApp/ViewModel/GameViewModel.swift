//
//  GameViewModel.swift
//
// swiftlint:disable all

import SwiftUI
import Combine

final class GameViewModel: ObservableObject {
  @Published var size: CGSize = CGSize(width: 393, height: 851)
  @Published var isSplash = true
 // @AppStorage("isWelcome") var isWelcome = true
  @Published var isWelcome = true
  
// MARK: GAME
  // @AppStorage("balance") var balance = 1000
  @Published var balance = 1000
  @Published var shields = 0
  @Published var hints = 0
  @Published var extraShields = 0
  @Published var extraHints = 0
  @Published var challengelvl = 1
  @Published var moves = [4, 7, 5, 11, 10, 16, 15, 14, 13, 12]
  @Published var isFirstGame = true
  @Published var showGameOver = false
  @Published var menuLevel = 1
  @Published var levelPassed = [false, false, false, false, false, true, false, true, false, false]//Array(repeating: false, count: 10)
  @Published var levelMoves = Array(repeating: 0, count: 10)
 
  
  @Published var gameMatrix: [[Int]] = [[1, 2, 3], [2, 3, 4], [1, -1, 1], [1, 1, 2], [1, 1, 2]]

  @Published var openMatrix: [[Int]] = [[-1, -1, -1], [-1, -1, -1], [1, 1, 1]] //-1 closed 0 - open, 1 - already open
  @Published var openCount = 0
  
  //  @Published var openMatrix: [[Bool]] = [[true, false, true, true, false, true], [false, false, true, false, true, true], [false, false, true, false, true, true], [true, false, true, true, true, true],  [true, false, true, true, true, true]]
  
  // Game View
  @Published var isPause = false
  @Published var showInfo = false
  @Published var isBlocked = false
  @Published var showHint = false
  @Published var currentMoves = 0
  @Published var isWin = false
  @Published var isShield = false
  @Published var isAlreadyShielded = false
  @Published var wormTrails: [WormTrail] = []
  @Published var showShieldOver = false
  @Published var isBonusGame = false
  @Published var totalWin = 1500
  @Published var isChallengeCompleted = true
  
  
  @Published var showPopUp = false
  @Published var time = 0
  private var cancellables = Set<AnyCancellable>()

  
  @Published var showGame = false


  // MARK: Game Setup
  
  
  func generateLevel(level: Int) {
      let settings: [(worms: Int, items: ClosedRange<Int>, size: Int)] = [
          (1, 1...4, 3),
          (2, 1...7, 4),
          (4, 1...6, 4),
          (3, 1...11, 5),
          (5, 1...10, 5),
          (4, 1...16, 6),
          (6, 1...15, 6),
          (8, 1...14, 6),
          (10, 1...13, 6),
          (12, 1...12, 6)
      ]

      guard level >= 1 && level <= settings.count else { return }
      let config = settings[level - 1]
      let totalCells = config.size * config.size
      let worms = config.worms
      let itemSlots = totalCells - worms

      // 💡 Make sure itemSlots is even
      guard itemSlots % 2 == 0 else {
          print("⚠️ Cannot pair all items evenly — item slots is not divisible by 2")
          return
      }

      let uniquePairsNeeded = itemSlots / 2
      let itemRange = Array(config.items)

      guard uniquePairsNeeded <= itemRange.count else {
          print("⚠️ Not enough unique items in range to form \(uniquePairsNeeded) pairs.")
          return
      }

      // Create N unique item pairs
      let selectedItems = itemRange.shuffled().prefix(uniquePairsNeeded)
      var pairedItems = selectedItems.flatMap { [ $0, $0 ] }// each item appears twice
      pairedItems.shuffle()

      // Add worms
      let wormArray = Array(repeating: -1, count: worms)
      let allValues = (pairedItems + wormArray).shuffled()

      guard allValues.count == totalCells else {
          print("⚠️ Total values count doesn't match grid size.")
          return
      }

      // Build gameMatrix
      var matrix: [[Int]] = []
      for row in 0..<config.size {
          let start = row * config.size
          let end = start + config.size
          let rowValues = Array(allValues[start..<end])
          matrix.append(rowValues)
      }

      self.gameMatrix = matrix
      self.openMatrix = Array(repeating: Array(repeating: -1, count: config.size), count: config.size)
      self.openCount = 0
      self.currentMoves = 0
  }


//  func generateLevel(level: Int) {
//         let settings: [(worms: Int, items: ClosedRange<Int>, size: Int)] = [
//             (1, 1...4, 3),   // Level 1
//             (2, 1...7, 4),   // Level 2
//             (4, 1...5, 4),   // Level 3
//             (3, 1...11, 5),  // Level 4
//             (5, 1...10, 5),  // Level 5
//             (4, 1...16, 6),  // Level 6
//             (6, 1...15, 6),  // Level 7
//             (8, 1...14, 6),  // Level 8
//             (10, 1...13, 6), // Level 9
//             (12, 1...12, 6)  // Level 10
//         ]
//         
//         guard level >= 1 && level <= settings.count else { return }
//         let config = settings[level - 1]
//         let totalCells = config.size * config.size
//         let worms = config.worms
//         let itemRange = config.items
//         let itemsCount = totalCells - worms
//
//         var itemValues: [Int] = []
//         let uniqueItems = Array(itemRange)
//         var pairedItems: [Int] = []
//
//         while pairedItems.count < itemsCount {
//             for item in uniqueItems.shuffled() {
//                 pairedItems.append(item)
//                 pairedItems.append(item)
//                 if pairedItems.count >= itemsCount {
//                     break
//                 }
//             }
//         }
//
//         pairedItems = Array(pairedItems.prefix(itemsCount)).shuffled()
//         let wormSlots = Array(repeating: -1, count: worms)
//         let allValues = (pairedItems + wormSlots).shuffled()
//
//         var matrix: [[Int]] = []
//         for row in 0..<config.size {
//             let start = row * config.size
//             let end = start + config.size
//             let rowValues = Array(allValues[start..<end])
//             matrix.append(rowValues)
//         }
//         self.gameMatrix = matrix
//
//         // Generate openMatrix filled with -1 (all closed)
//         self.openMatrix = Array(repeating: Array(repeating: -1, count: config.size), count: config.size)
//         self.openCount = 0
//     }
  
  func checkResult() {
    let openPositions: [Position] = gameMatrix.indices.flatMap { i in
        gameMatrix[i].indices.compactMap { j in
            openMatrix[i][j] == 0 ? Position(row: i, col: j) : nil
        }
    }

      // 1. Check for worm

      for pos in openPositions {
          if gameMatrix[pos.row][pos.col] == -1 {
            if isShield {
              // 🛡️ Shield used!
              print("🛡️ Shield saved you!")
              openMatrix[pos.row][pos.col] = -1 // hide the worm again
              isShield = false
              openCount = 0
              return // stop here — no need to check match
            } else {
              print("you lose")
              if balance >= 250 && !isAlreadyShielded {
                showShieldOver =  true  // show shield over
              } else {
                showGameOver =  true
              }
              return
            }
          }
      }

      // 2. Wait until two cells are open
      guard openPositions.count == 2 else { return }

      currentMoves += 1
      let first = openPositions[0]
      let second = openPositions[1]
      let firstVal = gameMatrix[first.row][first.col]
      let secondVal = gameMatrix[second.row][second.col]

      if firstVal == secondVal {
          // Correct match
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
              self.openMatrix[first.row][first.col] = 1
              self.openMatrix[second.row][second.col] = 1
              self.openCount = 0 // ✅ reset here
              self.moveWorms()
              self.checkWin()
          }
      } else {
          // Incorrect match — close after delay
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
              self.openMatrix[first.row][first.col] = -1
              self.openMatrix[second.row][second.col] = -1
              self.openCount = 0 // ✅ reset here too
              self.moveWorms()
          }
      }
  }
  
  
  
  
//  func checkResult() {
//      let openPositions: [Position] = gameMatrix.indices.flatMap { i in
//          gameMatrix[i].indices.compactMap { j in
//              openMatrix[i][j] == 1 ? Position(row: i, col: j) : nil
//          }
//      }
//
//      // 1. Check for worm
//      for pos in openPositions {
//          if gameMatrix[pos.row][pos.col] == -1 {
//              print("you lose")
//              return
//          }
//      }
//
//      // 2. Wait until two cells are open
//      guard openPositions.count == 2 else { return }
//
//      let first = openPositions[0]
//      let second = openPositions[1]
//      let firstVal = gameMatrix[first.row][first.col]
//      let secondVal = gameMatrix[second.row][second.col]
//
//    if firstVal == secondVal {
//        // Match - keep open
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.openMatrix[first.row][first.col] = 1
//            self.openMatrix[second.row][second.col] = 1
//            self.openCount = 0
//            self.moveWorms()
//            self.checkWin()
//        }
//    } else {
//        // Not match - hide them again!
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.openMatrix[first.row][first.col] = -1
//            self.openMatrix[second.row][second.col] = -1
//            self.openCount = 0
//            self.moveWorms()
//        }
//    }
//  }

  func checkWin() {
      for i in 0..<gameMatrix.count {
          for j in 0..<gameMatrix[i].count {
              if gameMatrix[i][j] != -1 && openMatrix[i][j] != 1 {
                  return // Still items left to match
              }
          }
      }

      print("you win!")
  }
  
  func restartGame() {
    resetvm()
    generateLevel(level: menuLevel)
    showGameOver = false
  }
  
  func moveWorms() {
      wormTrails.removeAll()
      var newTrails: [WormTrail] = []

      var wormPositions: [Position] = []
      var emptyCells: [Position] = []

      for i in 0..<gameMatrix.count {
          for j in 0..<gameMatrix[i].count {
              let pos = Position(row: i, col: j)
              if gameMatrix[i][j] == -1 {
                  wormPositions.append(pos)
              } else {
                  emptyCells.append(pos)
              }
          }
      }

      for worm in wormPositions.shuffled() {
          let directions = [
              Position(row: -1, col: 0), Position(row: 1, col: 0),
              Position(row: 0, col: -1), Position(row: 0, col: 1)
          ]
          var moved = false

          for dir in directions.shuffled() {
              let newRow = worm.row + dir.row
              let newCol = worm.col + dir.col

              guard newRow >= 0, newRow < gameMatrix.count,
                    newCol >= 0, newCol < gameMatrix[newRow].count else { continue }

              if gameMatrix[newRow][newCol] != -1 {
                  let to = Position(row: newRow, col: newCol)

                  // Swap gameMatrix (worm <-> item)
                  gameMatrix[worm.row][worm.col] = gameMatrix[newRow][newCol]
                  gameMatrix[newRow][newCol] = -1

                  // Swap openMatrix accordingly
                  openMatrix[worm.row][worm.col] = openMatrix[newRow][newCol]
                  openMatrix[newRow][newCol] = -1

                  newTrails.append(WormTrail(from: worm, to: to))
                  moved = true
                  break
              }
          }

          if !moved, let random = emptyCells.randomElement() {
              // Swap gameMatrix (worm <-> item)
              gameMatrix[worm.row][worm.col] = gameMatrix[random.row][random.col]
              gameMatrix[random.row][random.col] = -1

              // Swap openMatrix accordingly
              openMatrix[worm.row][worm.col] = openMatrix[random.row][random.col]
              openMatrix[random.row][random.col] = -1

              newTrails.append(WormTrail(from: worm, to: random))
          }
      }

      self.wormTrails.append(contentsOf: newTrails)
  }

//  func moveWorms() {
//        wormTrails.removeAll() 
//      var newTrails: [WormTrail] = []
//      
//      var wormPositions: [Position] = []
//      var emptyCells: [Position] = []
//
//      for i in 0..<gameMatrix.count {
//          for j in 0..<gameMatrix[i].count {
//              let pos = Position(row: i, col: j)
//              if gameMatrix[i][j] == -1 {
//                  wormPositions.append(pos)
//              } else {
//                  emptyCells.append(pos)
//              }
//          }
//      }
//
//      for worm in wormPositions.shuffled() {
//          let directions = [
//              Position(row: -1, col: 0), Position(row: 1, col: 0),
//              Position(row: 0, col: -1), Position(row: 0, col: 1)
//          ]
//          var moved = false
//
//          for dir in directions.shuffled() {
//              let newRow = worm.row + dir.row
//              let newCol = worm.col + dir.col
//
//              guard newRow >= 0, newRow < gameMatrix.count,
//                    newCol >= 0, newCol < gameMatrix[newRow].count else { continue }
//
//              if gameMatrix[newRow][newCol] != -1 {
//                  let to = Position(row: newRow, col: newCol)
//                  gameMatrix[worm.row][worm.col] = gameMatrix[newRow][newCol]
//                  gameMatrix[newRow][newCol] = -1
//                  newTrails.append(WormTrail(from: worm, to: to))
//                  moved = true
//                  break
//              }
//          }
//
//          if !moved, let random = emptyCells.randomElement() {
//              gameMatrix[worm.row][worm.col] = gameMatrix[random.row][random.col]
//              gameMatrix[random.row][random.col] = -1
//              newTrails.append(WormTrail(from: worm, to: random))
//          }
//      }
//
//      self.wormTrails.append(contentsOf: newTrails)
//  }


  
  func startGame() {
    showGame = true
    wormTrails.removeAll()
  }
  
  func endGame() {
  }

  func resetGame() {
    extraShields = 0
    extraHints = 0
    isChallengeCompleted = false
    currentMoves = 0
    wormTrails.removeAll()
    isPause = false
    showInfo = false
  }

  func resetvm() {
    showPopUp = false
    resetGame()
  }

  // MARK: - Layout
  
  var h: CGFloat {
    size.height
  }
  
  var w: CGFloat {
    size.width
  }
  var header: CGFloat {
    isSEight ? -size.height*0.41 + 44 : -size.height*0.41
  }
  
  var isEightPlus: Bool {
    return size.width > 405 && size.height < 910 && size.height > 880 && UIDevice.current.name != "iPhone 11 Pro Max"
  }
  
  var isElevenProMax: Bool {
    UIDevice.current.name == "iPhone 11 Pro Max"
  }
  
  var isIpad: Bool {
    UIDevice.current.name.contains("iPad")
  }
  
  var isSE: Bool {
    return size.width < 380
  }

  var isSEight: Bool {
    return isSE || isEightPlus
  }
}

struct Position: Equatable, Hashable {
    let row: Int
    let col: Int
}


struct WormTrail: Identifiable {
  let id = UUID()
    let from: Position
    let to: Position
}
