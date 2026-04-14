import SwiftUI

extension Color {
  public static let evenColor = Color("F7D0A3") ?? .black
  public static let oddColor = Color("C78E51") ?? .white
}

extension Color {
  init?(_ hex: String) {
    let hexSanitized =
      hex
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .replacingOccurrences(of: "#", with: "")

    var rgb: UInt64 = 0
    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 1.0

    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
      return nil
    }

    let length = hexSanitized.count
    guard length == 6 || length == 8 else {
      return nil
    }

    if length == 6 {
      r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
      g = CGFloat((rgb & 0x00FF00) >> 08) / 255.0
      b = CGFloat((rgb & 0x0000FF) >> 00) / 255.0
    }

    if length == 8 {
      r = CGFloat((rgb & 0xFF00_0000) >> 24) / 255.0
      g = CGFloat((rgb & 0x00FF_0000) >> 16) / 255.0
      b = CGFloat((rgb & 0x0000_FF00) >> 08) / 255.0
      a = CGFloat((rgb & 0x0000_00FF) >> 00) / 255.0
    }

    self.init(red: r, green: g, blue: b, opacity: a)
  }
}
