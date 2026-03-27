import RealityKit
import SwiftUI

extension SimpleMaterial {
  public static let evenMaterial = SimpleMaterial.from(.evenColor)
  public static let oddMaterial = SimpleMaterial.from(.oddColor)

  public static func from(_ color: Color, metallic: Bool = false) -> SimpleMaterial {
    #if os(macOS)
    return SimpleMaterial(color: NSColor(color), isMetallic: metallic)
    #else
    return SimpleMaterial(color: UIColor(color), isMetallic: metallic)
    #endif
  }
}
