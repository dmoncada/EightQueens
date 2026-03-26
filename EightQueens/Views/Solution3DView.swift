import RealityKit
import RealityKitContent
import SwiftUI

struct Solution3DView: View {
  public let gridSize: Int

  private let modelName = "Hourglass"
  private let queenOffset: Vector3 = .up * 0.5

  @State private var queens: Entity = Entity()
  @State private var solutions: [[Int]] = []
  @State private var currentIndex: Int = 0
  @State private var isLoading = true

  @State private var cameraAngle: Float = 0
  @State private var cameraRadius: Float = 12

  var body: some View {
    RealityView { content in
      let root = Entity()
      let board = makeBoard()
      let queens = await makeQueens()
      let camera = PerspectiveCamera()
      updateCamera(camera: camera)
      camera.name = "camera"

      root.addChild(board)
      root.addChild(queens)
      root.addChild(camera)
      self.queens = queens
      content.add(root)

      isLoading = true
      solutions = await placeQueens(gridSize)
      isLoading = false
      currentIndex = 0

    } update: { content in
      tryMoveQueens()

    } placeholder: {
      ProgressView("Computing solutions ...")
    }
    .onChange(of: queens) { _, _ in
      tryMoveQueens()
    }
    .onChange(of: solutions) { _, _ in
      tryMoveQueens()
    }

    if !isLoading {
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

  private func tryMoveQueens() {
    let count = queens.children.count
    guard solutions.count > 0, count > 0, count == gridSize else { return }
    moveQueens(to: solutions[currentIndex])
  }

  private func moveQueens(to solution: [Int]) {
    let queens = queens.children
    for (row, col) in solution.enumerated() {
      let queen = queens[row]
      let target = positionFor(row: row, col: col) + queenOffset

      var transform = queen.transform
      transform.translation = target

      queen.move(
        to: transform,
        relativeTo: queen.parent,
        duration: 0.25,
        timingFunction: .easeInOut
      )
    }
  }

  private func showPrev() {
    if solutions.isEmpty { return }
    currentIndex = (currentIndex + solutions.count - 1) % solutions.count
  }

  private func showNext() {
    if solutions.isEmpty { return }
    currentIndex = (currentIndex + 1) % solutions.count
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

  private func makeQueens() async -> Entity {
    let queens = Entity()

    if let queen = try? await Entity(named: modelName, in: realityKitContentBundle) {
      for i in 0 ..< gridSize {
        let clone = queen.clone(recursive: true)
        clone.scale = Vector3(repeating: 5.0)
        clone.name = "queen_\(i + 1)"
        queens.children.append(clone)
      }
    }

    return queens
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
