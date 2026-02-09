import SwiftUI

struct TopsView: View {

    // Dummy items just to show grid layout
    let items = Array(1...6)

    // Reuse your palette
    private let bgColor = Color(red: 0.96, green: 0.94, blue: 0.92)
    private let accent = Color(red: 0.75, green: 0.45, blue: 0.45) // matches bottom bar color

    var body: some View {
        ZStack {

            // Background
            bgColor
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: - Header
                VStack(spacing: 10) {

                    // Hanger with centered title
                    ZStack {
                        Image("hanger 2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 420, height: 120) // bigger hanger

                        // Centered text relative to the hanger
                        Text("Tops")
                            .font(.system(size: 30, weight: .semibold, design: .serif)) // bigger text
                            .foregroundColor(.black)
                            .offset(y: 10) // adjust to sit in the hanger opening
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 20)

                Divider()

                // MARK: - Grid
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ],
                        spacing: 16
                    ) {
                        ForEach(items, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.6))
                                .frame(height: 170)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.pink.opacity(0.2), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.05), radius: 5)
                        }
                    }
                    .padding()
                }

                Spacer()

                // MARK: - Bottom Bar
                HStack(spacing: 30) {
                    Image(systemName: "hanger")
                    Image(systemName: "square.grid.2x2.fill")
                    Image(systemName: "tshirt")
                }
                .font(.system(size: 22))
                .foregroundColor(accent)
                .padding()
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.6))
                        .shadow(radius: 5)
                )
                .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    TopsView()
}
