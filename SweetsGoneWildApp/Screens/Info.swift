//
//  Info.swift
//

import SwiftUI

struct Info: View {
  @EnvironmentObject var vm: GameViewModel
  @EnvironmentObject var nm: NavigationStateManager
  @State private var startAnimation = false
  @State private var saturation: Double = 1
  var isFromMenu: Bool =  false
  
  var body: some View {
    ZStack {
      bg
      header
      scroll
    }
    .onAppear {
      startAnimation = true
    }
    .navigationBarBackButtonHidden()
  }
  
  private var bg: some View {
    ZStack {
      Image(.infobg)
        .backgroundFill()
        .saturation(0.9 + saturation)
        .hueRotation(Angle(radians: -.pi*saturation*0.2))
    }
  }
  
  private var header: some View {
    HStack {
      Image(isFromMenu ? .homebtn : .backbtn)
        .resizableToFit(height: 55)
        .asButton {
          if isFromMenu {
            nm.path = []
          } else {
            vm.showInfo = false
          }
        }
      
      Spacer()
      
      Balance()
    }
    .padding(.trailing, 30)
    .padding(.leading, 8)
    .yOffset(vm.header)
    .transparentIfNot(startAnimation)
    .animation(.easeIn(duration: 0.5).delay(1.3), value: startAnimation)
  }
  
  private var scroll: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Color.clear.height(50)
        Text(Txt.infoTitles[0])
          .sweetFont(size: 25, style: .skranjiReg, color: .white)
          .customStroke(color: Color(hex: "00A49E"), width: 1)
          .frame(maxWidth: .infinity, alignment: .center)
        
        Text("Hey there, brave escargot enthusiast! I’m ")
          .font(.custom(.snigletreg, size: 15))
          .foregroundColor(.white)
        +
        Text("helly the Snail")
          .font(.custom(.skranjiReg, size: 15))
          .foregroundColor(Color(hex: "95FF00"))
        +
        
        Text(", and I need your help! A mean, ")
          .font(.custom(.skranjiReg, size: 15))
          .foregroundColor(.white)
        +
        Text("sneaky worm ")
          .font(.custom(.skranjiReg, size: 15))
          .foregroundColor(Color(hex: "FF8800"))
        +
        Text("is after me, and the only way to escape is by flipping cards, matching pairs, and avoiding his slimy traps!")
          .font(.custom(.snigletreg, size: 15))
          .foregroundColor(.white)
        
        
        Text(Txt.infoTitles[1])
          .sweetFont(size: 25, style: .skranjiReg, color: .white)
          .customStroke(color: Color(hex: "00A49E"), width: 1)
          .frame(maxWidth: .infinity, alignment: .center)
        
        ForEach(0..<5) { t in
          HStack {
            Text(Txt.dot)
              .sweetFont(size: 15, style: .snigletreg, color: .white)
            if t != 2 {
              Text(Txt.howToPLay[t])
                .sweetFont(size: 15, style: .snigletreg, color: .white)
            } else {
              Text(Txt.howToPLay[t])
                .font(.custom(.snigletreg, size: 15))
                .foregroundColor(.white)
              +
              Text(" He’s got me!")
                .font(.custom(.skranjiReg, size: 15))
                .foregroundColor(Color(hex: "FF0000"))
              
            }
          }
        }
        
        Text(Txt.infoTitles[2])
          .sweetFont(size: 25, style: .skranjiReg, color: .white)
          .customStroke(color: Color(hex: "00A49E"), width: 1)
          .frame(maxWidth: .infinity, alignment: .center)
        
        HStack(alignment: .firstTextBaseline) {
          Text(Txt.dot)
            .sweetFont(size: 15, style: .snigletreg, color: .white)
          Text("Hint")
            .font(.custom(.skranjiReg, size: 15))
            .foregroundColor(.white)
          Text("– shows all worms on the board... until you make a move!")
            .font(.custom(.snigletreg, size: 15))
            .foregroundColor(.white)
        }
        
        HStack(alignment: .firstTextBaseline) {
          Text(Txt.dot)
            .sweetFont(size: 15, style: .snigletreg, color: .white)
          Text("Shield")
            .font(.custom(.skranjiReg, size: 15))
            .foregroundColor(Color(hex: "00E952"))
          Text("– if I step on a worm, I don’t lose and can keep playing!")
            .font(.custom(.snigletreg, size: 15))
            .foregroundColor(.white)
        }
        
