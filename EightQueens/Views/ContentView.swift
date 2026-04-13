import SwiftUI

struct ContentView: View {
  @State private var vm = SolutionViewModel()

  var body: some View {
    NavigationStack {
      VStack {
        Stepper(value: $vm.gridSize, in: 4 ... 12) {
          Text("Grid Size: \(vm.gridSize)")
            .font(.title3)
        }
        .frame(width: 250)

        NavigationLink("Go!") {
          SolutionView(vm: vm)
        }
      }
      .navigationTitle("Eight Queens")
    }
  }
}

#Preview {
  ContentView()
}
