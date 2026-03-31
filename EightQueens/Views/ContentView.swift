import SwiftUI

struct ContentView: View {
  @State private var vm = SolutionViewModel()

  var body: some View {
    NavigationView {
      VStack {
        Stepper(value: $vm.gridSize, in: 4 ... 10) {
          Text("Grid Size: \(vm.gridSize) x \(vm.gridSize)")
            .font(.title3)
        }
        .frame(width: 275)

        NavigationLink(destination: Solution3DView(vm: vm)) {
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
