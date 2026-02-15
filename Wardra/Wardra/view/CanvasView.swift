//
//  CanvasView.swift
//  Wardra
//
//  Created by dana on 23/08/1447 AH.
//



import SwiftUI
import Photos

struct CanvasView: View {

    @ObservedObject var viewModel: ClosetViewModel

    @State private var selectedTab: ClosetTab = .tops

    // ✅ عناصر انحطّت على الكانفاس
    @State private var placedItems: [PlacedCanvasItem] = []

    // ✅ Alerts للحفظ
    @State private var showSavedAlert = false
    @State private var showSaveErrorAlert = false

    private enum ClosetTab {
        case tops, bottoms
    }

    // ✅ نفس اللوجك حق التصنيف
    private var tops: [ClothingItem] {
        viewModel.items.filter { $0.category == .top }
    }

    private var bottoms: [ClothingItem] {
        viewModel.items.filter { $0.category == .bottom }
    }

    private var shownItems: [ClothingItem] {
        selectedTab == .tops ? tops : bottoms
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            // ✅ style it your way
            let cardW = min(360, w * 0.90)
            let cardH = min(520, h * 0.66)

            ZStack {
                Color("WardraBackground")
                    .ignoresSafeArea()

                // ✅ Bottom strip
                VStack {
                    Spacer()
                    bottomStrip
                        .padding(.bottom, 30)
                }

                VStack(spacing: 0) {

                    // Top buttons
                    HStack(spacing: 18) {
                        pillButton(title: "Tops") {
                            selectedTab = .tops
                        }
                        pillButton(title: "Bottoms") {
                            selectedTab = .bottoms
                        }
                    }
                    .padding(.top, 22)
                    .padding(.bottom, 14)

                    // Canvas card
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 6)

                        VStack(spacing: 0) {
                            // Header strip
                            ZStack {
                                Rectangle()
                                    .fill(Color("lightpink").opacity(0.35))
                                    .frame(height: 56)

                                Text("Style It Your Way!")
                                    .font(.custom("American Typewriter", size: 22))
                                    .foregroundStyle(.black)
                            }

                            // ✅ مساحة الكانفاس اللي بتنحط عليها القطع (Drop + Move)
                            CanvasDropArea(
                                viewModel: viewModel,
                                placedItems: $placedItems,
                                cardSize: CGSize(width: cardW, height: cardH)
                            )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .frame(width: cardW, height: cardH)
                    .padding(.top, 12)
                    .overlay(alignment: .leading) {

                        // ✅ Save button (صار شغال)
                        Button {
                            saveCanvasImage(cardW: cardW, cardH: cardH)
                        } label: {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color("WardraPink"))
                                .frame(width: 78, height: 45)
                                .overlay(
                                    Image(systemName: "square.and.arrow.down")
                                        .font(.system(size: 26, weight: .regular))
                                        .foregroundColor(.white)
                                )
                        }
                        .offset(x: -32, y: cardH * 0.40)
                    }

                    Spacer()
                }
                .frame(width: w, height: h, alignment: .top)
            }
            .alert("Saved!", isPresented: $showSavedAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your canvas has been saved to Photos.")
            }
            .alert("Couldn’t Save", isPresented: $showSaveErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please allow Photos access from Settings, then try again.")
            }
        }
    }

    // ✅ الشريط الوردي تحت + السلايدر حق القطع
    private var bottomStrip: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color("lightpink").opacity(0.25))
                .frame(height: 85)

            // ✅ القطع (تتغير حسب Tops/Bottoms) + draggable
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(shownItems) { item in
                        MiniClothingThumb(item: item)
                            .onDrag {
                                NSItemProvider(object: item.id.uuidString as NSString)
                            }
                    }
                }
                .padding(.leading, 18 + 78 + 18) // مساحة زر التحميل
                .padding(.trailing, 18)
                .padding(.vertical, 10)
            }
        }
    }

    private func pillButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.custom("American Typewriter", size: 20))
                // ✅ التغيير المطلوب فقط: لون النص أسود
                .foregroundColor(.black)
                .frame(width: 140, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color("WardraPink"))
                )
        }
        .buttonStyle(.plain)
    }

    // ✅ حفظ صورة: المربع الأبيض فقط + القطع اللي انحطّت
    private func saveCanvasImage(cardW: CGFloat, cardH: CGFloat) {
        // طلب صلاحية الإضافة للألبوم (Add Only)
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            DispatchQueue.main.async {
                guard status == .authorized || status == .limited else {
                    showSaveErrorAlert = true
                    return
                }

                // نصوّر نفس الكارد بدون ظل/خلفية
                let snapshot = CanvasSnapshotCard(
                    viewModel: viewModel,
                    placedItems: placedItems
                )
                .frame(width: cardW, height: cardH)

                if #available(iOS 16.0, *) {
                    let renderer = ImageRenderer(content: snapshot)
                    renderer.scale = UIScreen.main.scale

                    if let uiImage = renderer.uiImage {
                        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                        showSavedAlert = true
                    } else {
                        showSaveErrorAlert = true
                    }
                } else {
                    // Fallback بسيط (لو احتجتي دعم أقل من iOS16)
                    let controller = UIHostingController(rootView: snapshot)
                    let view = controller.view

                    let targetSize = CGSize(width: cardW, height: cardH)
                    view?.bounds = CGRect(origin: .zero, size: targetSize)
                    view?.backgroundColor = .clear

                    let renderer = UIGraphicsImageRenderer(size: targetSize)
                    let img = renderer.image { _ in
                        view?.drawHierarchy(in: view?.bounds ?? .zero, afterScreenUpdates: true)
                    }

                    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                    showSavedAlert = true
                }
            }
        }
    }
}

