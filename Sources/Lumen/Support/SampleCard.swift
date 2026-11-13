import SwiftUI

/// The card that every preview applies its effect to.
struct SampleCard: View {
    var caption: String
    var colors: [Color]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Lumen")
                .font(.title2.bold())
            Spacer()
            Text(caption)
                .font(.footnote)
                .opacity(0.7)
        }
        .foregroundStyle(.white)
        .padding(24)
        .frame(width: 320, height: 200, alignment: .leading)
        .background(
            .linearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing),
            in: .rect(cornerRadius: 28)
        )
    }
}
