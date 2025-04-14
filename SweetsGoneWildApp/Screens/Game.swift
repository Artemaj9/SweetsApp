//
//  Game.swift
//

import SwiftUI

struct Game: View {
  @EnvironmentObject var vm: GameViewModel
  @EnvironmentObject var nm: NavigationStateManager
  @State private var startAnimation = false
  
  var body: some View {
    ZStack {
      bg
      header
      shop
      
      Image(.frameblue)
        .resizableToFit()
        .background {
          BackBlurView(radius: 10)
        }
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
        .hPadding()
        .yOffset(vm.h*0.08)
      
      pause
    }
    .onAppear {
      startAnimation = true
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
}

#Preview {
  Game()
    .vm
    .nm
}