// MARK: - Drop Area (يحط القطع + يسمح بتحريكها)
private struct CanvasDropArea: View {
    @ObservedObject var viewModel: ClosetViewModel
    @Binding var placedItems: [PlacedCanvasItem]
    let cardSize: CGSize

    // ✅ جديد: أي قطعة عليها وضع الحذف (تظهر X)
    @State private var selectedPlacedID: UUID? = nil

    var body: some View {
        GeometryReader { g in
            let canvasW = g.size.width
            let canvasH = g.size.height

            ZStack {
                // مساحة فاضية (الكانفاس)
                Color.clear

                // العناصر اللي انحطّت
                ForEach($placedItems) { $placed in
                    if let item = viewModel.items.first(where: { $0.id == placed.itemID }),
                       let img = item.image {

                        ZStack(alignment: .topTrailing) {

                            Image(uiImage: img)
                                .resizable()
                                .scaledToFit()
                                .frame(width: placed.size.width, height: placed.size.height)

                            // ✅ جديد: يظهر فقط للقطعة المختارة بالضغط المطوّل
                            if selectedPlacedID == placed.id {
                                Button {
                                    // حذف القطعة من الكانفاس
                                    placedItems.removeAll { $0.id == placed.id }
                                    selectedPlacedID = nil
                                } label: {
                                    Image(systemName: "x.circle.fill")
                                        .font(.system(size: 22, weight: .semibold))
                                        .foregroundColor(Color("WardraPink"))
                                        .background(Color.white.opacity(0.9))
                                        .clipShape(Circle())
                                }
                                .padding(6)
                            }
                        }
                        .frame(width: placed.size.width, height: placed.size.height)
                        .position(placed.position)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    placed.position = clampPoint(
                                        CGPoint(x: value.location.x, y: value.location.y),
                                        in: CGSize(width: canvasW, height: canvasH),
                                        itemSize: placed.size
                                    )
                                }
                        )
                        // ✅ جديد: ضغط مطوّل يطلع زر X
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.35)
                                .onEnded { _ in
                                    selectedPlacedID = placed.id
                                }
                        )
                    }
                }
            }
            .contentShape(Rectangle())
            // ✅ جديد: أي ضغط على أي مكان بالكانفاس يشيل علامة الـ X
            .onTapGesture {
                selectedPlacedID = nil
            }
            .dropDestination(for: String.self) { items, location in
                guard let uuidString = items.first,
                      let uuid = UUID(uuidString: uuidString) else { return false }

                let isBottom = viewModel.items.first(where: { $0.id == uuid })?.category == .bottom
                let defaultSize = isBottom
                ? CGSize(width: 170, height: 190)
                : CGSize(width: 170, height: 150)

                let pos = clampPoint(location, in: CGSize(width: canvasW, height: canvasH), itemSize: defaultSize)

                placedItems.append(
                    PlacedCanvasItem(
                        itemID: uuid,
                        position: pos,
                        size: defaultSize
                    )
                )

                // إذا كان فيه X ظاهر من قبل، نخفيه
                selectedPlacedID = nil

                return true
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func clampPoint(_ p: CGPoint, in canvas: CGSize, itemSize: CGSize) -> CGPoint {
        let halfW = itemSize.width / 2
        let halfH = itemSize.height / 2

        let x = min(max(p.x, halfW), canvas.width - halfW)
        let y = min(max(p.y, halfH), canvas.height - halfH)

        return CGPoint(x: x, y: y)
    }
}

// MARK: - Snapshot Card (هذا اللي ينحفظ)
private struct CanvasSnapshotCard: View {
    @ObservedObject var viewModel: ClosetViewModel
    let placedItems: [PlacedCanvasItem]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)

            VStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .fill(Color("lightpink").opacity(0.35))
                        .frame(height: 56)

                    Text("Style It Your Way!")
                        .font(.custom("American Typewriter", size: 22))
                        .foregroundStyle(.black)
                }

                GeometryReader { g in
                    ZStack {
                        Color.clear

                        ForEach(placedItems) { placed in
                            if let item = viewModel.items.first(where: { $0.id == placed.itemID }),
                               let img = item.image {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: placed.size.width, height: placed.size.height)
                                    .position(placed.position)
                            }
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

// ✅ مصغّر القطعة داخل الشريط
private struct MiniClothingThumb: View {
    let item: ClothingItem

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white.opacity(0.85))
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)

            if let img = item.image {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .padding(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray.opacity(0.7))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(6)
            }
        }
        .frame(width: 72, height: 60)
    }
}

// ✅ عنصر محطوط على الكانفاس
private struct PlacedCanvasItem: Identifiable {
    let id: UUID = UUID()
    let itemID: UUID
    var position: CGPoint
    var size: CGSize
}

#Preview {
    CanvasView(viewModel: ClosetViewModel())
}



