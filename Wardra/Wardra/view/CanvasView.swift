//
//  CanvasView.swift
//  Wardra
//
//  Created by dana on 23/08/1447 AH.
//



import SwiftUI
import Photos
import CoreImage
import UIKit

struct CanvasView: View {

    @ObservedObject var viewModel: ClosetViewModel
    @State private var selectedTab: ClosetTab = .tops

    // ✅ عناصر انحطّت على الكانفاس
    @State private var placedItems: [PlacedCanvasItem] = []

    // ✅ Alerts للحفظ
    @State private var showSavedAlert = false
    @State private var showSaveErrorAlert = false

    // ✅ Cache للألوان (عشان ما نحسب كل مرة)
    @State private var colorCache: [UUID: UIColor] = [:]

    private enum ClosetTab { case tops, bottoms }

    private var tops: [ClothingItem] { viewModel.items.filter { $0.category == .top } }
    private var bottoms: [ClothingItem] { viewModel.items.filter { $0.category == .bottom } }
    private var shownItems: [ClothingItem] { selectedTab == .tops ? tops : bottoms }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            let cardW = min(360, w * 0.90)
            let cardH = min(520, h * 0.66)

            ZStack {
                Color("WardraBackground").ignoresSafeArea()

                // ✅ Bottom strip
                VStack {
                    Spacer()
                    bottomStrip
                        .padding(.bottom, 30)
                }

                VStack(spacing: 0) {

                    // Top buttons
                    HStack(spacing: 18) {
                        pillButton(title: "Tops") { selectedTab = .tops }
                        pillButton(title: "Bottoms") { selectedTab = .bottoms }
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

                            // ✅ Banner حق الماتش (بين الهيدر والكانفاس)
                            matchBanner
                                .padding(.horizontal, 12)
                                .padding(.top, 10)

                            // ✅ مساحة الكانفاس
                            CanvasDropArea(
                                viewModel: viewModel,
                                placedItems: $placedItems,
                                cardSize: CGSize(width: cardW, height: cardH)
                            )
                            .padding(.top, 6)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .frame(width: cardW, height: cardH)
                    .padding(.top, 12)
                    .overlay(alignment: .leading) {

                        // ✅ Save button
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

    // MARK: - Match Banner

    private var matchBanner: some View {
        Group {
            if let result = computeMatchResultFromCanvas() {
                MatchBannerView(result: result)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(result.title). \(result.message)")
            } else {
                // ما نعرض شيء إذا ما فيه Top + Bottom
                EmptyView()
            }
        }
    }

    private func computeMatchResultFromCanvas() -> MatchResultUI? {
        // آخر Top وآخر Bottom (الأقرب لفكرة "اختار قطعتين")
        guard let topPlaced = placedItems.last(where: { placed in
            viewModel.items.first(where: { $0.id == placed.itemID })?.category == .top
        }),
        let bottomPlaced = placedItems.last(where: { placed in
            viewModel.items.first(where: { $0.id == placed.itemID })?.category == .bottom
        }) else {
            return nil
        }

        let topID = topPlaced.itemID
        let bottomID = bottomPlaced.itemID

        guard let topColor = colorForItem(id: topID),
              let bottomColor = colorForItem(id: bottomID) else {
            // لو فشل استخراج اللون (نادراً) نطلع نتيجة لطيفة
            return MatchResultUI(
                style: .okay,
                title: "Okay match",
                message: "Add a neutral layer/accessory to balance it."
            )
        }

        return evaluateMatch(top: topColor, bottom: bottomColor)
    }

    private func evaluateMatch(top: UIColor, bottom: UIColor) -> MatchResultUI {
        // 1) لو أحدهم Neutral => غالباً يمشي
        if top.isNeutral || bottom.isNeutral {
            return MatchResultUI(
                style: .good,
                title: "Good match ✅",
                message: "Okay match Add a neutral layer/accessory to balance it."
            )
        }

        // 2) التقييم حسب فرق السطوع (أفضل لعمى الألوان)
        let diff = abs(top.relativeLuminance - bottom.relativeLuminance)

        if diff >= 0.35 {
            return MatchResultUI(
                style: .good,
                title: "Good match ✅",
                message: "Okay match Add a neutral layer/accessory to balance it."
            )
        } else if diff >= 0.18 {
            return MatchResultUI(
                style: .okay,
                title: "Okay match",
                message: "Add a neutral layer/accessory to balance it."
            )
        } else {
            return MatchResultUI(
                style: .bad,
                title: "Not recommended ❌",
                message: "Try a lighter or darker piece"
            )
        }
    }

    // MARK: - Color Cache Helpers

    private func preloadColorsForPlacedItems() {
        // حضّري ألوان آخر القطع المضافة (تسريع)
        for placed in placedItems {
            if colorCache[placed.itemID] != nil { continue }
            _ = colorForItem(id: placed.itemID)
        }
    }

    private func colorForItem(id: UUID) -> UIColor? {
        if let cached = colorCache[id] { return cached }

        guard let item = viewModel.items.first(where: { $0.id == id }),
              let img = item.image else { return nil } // ← لو اسمها مختلف عندك عدليه

        let color = averageColor(from: img)
        if let color {
            colorCache[id] = color
        }
        return color
    }

    private func averageColor(from image: UIImage) -> UIColor? {
        guard let ciImage = CIImage(image: image) else { return nil }
        let context = CIContext(options: [.workingColorSpace: NSNull()])

        let filter = CIFilter(name: "CIAreaAverage")!
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(CIVector(cgRect: ciImage.extent), forKey: kCIInputExtentKey)

        guard let output = filter.outputImage else { return nil }

        var pixel = [UInt8](repeating: 0, count: 4)
        context.render(output,
                       toBitmap: &pixel,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        return UIColor(
            red: CGFloat(pixel[0]) / 255.0,
            green: CGFloat(pixel[1]) / 255.0,
            blue: CGFloat(pixel[2]) / 255.0,
            alpha: 1
        )
    }

    // MARK: - Bottom strip

    private var bottomStrip: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color("lightpink").opacity(0.25))
                .frame(height: 85)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(shownItems) { item in
                        MiniClothingThumb(item: item)
                            .onDrag {
                                NSItemProvider(object: item.id.uuidString as NSString)
                            }
                    }
                }
                .padding(.leading, 18 + 78 + 18)
                .padding(.trailing, 18)
                .padding(.vertical, 10)
            }
        }
    }

