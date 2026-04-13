import RealityKit
import RealityKitContent
import SwiftUI

struct Solution3DView: View {
  var vm: SolutionViewModel

  private let modelName = "Hourglass"
  private let queenOffset: Vector3 = .up * 0.5
  private let queenScale: Vector3 = .one * 5.0

  @State private var queens = Entity()
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

      await vm.solve()

    } update: { _ in
      tryMoveQueens()

    } placeholder: {
      ProgressView("Computing solutions ...")
    }
    .gesture(tapGesture)

    if vm.isLoading == false && vm.solutions.count > 0 {
      IndexControls(vm: vm)
    }
  }

  var tapGesture: some Gesture {
    TapGesture()
      .targetedToAnyEntity()
      .onEnded({ value in
        let entity = value.entity
        print("Tapped: \(entity.name)")

        guard vm.solutions.count > 0 else { return }
        guard queens.children.count == vm.gridSize else { return }
        guard entity.name.starts(with: "tile") else { return }

        let solution = vm.solutions[vm.currentIndex]
        let parts = entity.name.split(separator: "_")

        if let row = Int(parts[1]), let col = Int(parts[2]), col == solution[row] {
          let queen = queens.children[row]
          queen.position += .up * 0.5
          print(solution)
        }
      })
  }

  private func tryMoveQueens() {
    guard vm.solutions.count > 0, queens.children.count == vm.gridSize else { return }
    moveQueens(to: vm.solutions[vm.currentIndex])
  }

  private func moveQueens(to solution: [Int]) {
    let queens = queens.children
    for (row, col) in solution.enumerated() {
      let queen = queens[row]
      let target = positionFor(row: row, col: col)

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

  private func makeBoard() -> Entity {
    let board = Entity()

    for row in 0 ..< vm.gridSize {
      for col in 0 ..< vm.gridSize {
        let tile = ModelEntity(
          mesh: .generateBox(size: 1.0),
          materials: [(row + col) % 2 == 0 ? SimpleMaterial.evenMaterial : .oddMaterial]
        )

        let shape = ShapeResource.generateBox(size: .one)

        tile.name = "tile_\(row)_\(col)"
        tile.components.set(InputTargetComponent())
        tile.components.set(CollisionComponent(shapes: [shape]))
        tile.components.set(HoverEffectComponent())
        tile.position = positionFor(row: row, col: col)
        board.addChild(tile)
      }
    }

    return board
  }

  private func makeQueens() async -> Entity {
    let queens = Entity()
    queens.position += queenOffset

    guard let queen = try? await Entity(named: modelName, in: realityKitContentBundle) else { return queens }

    for i in 0 ..< vm.gridSize {
      let clone = queen.clone(recursive: true)
      clone.scale = queenScale
      clone.name = "queen_\(i + 1)"
      queens.addChild(clone)
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
    let offset = Float(vm.gridSize - 1) / 2
    return Vector3(Float(col) - offset, 0, Float(row) - offset)
  }
}

#Preview {
  Solution3DView(vm: SolutionViewModel())
}
