//
//  MainView.swift
//

import SwiftUI

struct MainView: View {
  @EnvironmentObject var vm: GameViewModel
  @EnvironmentObject var nm: NavigationStateManager
  @State private var startAnimation = false
  
  var body: some View {
    NavigationStack(path: $nm.path) {
      ZStack {
        bg
        header
        decoration
        challengePlane
        playbtn
        flowers
      }
      .navigationDestination(for: SelectionState.self) { state in
        if state == .game { MenuLevels() }
        if state == .info { Info() }
      }
      .onAppear {
        startAnimation = true
      }
    }
  }
  
  private var bg: some View {
    Image(.menubgg)
      .backgroundFill()
      .saturation(startAnimation ? 1 : 0)
      .animation(.easeOut(duration: 1).delay(0.5), value: startAnimation)
  }
  
  private var header: some View {
    HStack {
      Image(.infobtn)
        .resizableToFit(height: 55)
        .asButton {
          nm.path.append(.info)
        }
      
      Spacer()
      
      Balance()
    }
    .padding(.trailing, 30)
    .padding(.leading, 8)
    .yOffset(vm.header)
    .transparentIfNot(startAnimation)
    .animation(.easeIn(duration: 0.5).delay(1.3), value: startAnimation)
  }
  
  private var challengePlane: some View {
    LinearGradient(stops:
                    [
                      .init(color: Color.white, location: 0),
                      .init(color: Color(hex: "00F2E9"), location: 0.44),
                      .init(color: Color(hex: "0094D0"), location: 0.76),
                      .init(color: Color.white, location: 1)],
                   startPoint: .top, endPoint: .bottom)
    .mask {
      RoundedRectangle(cornerRadius: 15)
        .stroke(lineWidth: 4)
      
    }
    .background {
      BackBlurView(radius: 5)
    }
    .overlay(.topLeading) {
      HStack(spacing: 0) {
        LinearGradient(
          colors: [
            Color(hex: "00C6B5"),
            Color(hex: "180060"),],
          startPoint: .top, endPoint: .bottom)
        .frame(120, 40)
        .mask {
          Text("Challenge")
            .sweetFont(size: 25, style: .skranjiReg, color: .white)
        }
        .customStroke(color: .white, width: 2)
        .customStroke(color: Color(hex: "00F2E9"), width: 1,offset: .init(width: 0, height: 2))
        .compositingGroup()
        .shadow(color: Color(hex: "0074A3"), radius: 1, y: 4)
        
        
        LinearGradient(
          colors: [
            Color(hex: "FF035A"),
            Color(hex: "FE88B2"),],
          startPoint: .top, endPoint: .bottom)
        .frame(80, 40)
        .mask(alignment: .leading) {
          Text("level \(vm.challengelvl)")
            .sweetFont(size: 25, style: .skranjiReg, color: .white)
        }
        .customStroke(color: .white, width: 2)
        .customStroke(color: Color(hex: "00F2E9"), width: 1,offset: .init(width: 0, height: 2))
        .compositingGroup()
        .shadow(color: Color(hex: "0074A3"), radius: 1, y: 4)
      }
      .padding(.top, 8)
      .padding(.leading, 8)
    }
    .overlay(.leading) {
      Text("Complete the level in \(vm.moves[vm.challengelvl - 1]) moves\nand unlock the Bonus Game!")
        .sweetFont(size: 14, style: .skranjiReg, color: .white)
        .customStroke(color: Color(hex: "00A49E"), width: 1)
        .padding()
        .yOffset(24)
      
    }
    .overlay(.trailing, content: {
      Image(.gobtn)
        .resizableToFit(height: 60)
        .asButton {
          nm.path.append(.game)
        }
        .padding(.trailing, 8)
    })
    .frame(344, 110)
    .yOffset(-vm.h*0.28)
    .transparentIfNot(startAnimation)
    .animation(.easeInOut.delay(1), value: startAnimation)
  }
  
  @ViewBuilder private var decoration: some View {
    Image(.wormmenu)
      .resizableToFit(height: 200)
      .xOffset(vm.w*0.24)
      .yOffset(startAnimation ? vm.h*0.38 : vm.h)
      .animation(.easeOut(duration: 1).delay(2), value: startAnimation)
    
    Image(.snailmenu)
      .resizableToFit(height: 350)
      .xOffset(startAnimation ? -vm.w*0.2 : -vm.w*0.9)
      .yOffset(startAnimation ? vm.h*0.1 : 0)
      .animation(.smooth(duration: 3).delay(0.2), value: startAnimation)
    Image(.flowerw)
      .resizableToFit(height: 510)
      .xOffset(startAnimation ? vm.w*0.3 : vm.w)
      .animation(.smooth(duration: 2), value: startAnimation)
  }
  
  private var playbtn: some View {
    Image(.playbtn)
      .resizableToFit(height: 77)
      .asButton {
        nm.path.append(.game)
      }
      .transparentIfNot(startAnimation)
      .animation(.easeIn(duration: 0.5).delay(1.3), value: startAnimation)
      .xOffset(vm.w*0.25)
      .yOffset(-vm.h*0.1)
  }
  
  private var flowers: some View {
    Image(.flowers)
      .resizableToFit()
      .yOffset(vm.h*0.35)
  }
}

#Preview {
  MainView()
    .vm
    .nm
}
