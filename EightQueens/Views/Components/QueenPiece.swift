import SwiftUI

struct QueenPiece: View {
  let cellSize: CGFloat
  let imageUrl: URL?

  var body: some View {
    AsyncImage(url: imageUrl) { phase in
      let isResolved = phase.image != nil || phase.error != nil

      ZStack {
        switch phase {
        case .empty:
          Color.clear

        case .success(let image):
          image
            .resizable()
            .transition(.opacity)

        case .failure:
          Image(systemName: "crown.fill")
            .font(.system(size: cellSize * 0.5))
            .foregroundStyle(.black)
            .transition(.opacity)

        @unknown default:
          EmptyView()
        }
      }
      .animation(.easeInOut(duration: 0.25), value: isResolved)
    }
  }
}
