//
//  NavigationStateManager.swift
//

import Foundation

enum SelectionState: Hashable, Codable {
  case info
  case game
  case play
}

class NavigationStateManager: ObservableObject {
  @Published var path = [SelectionState]()
}
