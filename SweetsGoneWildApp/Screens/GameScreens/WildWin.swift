//
//  WildWin.swift
//

import SwiftUI

struct WildWin: View {
  @EnvironmentObject var vm: GameViewModel
  @EnvironmentObject var nm: NavigationStateManager
  @State private var startAnimation = false
  
    var body: some View {
      ZStack {
        bg
        
        Image(.wildbg)
          .resizableToFit()
          .yOffset(-vm.h*0.2)
        
        Image(.wildwin)
          .resizableToFit()
          .overlayMask {
            LiquidMetal(effect: "gradientShader")
              .grayscale(1)
              .opacity(0.7)
              .blendMode(.luminosity)
          }
          .overlay {
            Image(.wildwin)
            .resizableToFit()
            .saturation(1.5)
            .opacity(0.7)
          }
          .hPadding()
          .yOffset(-vm.h*0.1)
        
        Image(.bonusgamecompl)
          .resizableToFit(height: 38)
          .yOffset(vm.h*0.1)
        
        Image(.fullbonus)
          .resizableToFit()
          .yOffset(vm.h*0.24)
        
        contbtn
        
        LiquidMetal(effect: "rainbowShader")
          .scaleEffect(2)
          .opacity(startAnimation ? 0 : 1)
          .animation(.easeIn(duration: 1), value: startAnimation)
      }
      .ignoresSafeArea()
      .onAppear {
        startAnimation = true
      }
    }
  
  @ViewBuilder private var bg: some View {
    Image(.bglevels)
      .backgroundFill()
    BackBlurView(radius: 5)
    Color.black.opacity(0.3)
  }
  
  
  private var contbtn: some View {
    Button {
      vm.endGame()
    } label: {
      Image(.capsulered)
        .resizableToFit(height: 80)
        .overlayMask {
          LiquidMetal(effect: "gradientShader")
            .grayscale(1)
            .opacity(0.7)
            .blendMode(.luminosity)
        }
        .overlay {
          Image(.capsulered)
            .resizableToFit(height: 80)
            .saturation(1.5)
            .opacity(0.7)
        }
        .overlay {
          Image(.continuer)
            .resizableToFit(height: 36)
        }
    }
    .yOffset(vm.h*0.4)
  }
  
}

#Preview {
    WildWin()
    .vm
    .nm
}
