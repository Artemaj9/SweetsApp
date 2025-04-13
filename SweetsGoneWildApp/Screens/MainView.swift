//
//  MainView.swift
//

import SwiftUI

struct MainView: View {
  @EnvironmentObject var vm: GameViewModel
  @EnvironmentObject var nm: NavigationStateManager
  @State private var startAnimation = false
  
    var body: some View {
      ZStack {
        Image(.menubgg)
          .backgroundFill()
          .saturation(startAnimation ? 1 : 0)
          .animation(.easeOut(duration: 1).delay(0.5), value: startAnimation)
        
        header
        
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
          HStack {
            Text("Challenge")
            Text("level \(vm.challengelvl)")
          }
          .padding()
        }
        
        .frame(344, 110)
        .yOffset(-vm.h*0.28)
        
        
        Image(.playbtn)
          .resizableToFit(height: 77)
          .asButton {
            nm.path.append(.game)
          }
          .transparentIfNot(startAnimation)
          .animation(.easeIn(duration: 0.5).delay(1.3), value: startAnimation)
          .xOffset(vm.w*0.25)
          .yOffset(-vm.h*0.1)
     
        Image(.flowers)
          .resizableToFit()
          .yOffset(vm.h*0.35)

      
      }
      .navigationDestination(for: SelectionState.self) { state in
        if state == .game { Game() }
        if state == .info { Info() }
      }
      .onAppear {
        startAnimation = true
      }
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
}

#Preview {
    MainView()
    .vm
    .nm
}
