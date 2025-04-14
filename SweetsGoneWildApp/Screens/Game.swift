//
//  Game.swift
//

import SwiftUI

struct Game: View {
  @EnvironmentObject var vm: GameViewModel
  @EnvironmentObject var nm: NavigationStateManager
  @State private var startAnimation = false
  @State var cellSize: CGSize = CGSize(width: 60, height: 60)
  
  var body: some View {
    ZStack {
      bg
      header
      shop
      
      Image(.frameblue)
        .resizableToFit()
        .overlay(.bottom) {
          LinearGradient(
            colors: [
              Color(hex: "FF035A"),
              Color(hex: "FE88B2"),],
            startPoint: .top, endPoint: .bottom)
          .frame(580, 40)
          .mask(alignment: .center) {
            Text("Your moves: \(vm.currentMoves)")
              .sweetFont(size: 25, style: .skranjiReg, color: .white)
          }
          .customStroke(color: .white, width: 2)
          .customStroke(color: Color(hex: "00F2E9"), width: 1,offset: .init(width: 0, height: 2))
          .compositingGroup()
          .shadow(color: Color(hex: "0074A3"), radius: 1, y: 4)
          .yOffset(24)
        }
        .allowsHitTesting(false)
        .background {
          ZStack {
              BackBlurView(radius: 10)


            
            VStack(spacing: 0) {
              ForEach(0..<vm.gameMatrix.count) { i in
                HStack(spacing: 0) {
                  ForEach(0..<vm.gameMatrix[i].count) { j in
                    ZStack {
                      if i == 0 && j == 0 {
                        Image("i\(vm.gameMatrix[i][j])")
                          .resizableToFit()
                          .readSize($cellSize)
                      } else {
                        Image("i\(vm.gameMatrix[i][j])")
                          .resizableToFit()
                      }
                      Image(.question)
                        .resizableToFit()
                        .drawingGroup(opaque: false)
                        .transparentIfNot(
                            vm.openMatrix[i][j] == -1 &&
                            !(vm.currentMoves == 0 && vm.gameMatrix[i][j] == -1)
                        )
                        .animation(.easeInOut, value: vm.openMatrix[i][j] == -1)
                        .onTapGesture {
                            guard vm.openCount < 2 else { return }

                            if vm.openMatrix[i][j] == -1 {
                                vm.openMatrix[i][j] = 0  // ✅ temporary open
                                vm.openCount += 1
                              if vm.openCount == 1 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                  vm.checkResult()
                                }
                              }
                                if vm.openCount == 2 {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        vm.checkResult()
                                    }
                                }
                            }
                        }
//                        .onTapGesture {
//                          if vm.openMatrix[i][j] == -1 {
//                            vm.openMatrix[i][j] = 1
//                            vm.openCount += 1
//                          }
//                          if vm.openCount == 1 {
//                            vm.checkResult()
//                          }
//                        }
                    }
                  }
                }
                
              }
            }
            .compositingGroup()
           .padding()
            
            
            let gridRows = vm.gameMatrix.count
            let gridCols = vm.gameMatrix.first?.count ?? 0

            let gridWidth = CGFloat(gridCols) * cellSize.width
            let gridHeight = CGFloat(gridRows) * cellSize.height

            ForEach(vm.wormTrails) { trail in
                let from = trail.from
                let to = trail.to

                let isHorizontal = from.row == to.row

              let fromX = CGFloat(from.col + 1) * cellSize.width - 0.5*cellSize.width //- gridWidth / 2
              let fromY = CGFloat(from.row + 1) * cellSize.height - 0.5*cellSize.height //- gridHeight / 2
                let toX = CGFloat(to.col + 1) * cellSize.width  - 0.5*cellSize.width //- gridWidth / 2
                let toY = CGFloat(to.row + 1) * cellSize.height - 0.5*cellSize.height //- gridHeight / 2

                let midX = (fromX + toX) / 2
                let midY = (fromY + toY) / 2

                let rectWidth: CGFloat = isHorizontal ? cellSize.width : 20
                let rectHeight: CGFloat = isHorizontal ? 20 : cellSize.height

                Rectangle()
                .fill(LinearGradient(colors: [Color(hex: "#FF004D").opacity(0), Color(hex: "#FF004D"), Color(hex: "#FF004D").opacity(0)], startPoint: isHorizontal ? .leading : .top, endPoint: isHorizontal ? .trailing : .bottom))
                    .frame(width: rectWidth, height: rectHeight)
                    .cornerRadius(3)
                    .offset(-gridWidth/2, -gridHeight / 2)
                    .offset(x: midX, y: midY)
            }

          }
        }
        .hPadding(8)
        .yOffset(vm.h*0.08)
      
     pause
      
      ShieldOver()
        .transparentIfNot(vm.showShieldOver)
        .animation(.easeInOut, value: vm.showGameOver)
      
      GameOver()
        .transparentIfNot(vm.showGameOver)
        .animation(.easeInOut, value: vm.showGameOver)
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      startAnimation = true
     // vm.generateLevel(level: 1)
    }
  }
  
  private var bg: some View {
    Image(.bglevels)
      .backgroundFill()
  }
  
  private var header: some View {
    HStack {
      Image(.pausebtn)
        .resizableToFit(height: 55)
        .asButton {
          vm.isPause = true
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
  
  private var shop: some View {
    HStack(spacing: 0) {
      Image(.hintshopbg)
        .resizableToFit(height: vm.w*0.4)
        .overlay(.bottom) {
          Image(vm.balance >= 150 ? .hintpricebtn : .hintpricebtninact)
            .resizableToFit(height: 80)
            .asButton {
              if vm.balance >= 150 && !vm.isBlocked {
                vm.balance -= 150
                vm.isBlocked = true
                vm.showHint = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  vm.isBlocked = false
                  vm.showHint = false
                }
              }
            }
            .disabled(vm.balance < 150)
            .yOffset(16)
        }
      
      Image(.shieldshopbg)
        .resizableToFit(height: vm.w*0.4)
        .overlay(.bottom) {
          Image(vm.balance >= 250 && !vm.isAlreadyShielded ? .sshieldpricebtn : .sshieldpricebtninact)
            .resizableToFit(height: 80)
            .asButton {
              if vm.balance >= 250 && !vm.isBlocked && !vm.isAlreadyShielded {
                vm.balance -= 250
                vm.isShield = true
                vm.isAlreadyShielded = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  vm.isBlocked = false
                }
              }
            }
            .disabled(vm.balance < 250 || vm.isAlreadyShielded)
            .yOffset(16)
        }
    }
    .yOffset(-vm.h*0.27)
    
  }
  
  private var pause: some View {
    ZStack {
      if vm.isPause {
        PauseView()
      }
    }
    .transparentIfNot(vm.isPause)
    .animation(.easeInOut, value: vm.isPause)
  }
  
  private var firstInfo: some View {
    ZStack {
      if vm.isFirstGame {
        Info(isFirst: true, isFromMenu: false)
      }
    }
    .transparentIfNot(vm.isFirstGame)
    .animation(.easeInOut, value: vm.isFirstGame)
  }
}

#Preview {
  Game()
    .vm
    .nm
}
