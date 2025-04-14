//
//  MenuLevels.swift
//

import SwiftUI

struct MenuLevels: View {
  @EnvironmentObject var vm: GameViewModel
  @EnvironmentObject var nm: NavigationStateManager
  @State private var startAnimation = false
  
    var body: some View {
      ZStack {
        bg
        header
        levelPlane
        decor
        playbtn
      }
      .navigationBarBackButtonHidden()
      .onAppear {
        startAnimation = true
      }
    }
  
  private var bg: some View {
    Image(.bglevels)
      .backgroundFill()
      .gesture(
                    DragGesture(minimumDistance: 5.0, coordinateSpace: .local)
                        .onEnded { value in
                          if value.translation.width < -50 && abs(value.translation.height) < 50  {
                              withAnimation {
                                if vm.menuLevel < 10 {
                                  vm.menuLevel += 1
                                } else {
                                  vm.menuLevel = 1
                                }
                              }
                            } else if value.translation.width > 50 && abs(value.translation.height) < 50 {
                              withAnimation {
                                if vm.menuLevel > 1 {
                                  vm.menuLevel -= 1
                                } else {
                                  vm.menuLevel = 10
                                }
                              }
                            }
                        }
                )

  }
  
  @ViewBuilder private var decor: some View {
    Image("fl\(vm.menuLevel)")
      .resizableToFit(width: vm.w)
      .allowsHitTesting(false)
      .yOffset(vm.h*0.2)
      .xOffset(-vm.w*0.15)
    
    Image(.snaillevels)
      .resizableToFit(height: 320)
      .offset(startAnimation ? vm.w*0.3 : vm.w*0.7, vm.h*0.4)
      .animation(.smooth(duration: 0.7), value: startAnimation)
    
    Image(.fworm)
      .resizableToFit(height: 280)
      .yOffset(startAnimation ? vm.h*0.55 : vm.h*0.9)
      .xOffset(-vm.w*0.2)
      .animation(.smooth(duration: 0.7), value: startAnimation)
  }
  
  private var header: some View {
    HStack {
      Image(.homebtn)
        .resizableToFit(height: 55)
        .asButton {
            nm.path = []
        }
      
      Spacer()
      
      Balance()
    }
    .padding(.trailing, 30)
    .padding(.leading, 8)
    .yOffset(vm.header)
    .transparentIfNot(startAnimation)
    .animation(.easeIn(duration: 0.5).delay(0.4), value: startAnimation)
  }
  
  
  private var levelPlane: some View {
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
    .overlay(.bottomTrailing) {
      Image(vm.levelPassed[vm.menuLevel - 1] ? .greenlvl : .redmlvl)
        .resizableToFit(height: 55)
        .overlay {
          LinearGradient(
            colors: [
              Color(hex: "FF035A"),
              Color(hex: "FE88B2"),],
            startPoint: .top, endPoint: .bottom)
          .frame(50, 40)
          .mask(alignment: .center) {
            Text("\(vm.levelMoves[vm.menuLevel - 1])/\(vm.moves[vm.menuLevel - 1])")
              .sweetFont(size: 25, style: .skranjiReg, color: .white)
          }
          .customStroke(color: .white, width: 2)
          .customStroke(color: Color(hex: "00F2E9"), width: 1,offset: .init(width: 0, height: 2))
          .compositingGroup()
          .shadow(color: Color(hex: "0074A3"), radius: 1, y: 4)
        }
        .offset(-8,46)
    }
    .overlay(.top) {
      HStack {
        Button {
          withAnimation {
            if vm.menuLevel > 1 {
              vm.menuLevel -= 1
            } else {
              vm.menuLevel = 10
            }
          }
      
        } label: {
          Image(.bckbtn)
            .resizableToFit(height: 55)
        }
        
        LinearGradient(
          colors: [
            Color(hex: "FF035A"),
            Color(hex: "FE88B2"),],
          startPoint: .top, endPoint: .bottom)
        .frame(180, 40)
        .mask(alignment: .center) {
          Text("Level \(vm.menuLevel)")
            .sweetFont(size: 50, style: .skranjiReg, color: .white)
        }
        .customStroke(color: .white, width: 2)
        .customStroke(color: Color(hex: "00F2E9"), width: 1,offset: .init(width: 0, height: 2))
        .compositingGroup()
        .shadow(color: Color(hex: "0074A3"), radius: 1, y: 4)
        
        Button {
          withAnimation {
            if vm.menuLevel < 10 {
              vm.menuLevel += 1
            } else {
              vm.menuLevel = 1
            }
          }
      
        } label: {
          Image(.nxtbtn)
            .resizableToFit(height: 55)
        }
      }
      .yOffset(-48)
    }
    .overlay(.top) {
      HStack(spacing: 0) {
        LinearGradient(
          colors: [
            Color(hex: vm.levelPassed[vm.menuLevel - 1] ? "2BC600" :"FF0000"),
            Color(hex: vm.levelPassed[vm.menuLevel - 1] ? "006036" : "530000")
          ],
          startPoint: .top, endPoint: .bottom)
        .frame(320, 40)
        .mask {
          Text(vm.levelPassed[vm.menuLevel - 1] ? "Challenge Completed" : "Challenge Not Completed")
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
    .overlay {
      Text(vm.levelPassed[vm.menuLevel - 1] ? "Nice job! You successfully finished \nthe challenge!" : "Finish the level within the move limit to complete the challenge and unlock the bonus game!")
        .sweetFont(size: 14, style: .skranjiReg, color: .white)
        .customStroke(color: Color(hex: "00A49E"), width: 1)
        .multilineTextAlignment(.center)
        .hPadding(8)
        .yOffset(24)
    }
    .frame(344, 110)
    .yOffset(-vm.h*0.23)
    .transparentIfNot(startAnimation)
    .animation(.easeInOut, value: startAnimation)
  }
  
  private var playbtn: some View {
    Button {
      vm.resetvm()
      vm.generateLevel(level: vm.menuLevel)
      nm.path.append(.play)
    //  vm.showGame = true
    } label: {
      Image(.startgamebtn)
        .resizableToFit(height: 170)
    }
    .offset(vm.w*0.25, vm.h*0.05)
  }
}

#Preview {
    MenuLevels()
    .nm
    .vm
}
