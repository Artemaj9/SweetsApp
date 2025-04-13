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
  @Published var challengelvl = 1

  @Published var isWin = false
  @Published var showPopUp = false
  @Published var time = 0
  private var cancellables = Set<AnyCancellable>()


  @Published var showNoMoney = false
  @Published var isGameOver = false
  @Published var playerWon = false
  @Published var finalWinnings: Int = 0
  @Published var turnOn = true
  @Published var bet: Int = 100

  // MARK: Game Setup
  func startGame() {
   
  }
  
  func endGame() {
  }
  

  
  
  func resetGame() {
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
    isSEight ? -size.height*0.42 + 44 : -size.height*0.42
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
