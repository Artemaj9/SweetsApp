//
//  ShieldOver.swift
//

import SwiftUI

struct ShieldOver: View {
  @EnvironmentObject var vm: GameViewModel
  @EnvironmentObject var nm: NavigationStateManager
  
  var body: some View {
    ZStack {
      bg
      
      VStack(spacing: 0) {
        Image(.shieldtitle)
          .resizableToFit()
          .frame(maxWidth: .infinity, alignment: .leading)
          .xOffset(-vm.w*0.07)
        
        Text("Buy a Shield to keep playing from this\nspot. Without it, the game will end.")
          .sweetFont(size: 20, style: .snigletreg, color: .white)
          .foregroundStyle(.white)
          .customStroke(color: Color(hex: "00A49E"), width: 1)
          .multilineTextAlignment(.center)
          .padding(.bottom)
        
        shieldbtn
        skipbtn
      }
    }
    .ignoresSafeArea()
  }
  
  @ViewBuilder private var bg: some View {
    BackBlurView(radius: 5)
    Color.black.opacity(0.2)
  }
  
  private var shieldbtn: some View {
    Button {
      vm.isShield = true
      vm.balance -= 250
      vm.checkResult()
      vm.isAlreadyShielded = true
      vm.isShield = true
      vm.showShieldOver = false
      // FIXME: Continue game
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
          Image(.shieldgold)
            .resizableToFit(height: 36)
        }
        .padding(8)
        .padding(.bottom, 8)
    }
  }
  
  
  private var skipbtn: some View {
    Button {
      vm.resetGame()
      nm.path.removeLast()
    } label: {
      Image(.btncapsule)
        .resizableToFit(height: 76)
        .overlayMask {
          LiquidMetal(effect: "gradientShader")
            .grayscale(1)
            .opacity(0.7)
            .blendMode(.luminosity)
        }
        .overlay {
          Image(.btncapsule)
            .resizableToFit(height: 76)
            .saturation(1.5)
            .opacity(0.7)
        }
        .overlay {
          Image(.menu)
            .resizableToFit(height: 36)
        }
    }
  }
}

#Preview {
  ShieldOver()
    .vm
    .nm
}
