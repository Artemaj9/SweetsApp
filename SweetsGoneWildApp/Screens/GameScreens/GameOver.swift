//
//  GameOver.swift
//

import SwiftUI

struct GameOver: View {
  @EnvironmentObject var vm: GameViewModel
  @EnvironmentObject var nm: NavigationStateManager
    var body: some View {
      ZStack {
        bg
        VStack(spacing: -4) {
          Image(.gameovertitle)
            .resizableToFit()
            .hPadding(8)
            
          Image(.gameoversubtitle)
            .resizableToFit(height: 34)
          
          Text("But don’t worry—try again and\noutsmart it next time!")
            .sweetFont(size: 20, style: .snigletreg, color: .white)
            .customStroke(color: Color(hex: "00A49E"), width: 1)
            .multilineTextAlignment(.center)
            .padding(.vertical)
          
          restartbtn
          menubtn
        }
        .yOffset(-vm.h*0.05)
        
      }
      .ignoresSafeArea()
    }
  
  @ViewBuilder private var bg: some View {
    BackBlurView(radius: 5)
    Color.black.opacity(0.2)
  }
  
  private var restartbtn: some View {
    Button {
      vm.restartGame()
    } label: {
      Image(.capsulered)
        .resizableToFit(height: 90)
        .overlayMask {
          LiquidMetal(effect: "gradientShader")
            .grayscale(1)
            .opacity(0.7)
            .blendMode(.luminosity)
        }
        .overlay {
          Image(.capsulered)
            .resizableToFit(height: 90)
            .saturation(1.5)
            .opacity(0.7)
        }
        .overlay {
          Image(.restart)
            .resizableToFit(height: 36)
        }
        .padding(8)
        .padding(.bottom, 8)
    }
  }
  
  private var menubtn: some View {
    Button {
      vm.resetGame()
      nm.path = []
    } label: {
      Image(.btncapsule)
        .resizableToFit(height: 76)
        .overlayMask {
          LiquidMetal(effect: "gradientShader2")
            .grayscale(1)
            .scaleEffect(1)
            .opacity(0.7)
            .blendMode(.luminosity)
        }
        .overlay {
          Image(.btncapsule)
            .resizableToFit(height: 76)
            .saturation(1.5)
            .opacity(0.8)
        }
        .overlay {
          Image(.menu)
            .resizableToFit(height: 36)
        }
    }
  }
}



#Preview {
    GameOver()
    .nm
    .vm
}
