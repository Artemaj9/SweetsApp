//
//  Awesome.swift
//

import SwiftUI

struct Awesome: View {
  @EnvironmentObject var vm: GameViewModel
  @EnvironmentObject var nm: NavigationStateManager
  @State private var startAnimation = false
  
    var body: some View {
      ZStack {
        bg
        flowers
        
        VStack {
          Image(.awesometitle)
            .resizableToFit()
            .hPadding(8)
          Image(.awesomesubtitle)
            .resizableToFit(height: 45)
            .padding(.top, 8)
          
          Text("You've unlocked a Bonus Game. Want\n to give it a try for extra rewards?")
            .sweetFont(size: 20, style: .snigletreg, color: .white)
            .foregroundStyle(.white)
            .customStroke(color: Color(hex: "00A49E"), width: 1)
            .multilineTextAlignment(.center)
            .padding(.bottom)
          
          bonusbtn
          skipbtn
        }
        .yOffset(-vm.h*0.05)
      }
      .onAppear {
        startAnimation = true
      }
      .ignoresSafeArea()
    }
  
  @ViewBuilder private var bg: some View {
    BackBlurView(radius: 5)
    Color.black.opacity(0.2)
  }
  
  @ViewBuilder private var flowers: some View {
    Image(.flow1)
      .resizableToFit(height: 140)
      .rotationEffect(Angle(degrees: startAnimation ? 0 : 180))
      .offset(-vm.w*0.1, startAnimation ? -vm.h*0.38 : -vm.h*0.7)
      .animation(.easeInOut(duration: 1).delay(0.4), value: startAnimation)
    
    Image(.flow2)
      .resizableToFit(height: 170)
      .rotationEffect(Angle(degrees: startAnimation ? 0 : -80))
      .offset(vm.w*0.37, startAnimation ? -vm.h*0.36 : -vm.h*0.7)
      .animation(.easeInOut(duration: 1).delay(0.5), value: startAnimation)
    
    Image(.flow3)
      .resizableToFit(height: 120)
      .rotationEffect(Angle(degrees: startAnimation ? 0 : 80))
      .offset(startAnimation ? -vm.w*0.37 : -vm.w*0.67, startAnimation ? -vm.h*0.29 : -vm.h*0.7)
      .animation(.easeInOut(duration: 1).delay(0.5), value: startAnimation)
    
    Image(.flow1)
      .resizableToFit(height: 190)
      .rotationEffect(Angle(degrees: startAnimation ? 0 : 180))
      .offset(-vm.w*0.4, startAnimation ? vm.h*0.33 : vm.h*0.7)
      .animation(.easeInOut(duration: 1).delay(0.4), value: startAnimation)
    
    Image(.flow2)
      .resizableToFit(height: 140)
      .rotationEffect(Angle(degrees: startAnimation ? 0 : -180))
      .offset(-vm.w*0.05, startAnimation ? vm.h*0.43 : vm.h*0.7)
      .animation(.easeInOut(duration: 1).delay(0.2), value: startAnimation)
    
    Image(.flow3)
      .resizableToFit(height: 130)
      .rotation3DEffect(Angle(degrees: startAnimation ? 0 : 290), axis: (x: 1, y: 0.5, z: 0.6))
      .offset(vm.w*0.4, startAnimation ? vm.h*0.38 : vm.h*0.7)
      .animation(.easeInOut(duration: 1).delay(0.2), value: startAnimation)
  }
  private var bonusbtn: some View {
    Button {
      vm.isBonusGame = true
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
          Image(.bonusgame)
            .resizableToFit(height: 36)
        }
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
    Awesome()
    .vm
    .nm
}
