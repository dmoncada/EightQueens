import SwiftUI

struct ContentView: View {
  @State private var gridSize: Int = 8

  var body: some View {
    NavigationView {
      VStack {
        Stepper(value: $gridSize, in: 4...10) {
          Text("Grid Size: \(gridSize) x \(gridSize)")
            .font(.title3)
        }
        .frame(width: 275)

        NavigationLink(destination: SolutionView(gridSize: gridSize)) {
          Text("Go!")
        }
      }
      .navigationTitle(Text("Eight Queens"))
    }
  }
}

#Preview {
  ContentView()
}
