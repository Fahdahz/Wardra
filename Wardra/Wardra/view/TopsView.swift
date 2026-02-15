import SwiftUI

struct TopsView: View {

    @ObservedObject var viewModel: ClosetViewModel
    
    private var topItems: [ClothingItem] {
        viewModel.items.filter { $0.category == .top }
    }

    // Reuse your palette
    private let bgColor = Color(red: 0.96, green: 0.94, blue: 0.92)
    private let accent = Color(red: 0.75, green: 0.45, blue: 0.45) // matches bottom bar color

    var body: some View {
        ZStack {

            // Background
            bgColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Rectangle()
                        .fill(Color("WardraPink"))
                        .frame(height: 3)
                        .padding(.horizontal, 2)
                        .padding(.top, 8)

                // MARK: - Header
                VStack(spacing: 10) {
                    

                    // Hanger with centered title
                    ZStack {
                        Image("big_hanger")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 420)
                            .padding(.top, -19)

                        Text("Tops")
                            .font(.custom("American Typewriter", size: 23))
                            .foregroundColor(.black)
                            .offset(y: 6)

                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 20)

                Divider()

                // MARK: - Grid
                if topItems.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "tshirt")
                            .font(.system(size: 60))
                            .foregroundColor(Color("WardraPink"))
                        
                        Text("No Tops Yet")
                            .font(.custom("American Typewriter", size: 28))
                        
                        Text("Add some tops to your closet!")
                            .font(.custom("American Typewriter", size: 16))
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(topItems) { item in
                                ItemCard(item: item, viewModel: viewModel)
                            }
                        }
                        .padding()
                    }
                }

                Spacer()

            
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ItemCard: View {
    let item: ClothingItem
    @ObservedObject var viewModel: ClosetViewModel

    @State private var showDeleteAlert = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.6))
                .frame(height: 170)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.pink.opacity(0.2), lineWidth: 1)
                )
                .overlay {
                    if let image = item.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .padding(14)
                    }
                }
                .shadow(color: .black.opacity(0.05), radius: 5)

            // ✅ Delete button (بدال الفيفرت)
            Button {
                showDeleteAlert = true
            } label: {
                Image(systemName: "x.circle")
                    .font(.system(size: 18))
                    .foregroundColor(Color("WardraPink"))
                    .padding(8)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Circle())
            }
            .padding(8)
            .alert("Delete item?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    viewModel.deleteItem(item)
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this item?")
            }
        }
    }
}


#Preview {
    NavigationStack {
        TopsView(viewModel: ClosetViewModel())
    }
}
