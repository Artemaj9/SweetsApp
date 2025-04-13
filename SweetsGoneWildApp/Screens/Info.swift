//
//  Info.swift
//

import SwiftUI

struct Info: View {
  @EnvironmentObject var vm: GameViewModel
  @EnvironmentObject var nm: NavigationStateManager
  
    var body: some View {
      ZStack {
        Text("Info")
      }
      .navigationBarBackButtonHidden()
    }
}

#Preview {
    Info()
}
