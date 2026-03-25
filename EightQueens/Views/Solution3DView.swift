import RealityKit
import SwiftUI

typealias Vector3 = SIMD3<Float>

struct Solution3DView: View {
  let gridSize: Int

  @State private var solutions: [[Int]] = []
  @State private var currentIndex: Int = 0
  @State private var isLoading = true

  @State private var cameraAngle: Float = 0
  @State private var cameraRadius: Float = 12

  @State private var queenEntities: [ModelEntity] = []
  @State private var rootEntity: Entity?

  var body: some View {
    RealityView { content in
      let root = Entity()
      let board = makeBoard()
      let camera = PerspectiveCamera()
      updateCamera(camera: camera)
      camera.name = "camera"

      root.addChild(board)
      root.addChild(camera)
      content.add(root)
      rootEntity = root
    }
    .task {
      await loadSolutions()
    }

    if isLoading {
      ProgressView("Computing solutions ...")
        .progressViewStyle(CircularProgressViewStyle())
    } else {
      HStack {
        Button("Prev") {
          showPrev()
        }

        Text("\(currentIndex + 1) / \(solutions.count)")
          .monospacedDigit()

        Button("Next") {
          showNext()
        }
      }
    }
  }

  private func loadSolutions() async {
    let solutions = await Task.detached(priority: .userInitiated) {
      placeQueens(gridSize)
    }.value

    await MainActor.run {
      self.solutions = solutions
      self.currentIndex = 0
      self.isLoading = false
    }

    if let root = rootEntity {
      await setupQueens(in: root)
    }
  }

  private func setupQueens(in root: Entity) async {
    guard let prefab = try? await ModelEntity(named: "Hourglass") else { return }
    guard let first = solutions.first else { return }

    var entities: [ModelEntity] = []

    for (row, col) in first.enumerated() {
      let queen = prefab.clone(recursive: true)
      queen.position = positionFor(row: row, col: col) + Vector3(0, 0.5, 0)
      queen.scale = Vector3(repeating: 5.0)
      queen.name = "queen"

      entities.append(queen)
      root.addChild(queen)
    }

    await MainActor.run {
      self.queenEntities = entities
    }
  }

  private func moveQueens(to solution: [Int]) {
    guard solution.count == queenEntities.count else { return }

    for (row, col) in solution.enumerated() {
      let queen = queenEntities[row]
      let target = positionFor(row: row, col: col) + Vector3(0, 0.5, 0)

      var transform = queen.transform
      transform.translation = target

      queen.move(to: transform, relativeTo: queen.parent, duration: 0.25, timingFunction: .easeInOut)
    }
  }

  private func showPrev() {
    if solutions.isEmpty { return }
    currentIndex = (currentIndex + solutions.count - 1) % solutions.count
    moveQueens(to: solutions[currentIndex])
  }

  private func showNext() {
    if solutions.isEmpty { return }
    currentIndex = (currentIndex + 1) % solutions.count
    moveQueens(to: solutions[currentIndex])
  }

  private func makeBoard() -> Entity {
    let board = Entity()

    let evenColor = Color(hex: "FFE1AF") ?? .black
    let oddColor = Color(hex: "957C62") ?? .white

    let evenMaterial = SimpleMaterial.from(evenColor)
    let oddMaterial = SimpleMaterial.from(oddColor)

    for row in 0 ..< gridSize {
      for col in 0 ..< gridSize {
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

  private func updateCamera(camera: PerspectiveCamera) {
    let x = cos(cameraAngle) * cameraRadius
    let z = sin(cameraAngle) * cameraRadius
    let position = Vector3(x, 8, z)
    camera.position = position
    camera.look(at: .zero, from: position, relativeTo: nil)
  }

  private func positionFor(row: Int, col: Int) -> Vector3 {
    let offset = Float(gridSize - 1) / 2
    return Vector3(Float(col) - offset, 0, Float(row) - offset)
  }
}

#Preview {
  Solution3DView(gridSize: 8)
}
