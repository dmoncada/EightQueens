import SwiftUI

struct SolutionView: View {
  var vm: SolutionViewModel

  @State private var imageUrl: URL? = nil

  private let maxBoardWidth: CGFloat = 500

  var body: some View {
    VStack {

      Spacer()

      Group {
        if vm.isLoading {
          ProgressView("Computing solutions ...")
            .controlSize(.large)

        } else if vm.solutions.count > 0 {
          GeometryReader { geometry in
            let boardWidth = min(min(geometry.size.width, geometry.size.height), maxBoardWidth)

            BoardView(
              solution: vm.solution, width: boardWidth, imageUrl: imageUrl, selectedRow: vm.selectedRow
            ) { selected in
              vm.selectedRow = selected
            }
            .frame(width: boardWidth, height: boardWidth)
            .position(
              x: geometry.size.width / 2,
              y: geometry.size.height / 2
            )
          }
        }
      }

      Spacer()

      if vm.isLoading == false && vm.solutions.count > 0 {
        IndexControls(vm: vm)
      }
    }
    .navigationTitle("Solution (N=\(vm.gridSize))")
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding()
    .task {
      guard imageUrl == nil else { return }
      imageUrl = try? await vm.imageUrl
    }
    .task(id: vm.gridSize) {
      await vm.solve()
    }
  }
}

#Preview {
  SolutionView(vm: SolutionViewModel())
}
