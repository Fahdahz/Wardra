//
//  UploadClothesViewModel 2.swift
//  Wardra
//
//  Created by Fahdah Alsamari on 16/08/1447 AH.
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
    @Published var error: String?

    private let context = CIContext()

    func setImage(_ image: UIImage) {
        originalImage = image
        processedImage = nil
        removeBackground(from: image)
    }

    // MARK: - Background Removal
    private func removeBackground(from image: UIImage) {
        guard let cgImage = image.cgImage else {
            error = "Invalid image"
            return
        }

        Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { return }

            let request = VNGeneratePersonSegmentationRequest()
            request.qualityLevel = .accurate
            request.outputPixelFormat = kCVPixelFormatType_OneComponent8

            let handler = VNImageRequestHandler(cgImage: cgImage)

            do {
                try handler.perform([request])

                guard let maskBuffer = request.results?.first?.pixelBuffer else {
                    await MainActor.run {
                        self.error = "Background removal failed"
                    }
                    return
                }

                let maskImage = CIImage(cvPixelBuffer: maskBuffer)
                let inputImage = CIImage(cgImage: cgImage)

                let filter = CIFilter.blendWithMask()
                filter.inputImage = inputImage
                filter.maskImage = maskImage
                filter.backgroundImage = CIImage(color: .clear)

                guard let output = filter.outputImage,
                      let cgOutput = self.context.createCGImage(
                        output,
                        from: inputImage.extent
                      ) else {
                    await MainActor.run {
                        self.error = "Processing failed"
                    }
                    return
                }

                let finalImage = UIImage(cgImage: cgOutput)

                await MainActor.run {
                    self.processedImage = finalImage
                }

            } catch {
                await MainActor.run {
                    self.error = "Vision error"
                }
            }
        }
    }


    func createItem() -> ClothingItem? {
        guard let image = processedImage,
              let data = image.pngData() else {
            error = "Please upload an image"
            return nil
        }

        return ClothingItem(category: category, imageData: data)
    }
}
