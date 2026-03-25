import SwiftUI
import RealityKit

extension SimpleMaterial {
  static func from(_ color: Color, metallic: Bool = false) -> SimpleMaterial {
    #if os(macOS)
    return SimpleMaterial(color: NSColor(color), isMetallic: metallic)
    #else
    return SimpleMaterial(color: UIColor(color), isMetallic: metallic)
    #endif
  }
}
