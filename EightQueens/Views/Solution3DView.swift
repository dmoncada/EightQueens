import RealityKit
import SwiftUI

typealias Vector3 = SIMD3<Float>

struct Solution3DView: View {
  @State private var cameraAngle: Float = 0
  @State private var cameraRadius: Float = 12
  @State private var queenPrefab: ModelEntity?

  var gridSize: Int

  var body: some View {
    RealityView { content in
      let root = Entity()
      let board = makeBoard()
      let camera = PerspectiveCamera()
      updateCamera(camera: camera)
      camera.name = "camera"

      root.addChild(board)
      root.addChild(camera)

      let solutions = placeQueens(8)
      let solution = solutions[0].enumerated().map({ ($0, $1) })
      addQueens(to: root, solution: solution)

      content.add(root)
    }
  }

  private func makeBoard() -> Entity {
    let board = Entity()

    let evenColor = Color(hex: "FFE1AF") ?? .black
    let oddColor = Color(hex: "957C62") ?? .white

    let evenMaterial = SimpleMaterial.from(evenColor)
    let oddMaterial = SimpleMaterial.from(oddColor)

    for row in 0 ..< 8 {
      for col in 0 ..< 8 {
        let tile = ModelEntity(
          mesh: .generateBox(size: 1.0),
          materials: [(row + col) % 2 == 0 ? evenMaterial : oddMaterial]
        )

        tile.position = positionFor(row: row, col: col)
        board.addChild(tile)
      }
    }

    return board
  }

  private func addQueens(to root: Entity, solution: [(Int, Int)]) {
    guard let prefab = try? ModelEntity.load(named: "Hourglass") else { return }

    for (row, col) in solution {
      let queen = prefab.clone(recursive: true)
      queen.position = positionFor(row: row, col: col) + Vector3(0, 0.5, 0)
      queen.scale = Vector3(repeating: 5.0)
      queen.name = "queen"
      root.addChild(queen)
    }
  }

  private func updateCamera(camera: PerspectiveCamera) {
    let x = cos(cameraAngle) * cameraRadius
    let z = sin(cameraAngle) * cameraRadius
    let position = Vector3(x, 8, z)
    camera.position = position
    camera.look(at: .zero, from: position, relativeTo: nil)
  }

  private func positionFor(row: Int, col: Int) -> Vector3 {
    let offset: Float = 3.5
    return Vector3(Float(col) - offset, 0, Float(row) - offset)
  }
}

#Preview {
  Solution3DView(gridSize: 8)
}