        Text(Txt.infoTitles[3])
          .sweetFont(size: 25, style: .skranjiReg, color: .white)
          .customStroke(color: Color(hex: "00A49E"), width: 1)
          .frame(maxWidth: .infinity, alignment: .center)
        
        Text("Finish the level within the move limit to unlock a")
          .font(.custom(.snigletreg, size: 15))
          .foregroundColor(.white)
        +
        Text(" bonus game")
          .font(.custom(.skranjiReg, size: 15))
          .foregroundColor(Color(hex: "00CCFF"))
        +
        Text(" and 1000 extra coins! Take too long? No worries, you still move forward—just no bonus game!")
          .font(.custom(.snigletreg, size: 15))
          .foregroundColor(.white)
        
        
        Text(Txt.infoTitles[4])
          .sweetFont(size: 25, style: .skranjiReg, color: .white)
          .customStroke(color: Color(hex: "00A49E"), width: 1)
          .frame(maxWidth: .infinity, alignment: .center)
        
        HStack(alignment: .firstTextBaseline) {
          Text(Txt.dot)
            .sweetFont(size: 15, style: .snigletreg, color: .white)
          Text("Flip tiles to find pairs. Every perfect match wins a ")
            .font(.custom(.snigletreg, size: 15))
            .foregroundColor(.white)
          +
          Text("reward!")
            .font(.custom(.skranjiReg, size: 15))
            .foregroundColor(Color(hex: "B093FF"))
        }
        
        HStack(alignment: .firstTextBaseline) {
          Text(Txt.dot)
            .sweetFont(size: 15, style: .snigletreg, color: .white)
          Text("BUT— one mistake = ")
            .font(.custom(.snigletreg, size: 15))
            .foregroundColor(.white)
          +
          Text("game over!")
            .font(.custom(.skranjiReg, size: 15))
            .foregroundColor(Color(hex: "FF0000"))
        }
        
        HStack(alignment: .firstTextBaseline) {
          Text(Txt.dot)
            .sweetFont(size: 15, style: .snigletreg, color: .white)
          Text("Rewards stack up, so stay focused and grab as much as you can!")
            .font(.custom(.snigletreg, size: 15))
            .foregroundColor(.white)
          
        }
        
        Group {
          Text("Ready to outsmart that wiggly menace and save me?")
            .font(.custom(.skranjiReg, size: 15))
            .foregroundColor(.white)
          +
          
          Text("Let’s go!")
            .font(.custom(.skranjiReg, size: 15))
            .foregroundColor(Color(hex: "A1FF00"))
        }
        .padding(.horizontal)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, alignment: .center)
        
        if vm.isFirstGame {
          Button {
            // FIXME: ADD for game
            vm.isFirstGame = false
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
                  .opacity(0.8)
              }
              .overlay {
                Image(.start)
                  .resizableToFit(height: 34)
              }
          }
          .frame(maxWidth: .infinity, alignment: .center)
          .padding(.top)
        }
        Color.clear.height(450)
      }
      .background(GeometryReader {
        Color.clear.preference(
          key: ViewOffsetKey.self,
          value: -$0.frame(in: .named("scroll")).origin.y
        )
      }).onPreferenceChange(ViewOffsetKey.self) {
        saturation = $0 * 0.001
        print(saturation)
      }
      .hPadding(24)
    }
    .coordinateSpace(name: "scroll")
    .scrollIndicators(.hidden)
    .scrollMask(
      location1: 0,
      location2: 0.05,
      location3: 0.9,
      location4: 0.95
    )
    .background {
      ZStack {
        BackBlurView(radius: 5)
        Color.black.opacity(0.5)
          .hPadding(12)
          .clipShape(RoundedRectangle(cornerRadius: 25))
          .clipped()
        
        LinearGradient(
          stops: [.init(color: .white, location: 0),
                  .init(color: Color(hex: "00F2E9"), location: 0.44),
                  .init(color: Color(hex: "0094D0"), location: 0.76),
                  .init(color: Color.white, location: 1)
          ], startPoint: .top, endPoint: .bottom)
        .mask {
          RoundedRectangle(cornerRadius: 15)
            .stroke(lineWidth: 3)
            .hPadding(12)
        }
      }
      .allowsHitTesting(false)
    }
    
    .yOffset(vm.h*0.15)

  }
}

#Preview {
  Info()
    .vm
    .nm
}
