import SwiftUI

struct IndexControls: View {
  var vm: SolutionViewModel

  var body: some View {
    HStack {
      Button("Prev") {
        withAnimation {
          vm.showPrev()
        }
      }

      Text("\(vm.currentIndex + 1)")
        .frame(width: 50, alignment: .trailing)
        .contentTransition(.numericText())
        .monospaced()

      Text("/")

      Text("\(vm.solutions.count)")
        .frame(width: 50, alignment: .leading)
        .monospaced()

      Button("Next") {
        withAnimation {
          vm.showNext()
        }
      }
    }
  }
}
