//
//  UploadClothesViewModel.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 20/08/1447 AH.
//
import SwiftUI
import Combine
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

@MainActor
final class UploadClothesViewModel: ObservableObject {

    @Published var category: ClothingCategory = .top

    @Published var originalImage: UIImage?
    @Published var processedImage: UIImage?
    @Published var isProcessing: Bool = false
    @Published var error: String?

    private let context = CIContext()

    func setImage(_ image: UIImage) {
        originalImage = image
        processedImage = nil
        error = nil
        removeBackground(from: image)
    }

    // MARK: - Create Item
    func createItem() -> ClothingItem? {
        guard let image = processedImage ?? originalImage else {
            error = "Please upload an image"
            return nil
        }

        return ClothingItem(
            id: UUID(),
            image: image,
            category: category
        )
    }

    // MARK: - Background Removal
    private func removeBackground(from image: UIImage) {
        guard let cgImage = image.cgImage else {
            error = "Invalid image"
            return
        }

        isProcessing = true

        let request = VNGeneratePersonSegmentationRequest()
        request.qualityLevel = .accurate
        request.outputPixelFormat = kCVPixelFormatType_OneComponent8

        let handler = VNImageRequestHandler(cgImage: cgImage)

        Task.detached(priority: .userInitiated) { [weak self] in
            do {
                try handler.perform([request])

                guard
                    let self,
                    let maskPixelBuffer = request.results?.first?.pixelBuffer
                else {
                    await MainActor.run {
                        self?.error = "Could not segment image"
                        self?.isProcessing = false
                    }
                    return
                }

                let inputCI = CIImage(cgImage: cgImage)
                let maskCI = CIImage(cvPixelBuffer: maskPixelBuffer)

                // Resize mask to match input image
                let scaleX = inputCI.extent.width / maskCI.extent.width
                let scaleY = inputCI.extent.height / maskCI.extent.height
                let resizedMask = maskCI.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

                let filter = CIFilter.blendWithMask()
                filter.inputImage = inputCI
                filter.maskImage = resizedMask
                filter.backgroundImage = CIImage(color: .clear).cropped(to: inputCI.extent)

                guard let outputCI = filter.outputImage else {
                    await MainActor.run {
                        self.error = "Background removal failed"
                        self.isProcessing = false
                    }
                    return
                }

                guard let outCG = self.context.createCGImage(outputCI, from: outputCI.extent) else {
                    await MainActor.run {
                        self.error = "Could not render output"
                        self.isProcessing = false
                    }
                    return
                }

                let outUIImage = UIImage(cgImage: outCG)

                await MainActor.run {
                    self.processedImage = outUIImage
                    self.isProcessing = false
                }

            } catch {
                await MainActor.run {
                    self?.error = "Vision error: \(error.localizedDescription)"
                    self?.isProcessing = false
                }
            }
        }
    }
}
