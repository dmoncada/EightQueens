import SwiftUI

struct ContentView: View {
  @State private var solutions: [[Int]] = []
  @State private var currentIndex: Int = 0
  @State private var isLoading = true

  private let maxBoardWidth: CGFloat = 400
  private let gridSize = 8

  var body: some View {
    VStack {
      Text("Eight Queens")
        .font(.largeTitle)
        .fontWeight(.bold)

      if isLoading {
        ProgressView("Computing solutions...")
          .progressViewStyle(CircularProgressViewStyle())

      } else if !solutions.isEmpty {
        GeometryReader { geometry in
          let boardWidth = min(geometry.size.width - 40, maxBoardWidth)

          VStack {
            BoardView(solution: solutions[currentIndex], width: boardWidth, size: gridSize)
              .frame(maxWidth: maxBoardWidth)
              .padding(.bottom)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }

        HStack {
          Button("Prev") {
            currentIndex = (currentIndex + solutions.count - 1) % solutions.count
          }

          Text("\(currentIndex + 1) / \(solutions.count)")
            .font(.headline)
            .frame(minWidth: 80)

          Button("Next") {
            currentIndex = (currentIndex + 1) % solutions.count
          }
        }

      } else {
        Text("No solutions found.")
      }
    }
    .task {
      isLoading = true
      solutions = await placeQueensAsync(gridSize)
      isLoading = false
    }
    .padding()
  }

  func placeQueensAsync(_ gridSize: Int) async -> [[Int]] {
    await withCheckedContinuation { continuation in
      DispatchQueue.global(qos: .userInitiated).async {
        let result = placeQueens(gridSize)
        continuation.resume(returning: result)
      }
    }
  }
}

#Preview {
  ContentView()
}
