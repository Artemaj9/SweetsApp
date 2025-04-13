//
//  Welcome.swift
//

import SwiftUI

struct Welcome: View {
  @EnvironmentObject var vm: GameViewModel
  @State private var shakes = 0
  @State private var startAnimation = false
  @State private var stage = 1
  
  var body: some View {
    ZStack {
      bg
      title1A
      
      Image(.happysnail)
        .resizableToFit(height: 215)
        .xOffset(stage == 1 ? vm.w : vm.w*0.4)
        .animation(.easeInOut(duration: 1).delay(1), value: stage)
      
      Image(.happyworm)
        .resizableToFit(height: 215)
        .xOffset(stage == 1 ? -vm.w : -vm.w*0.4)
        .animation(.easeInOut(duration: 0.8).delay(1), value: stage)
      
      Image(.nextwelcbtn)
        .resizableToFit(height: 55)
        .asButton {
          stage = 2
        }
        .rotationEffect(Angle(degrees: startAnimation ? 0 : -720))
        .blur(radius: startAnimation ? 0 : 10)
        .offset(startAnimation ? vm.w*0.4 : -vm.w , vm.header)
        .animation(.easeIn(duration: 2), value: startAnimation)
        .transparentIf(stage == 2)
        .animation(.easeInOut, value: stage)
      
      Image(.purpleflower)
        .resizableToFit(height: 500)
        .offset(startAnimation ? -vm.w*0.45 : -vm.w*0.8, vm.h*0.05)
        .animation(.smooth.delay(1), value: startAnimation)
        .xOffsetIf(stage == 2, -vm.w*0.45)
        .animation(.smooth(duration: 1).delay(0.3), value: stage)
      
      Image(.welcsnail)
        .resizableToFit()
        .hPadding(30)
        .yOffset(30)
        .xOffsetIfNot(startAnimation, -vm.w)
        .animation(.smooth(duration: 2).delay(1), value: startAnimation)
        .xOffsetIf(stage == 2, vm.w)
        .animation(.smooth(duration: 2), value: stage)
      
      Image(.redflower)
        .resizableToFit(height: 550)
        .offset (vm.w*0.3,startAnimation ? vm.h*0.35 : vm.h*0.85)
        .animation(.smooth(duration: 2).delay(1), value: startAnimation)
      
      Image(.welcdescr)
        .resizableToFit()
        .hPadding(30)
        .yOffset(-vm.h*0.17)
        .transparentIfNot(startAnimation)
        .animation(.smooth(duration: 1).delay(1), value: startAnimation)
        .xOffsetIf(stage == 2, vm.w)
        .animation(.smooth, value: stage)
      
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
            .opacity(0.8)
        }
        .overlay {
          Image(stage == 1 ? .continue : .start)
            .resizableToFit(height: 34)
        }
        .asButton {
          if stage == 1 {
            stage = 2
          } else {
            vm.isWelcome = false
          }
        }
        .yOffset(vm.h*0.4)
        .xOffsetIfNot(startAnimation, -vm.w)
        .animation(
            .interpolatingSpring(stiffness: 20, damping: 6)
            .delay(2),
            value: startAnimation
        )
        .animation(.easeInOut, value: stage)
 
      VStack(spacing: 0) {
        Text(Txt.welcDescr[0])
          .sweetFont(size: 25, style: .skranjiReg, color: .white)
          .customStroke(color: Color(hex: "00A49E"), width: 1)
          .multilineTextAlignment(.center)
          .hPadding(16)
          .xOffsetIf(stage == 1, -vm.w)
          .animation(
            .interpolatingSpring(stiffness: 20, damping: 6)
            .delay(1),
            value: stage
          )
        Text(Txt.welcDescr[1])
          .sweetFont(size: 25, style: .skranjiReg, color: .white)
          .customStroke(color: Color(hex: "00A49E"), width: 1)
          .multilineTextAlignment(.center)
          .hPadding(20)
          .xOffsetIf(stage == 1, -vm.w)
          .animation(
            .interpolatingSpring(stiffness: 20, damping: 6)
            .delay(1),
            value: stage
          )
      }
      .yOffset(-vm.h*0.25)

      Text(Txt.welcDescr[2])
        .sweetFont(size: 25, style: .skranjiReg, color: .white)
        .customStroke(color: Color(hex: "00A49E"), width: 1)
        .multilineTextAlignment(.center)
        .hPadding()
        .yOffset(vm.h*0.24)
        .xOffsetIf(stage == 1, -vm.w)
        .animation(
            .interpolatingSpring(stiffness: 20, damping: 6)
            .delay(1),
            value: stage
        )
    }
    .onAppear {
      startAnimation  = true
      shakes += 1
    }
  }
  
  private var title1: some View {
    Image(.welctitle1)
      .resizableToFit()
      .hPadding(35)
      .yOffset(-vm.h*0.3)
  }
  
  private var title1A: some View {
    MyKeyframeAnimator(initialValue: ShakeData(), trigger: shakes, content: { anim in
      title1
        .opacity(anim.opacity.value)
        .offset(x: anim.offset.value)
        .rotationEffect(anim.rotation)
        .saturation(anim.saturation.value)
        .xOffsetIf(stage == 2, vm.w)
        .animation(.smooth, value: stage)
    }, keyframes: [
      MyKeyframeTrack(\ShakeData.offset, [
        MyCubicKeyframe(AnimatableDouble(value: 0), duration: 1)
        ]),
      MyKeyframeTrack(\ShakeData.opacity, [
        MyCubicKeyframe(AnimatableDouble(value: 1), duration: 1)
        ]),
      MyKeyframeTrack(\ShakeData.saturation, [
        MyCubicKeyframe(AnimatableDouble(value: 0), duration: 1.0),
        MyLinearKeyframe(AnimatableDouble(value: 1), duration: 0.5)
        ]),
    ])
  }
  
  private var bg: some View {
    Image(.welcbg)
      .backgroundFill()
  }
}

#Preview {
    Welcome()
    .vm
}


struct ShakeData {
  var offset: AnimatableDouble = AnimatableDouble(value: -500)
  var opacity: AnimatableDouble = AnimatableDouble(value: 0)
  var saturation: AnimatableDouble = AnimatableDouble(value: 1)
  var rotation: Angle = .zero
}

struct MoveData {
  var offset: AnimatableDouble = AnimatableDouble(value: 700)
  var opacity: AnimatableDouble = AnimatableDouble(value: 0)
  var rotation: Angle = .zero
}
