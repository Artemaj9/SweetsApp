//
//  Balance.swift
//

import SwiftUI

struct Balance: View {
  @EnvironmentObject var vm: GameViewModel
  
    var body: some View {
      LinearGradient(
        stops: [.init(color: .white, location: 0),
                .init(color: Color(hex: "F19294"), location: 0.57),
                .init(color: Color(hex: "F19294"), location: 0.57),
                .init(color: Color(hex: "FFB327"), location: 1)], startPoint: .top, endPoint: .bottom)
      .frame(165, 48)
      .scaleEffect(1.1)
      .mask {
        RoundedRectangle(cornerRadius: 15)
          .stroke(lineWidth: 4)
          .frame(165, 48)
      }
      .overlay(.trailing) {
        Image(.coin)
          .resizableToFit(height: 55)
          .xOffset(20)
      }
      .overlay {
        LinearGradient(
          colors: [
            Color(hex: "FF6803"),
            Color(hex: "FFE944"),],
          startPoint: .top, endPoint: .bottom)
        .frame(160, 40)
        .mask {
          Text("\(vm.balance)")
            .sweetFont(size: 25, style: .skranjiReg, color: .white)
        }
        .customStroke(color: .white, width: 2)
        .customStroke(color: Color(hex: "00F2E9"), width: 1,offset: .init(width: 0, height: 2))
        .compositingGroup()
        .shadow(color: Color(hex: "0074A3"), radius: 1, y: 4)
      }
      .background {
        BackBlurView(radius: 5)
      }
    }
}

#Preview {
    Balance()
    .vm
}
