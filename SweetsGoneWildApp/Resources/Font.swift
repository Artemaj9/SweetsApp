//
//  Font.swift
//

import SwiftUI

enum CustomFont: String {
  case skranjiReg = "Skranji"
  case skranjiBold  = "Skranji Bold"
}

extension Font {
  static func custom(_ font: CustomFont, size: CGFloat) -> Font {
    Font.custom(font.rawValue, size: size)
  }
}
