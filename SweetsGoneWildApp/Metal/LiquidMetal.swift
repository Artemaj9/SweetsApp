//
//  Flicker.swift
//

import SwiftUI

struct LiquidMetal: View {
  var effect: String = "rainbowShader"
  
  var body: some View {
    ZStack {
      MetalViewRepresentable(effect: effect)
        .edgesIgnoringSafeArea(.all)
    }
  }
}

#Preview {
  LiquidMetal()
}