    private func pillButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.custom("American Typewriter", size: 20))
                .foregroundColor(.black)
                .frame(width: 140, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color("WardraPink"))
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Save

    private func saveCanvasImage(cardW: CGFloat, cardH: CGFloat) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            DispatchQueue.main.async {
                guard status == .authorized || status == .limited else {
                    showSaveErrorAlert = true
                    return
                }

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

// MARK: - Match Banner UI

private enum MatchBannerStyle { case good, okay, bad }

private struct MatchResultUI {
    let style: MatchBannerStyle
    let title: String
    let message: String
}

private struct MatchBannerView: View {
    let result: MatchResultUI

    var body: some View {
        HStack(spacing: 10) {
            Text(result.title)
                .font(.custom("American Typewriter", size: 16))
                .foregroundColor(.black)

            Spacer(minLength: 8)

            Text(result.message)
                .font(.custom("American Typewriter", size: 14))
                .foregroundColor(.black.opacity(0.85))
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(bannerBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color("WardraPink").opacity(0.55), lineWidth: 1)
        )
    }

    private var bannerBackground: Color {
        switch result.style {
        case .good: return Color("lightpink").opacity(0.28)
        case .okay: return Color("lightpink").opacity(0.22)
        case .bad:  return Color("lightpink").opacity(0.18)
        }
    }
}

// MARK: - Drop Area

private struct CanvasDropArea: View {
    @ObservedObject var viewModel: ClosetViewModel
    @Binding var placedItems: [PlacedCanvasItem]
    let cardSize: CGSize

    @State private var selectedPlacedID: UUID? = nil

    var body: some View {
        GeometryReader { g in
            let canvasW = g.size.width
            let canvasH = g.size.height

            ZStack {
                Color.clear

                ForEach($placedItems) { $placed in
                    if let item = viewModel.items.first(where: { $0.id == placed.itemID }),
                       let img = item.image {

                        ZStack(alignment: .topTrailing) {

                            Image(uiImage: img)
                                .resizable()
                                .scaledToFit()
                                .frame(width: placed.size.width, height: placed.size.height)

                            if selectedPlacedID == placed.id {
                                Button {
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
            .onTapGesture { selectedPlacedID = nil }
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

// MARK: - Snapshot Card

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

// MARK: - Mini Thumb

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

// MARK: - Placed Item

private struct PlacedCanvasItem: Identifiable {
    let id: UUID = UUID()
    let itemID: UUID
    var position: CGPoint
    var size: CGSize
}

// MARK: - UIColor Helpers (for match)

private extension UIColor {
    var relativeLuminance: CGFloat {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)

        func f(_ c: CGFloat) -> CGFloat {
            (c <= 0.03928) ? (c / 12.92) : pow((c + 0.055)/1.055, 2.4)
        }
        return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b)
    }

    var isNeutral: Bool {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)

        let maxV = max(r, g, b)
        let minV = min(r, g, b)
        let satApprox = maxV == 0 ? 0 : (maxV - minV) / maxV

        return satApprox < 0.15
    }
}

#Preview {
    CanvasView(viewModel: ClosetViewModel())
}




