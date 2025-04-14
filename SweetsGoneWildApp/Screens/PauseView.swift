//
//  PauseView.swift
//

import SwiftUI

struct PauseView: View {
  @EnvironmentObject var vm: GameViewModel
  @EnvironmentObject var nm: NavigationStateManager
  @State private var startAnimation = false
  
    var body: some View {
      ZStack {
        bg
        VStack {
          title
          contbtn
          infobtn
          menubtn
        }
        .yOffset(-vm.h*0.05)
        
        pauseworm

      }
      .ignoresSafeArea()
      .onAppear {
        startAnimation = true
      }
    }
  
  @ViewBuilder private var bg: some View {
    BackBlurView(radius: 5)
    Color.black.opacity(0.2)
  }
  
  @ViewBuilder private var pauseworm: some View {
    Image(.pauseworm)
      .resizableToFit(height: 370)
      .yOffset(startAnimation ? vm.h*0.43 : vm.h*0.7)
      .xOffset(-vm.w*0.1)
      .animation(.smooth(duration: 0.8).delay(0.5), value: startAnimation)
    
    Image(.z)
      .resizableToFit(height: 180)
      .transparentIfNot(startAnimation)
      .animation(.smooth(duration: 1.4).delay(1.5), value: startAnimation)
      .offset(vm.w*0.15, vm.h*0.3)
  }
  
  private var title: some View {
    Image(.pausetitle)
      .resizableToFit(height: 108)
      .padding(.bottom)
  }
  
  private var contbtn: some View {
    Button {
      vm.isPause = false
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
          Image(.continuer)
            .resizableToFit(height: 36)
        }
    }
  }
  
  private var infobtn: some View {
    Button {
      vm.showInfo = true
    } label: {
      Image(.btncapsule)
        .resizableToFit(height: 76)
        .overlayMask {
          LiquidMetal(effect: "gradientShader")
            .scaleEffect(1.3)
            .rotationEffect(.degrees(180))
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
          Image(.info)
            .resizableToFit(height: 36)
        }
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
    PauseView()
    .vm
    .nm
}
