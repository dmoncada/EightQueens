import SwiftUI

struct SolutionView: View {
  public var vm: SolutionViewModel

  private let maxBoardWidth: CGFloat = 400

  var body: some View {
    VStack {
      Text("Solution (N=\(vm.gridSize))")
        .font(.largeTitle)
        .fontWeight(.bold)

      if vm.isLoading {
        ProgressView("Computing solutions ...")
          .progressViewStyle(CircularProgressViewStyle())

      } else if vm.solutions.count > 0 {
        GeometryReader { geometry in
          let boardWidth = min(geometry.size.width - 40, maxBoardWidth)

          VStack {
            BoardView(solution: vm.solutions[vm.currentIndex], width: boardWidth, size: vm.gridSize)
              .frame(maxWidth: maxBoardWidth)
          }
        }

        HStack {
          Button("Prev") {
            vm.showPrev()
          }

          Text("\(vm.currentIndex + 1) / \(vm.solutions.count)")
            .monospacedDigit()

          Button("Next") {
            vm.showNext()
          }
        }

      } else {
        Text("No solutions found.")
      }
    }
    .task {
      await vm.solve()
    }
    .padding()
  }
}

#Preview {
  SolutionView(vm: SolutionViewModel())
    .frame(width: 400, height: 500)
}
