//
//  BonusGame.swift
//

import SwiftUI

struct BonusGame: View {
  @EnvironmentObject var vm: GameViewModel
  @EnvironmentObject var nm: NavigationStateManager
  @State private var startAnimation = false
  var body: some View {
    ZStack {
      bg
      header
      bunustitle
    
      
      Image(.bonusframe)
        .resizableToFit()
        .overlay(.bottom) {
          HStack(spacing: 0) {
            Image(.matches)
              .resizableToFit(height: 34)
            LinearGradient(
              colors: [
                Color(hex: "FF035A"),
                Color(hex: "FE88B2"),],
              startPoint: .top, endPoint: .bottom)
            .frame(40, 40)
            .mask(alignment: .leading) {
              Text("\(vm.matches)")
                .sweetFont(size: 25, style: .skranjiReg, color: .white)
            }
            .customStroke(color: .white, width: 2)
            .customStroke(color: Color(hex: "00F2E9"), width: 1,offset: .init(width: 0, height: 2))
            .compositingGroup()
            .shadow(color: Color(hex: "0074A3"), radius: 1, y: 4)
            .yOffset(-4)
            
          }
          .xOffset(8)
          .yOffset(34)
        }
        .allowsHitTesting(false)
        .background {
          ZStack {
            BackBlurView(radius: 10)
            VStack(spacing: 0) {
              ForEach(0..<vm.bonusMatrix.count) { i in
                HStack(spacing: 0) {
                  ForEach(0..<vm.bonusMatrix[i].count) { j in
                    ZStack {
                      
                      Image("i\(vm.bonusMatrix[i][j])")
                        .resizableToFit()
                      
                      Image(.btile)
                        .resizableToFit()
                        .drawingGroup(opaque: false)
                        .transparentIf(
                            vm.openBonusMatrix[i][j] != -1 || vm.bonusIsPreviewing
                        )
                        .animation(.easeInOut, value: vm.openBonusMatrix[i][j] != -1 || vm.bonusIsPreviewing)
                        .onTapGesture {
                          guard !vm.bonusGameOver else { return }
                          guard !vm.bonusIsPreviewing else { return }
                          guard vm.openBonusMatrix[i][j] == -1 else { return }
                          
                          vm.openBonusMatrix[i][j] = 0
                          
                          let openTiles = vm.openBonusMatrix.flatMap { $0 }.filter { $0 == 0 }.count
                          
                          if openTiles.isMultiple(of: 2) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                              vm.checkBonusResult()
                            }
                          }
                        }
                    }
                  }
                }
              }
            }
            .padding(8)
          }
        }
        .yOffset(-vm.h*0.07)
        .compositingGroup()
        .padding()
      
      rewardsPlane
      pause
    }
    .onAppear {
      startAnimation = true
      vm.bonusIsPreviewing = true

      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
          vm.bonusIsPreviewing = false
      }
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
  
  private var bunustitle: some View {
    Text("Flip tiles to find matching pairs. Every perfect match\nwins a reward, but one mistake ends the game.\nAll rewards you earn stack up.")
      .sweetFont(size: 13, style: .snigletreg, color: .white)
      .customStroke(color: Color(hex: "00A49E"), width: 1)
      .multilineTextAlignment(.center)
      .yOffset(-vm.h*0.3)
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
  
  private var rewardsPlane: some View {
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
    .overlay(.top) {
      Image(.rewardst)
        .resizableToFit(height: 38)
        .padding(.top, 8)
    }
    .overlay {
      HStack {
        VStack(spacing: -3) {
          ForEach(1..<6) { i in
            ZStack {
              Image("br\(i)")
                .resizableToFit(width: 160)
              Image("br\(i)a")
                .resizableToFit(width: 160)
                .transparentIfNot(vm.matches >= i)
                .animation(.easeInOut, value: vm.matches >= i)
            }
          }
        }
        
        VStack(spacing: -3) {
          ForEach(6..<11) { i in
            ZStack {
              Image("br\(i)")
                .resizableToFit(width: 160)
              Image("br\(i)a")
                .resizableToFit(width: 160)
                .transparentIfNot(vm.matches >= i)
                .animation(.easeInOut, value: vm.matches >= i)
            }
          }
        }
      }
      .yOffset(12)
      
    }
    .hPadding()
    .frame(height: 214)
    .yOffset(vm.h*0.29)
  }
}

#Preview {
  BonusGame()
    .vm
    .nm
}
