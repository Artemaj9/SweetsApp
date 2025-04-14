//
//  Brilliant.swift
//

import SwiftUI

struct Brilliant: View {
  @EnvironmentObject var vm: GameViewModel
  @EnvironmentObject var nm: NavigationStateManager
  @State private var startAnimation = false
  
    var body: some View {
      ZStack {
        bg
        flowers
        
        VStack {
          Image(.brilliant)
            .resizableToFit()
            .hPadding(30)
          Text("Results:")
            .sweetFont(size: 20, style: .snigletreg, color: .white)
            .customStroke(color: Color(hex: "00A49E"), width: 1)
            .multilineTextAlignment(.center)
            .padding(.vertical)
          
          LinearGradient(stops: [
            .init(color: .white, location: 0),
            .init(color: Color(hex: "00F2E9"), location: 0.44),
            .init(color: Color(hex: "0094D0"), location: 0.76),
            .init(color: Color.white, location: 1),
          ], startPoint: .top, endPoint: .bottom)
          .height(200)
          .mask {
            RoundedRectangle(cornerRadius: 15)
              .stroke(lineWidth: 3)
              .hPadding()
          }
          .overlay(.top) {
            VStack(spacing: 4) {
              Text("Your moves: \(vm.currentMoves)")
                .sweetFont(size: 25, style: .skranjiReg, color: .white)
              
              HStack {
                LinearGradient(
                  colors: [
                    Color(hex: "FF6803"),
                    Color(hex: "FFE944"),],
                  startPoint: .top, endPoint: .bottom)
                .frame(120, 40)
                .mask {
                  Text("\(vm.totalWin)")
                    .sweetFont(size: 25, style: .skranjiReg, color: .white)
                
                }
                .customStroke(color: .white, width: 2)
                 .compositingGroup()
                 .customStroke(color: Color(hex: "00F2E9"), width: 1,offset: .init(width: 0, height: 2))
                .shadow(color: Color(hex: "0074A3"), radius: 1, y: 4)
                Image(.coin)
                  .resizableToFit(height: 55)
                  .xOffset(-24)
              }
              
              HStack {
                Text("+\(vm.extraHints) Hint")
                  .sweetFont(size: 25, style: .skranjiReg, color: .white)
                Image(.lamp)
                  .resizableToFit(height: 40)
                Text("+\(vm.extraShields) Shield")
                  .sweetFont(size: 25, style: .skranjiReg, color: .white)
                Image(.sshield)
                  .resizableToFit(height: 40)
              }
              
              if vm.isChallengeCompleted {
                Image(.chalcompl)
                  .resizableToFit(height: 35)
              }
            
              
            
            }
            .padding(.top, 6)
            
            .hPadding()
          }
          
          nextlvlbtn
          menubtn
          
          
        }
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
  
  @ViewBuilder private var flowers: some View {
    Image(.flow1)
      .resizableToFit(height: 140)
      .rotation3DEffect(Angle(degrees: startAnimation ? 0 : 100), axis: (x: 0.1, y: 0.9, z: 0.9))
      .offset(-vm.w*0.1, startAnimation ? -vm.h*0.38 : -vm.h*0.7)
      .blur(radius: startAnimation ? 0 : 3)
      .animation(.easeInOut(duration: 1).delay(0.4), value: startAnimation)
    
    Image(.flow2)
      .resizableToFit(height: 170)
      .offset(vm.w*0.37, startAnimation ? -vm.h*0.36 : -vm.h*0.7)
      .rotation3DEffect(Angle(degrees: startAnimation ? 0 : 100), axis: (x: 0.7, y: 1, z: 0.0))
      .blur(radius: startAnimation ? 0 : 3)
      .animation(.easeInOut(duration: 1).delay(0.5), value: startAnimation)
    
    Image(.flow3)
      .resizableToFit(height: 120)
      .offset(startAnimation ? -vm.w*0.37 : -vm.w*0.67, startAnimation ? -vm.h*0.29 : -vm.h*0.7)
      .rotationEffect(Angle(degrees: startAnimation ? 0 : 80))
      .blur(radius: startAnimation ? 0 : 3)
      .animation(.easeInOut(duration: 1).delay(0.5), value: startAnimation)
  }
  
  private var nextlvlbtn: some View {
    Button {
      if vm.menuLevel < 10 {
        vm.menuLevel += 1
      } else {
        vm.menuLevel = 1
      }
      vm.restartGame()
    } label: {
      Image(.capsulered)
        .resizableToFit(height: 76)
        .overlayMask {
          LiquidMetal(effect: "gradientShader")
            .grayscale(1)
            .opacity(0.7)
            .blendMode(.luminosity)
        }
        .overlay {
          Image(.capsulered)
            .resizableToFit(height: 76)
            .saturation(1.5)
            .opacity(0.7)
        }
        .overlay {
          Image(.nextlevel)
            .resizableToFit(height: 36)
        }
    }
    .padding(.top, 24)
  }
  
  private var menubtn: some View {
    Button {
      vm.resetGame()
      nm.path = []
    } label: {
      Image(.btncapsule)
        .resizableToFit(height: 70)
        .overlayMask {
          LiquidMetal(effect: "gradientShader2")
            .grayscale(1)
            .scaleEffect(1)
            .opacity(0.7)
            .blendMode(.luminosity)
        }
        .overlay {
          Image(.btncapsule)
            .resizableToFit(height: 70)
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
    Brilliant()
    .vm
    .nm
}
