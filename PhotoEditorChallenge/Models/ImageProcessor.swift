//
//  ImageProcessor.swift
//  PhotoEditorChallenge
//
//  Created by Ramar Parham on 10/14/24.
//

import CoreImage
import CoreImage.CIFilterBuiltins

class PhotoProcessor {
    private let context = CIContext()

    func applyAdjustments(
        to image: CGImage,
        exposure: Float,
        brilliance: Float,
        highlights: Float,
        shadows: Float,
        contrast: Float,
        brightness: Float,
        blackPoint: Float,
        saturation: Float,
        vibrance: Float,
        warmth: Float,
        tint: Float
    ) -> CGImage? {
        // Create a CIImage from the input CGImage
        let ciImage = CIImage(cgImage: image)

        // Apply adjustments using CIFilters
        let filter = CIFilter.colorControls()
        filter.inputImage = ciImage
        filter.brightness = brightness / 100.0
        filter.contrast = contrast / 100.0 + 1.0 // Ensure contrast is in range
        filter.saturation = saturation / 100.0 + 1.0 // Ensure saturation is in range

        // Create a CIImage from the filter's output and convert back to CGImage
        return context.createCGImage(filter.outputImage!, from: ciImage.extent)
    }

    func applyVividFilter(to image: CGImage) -> CGImage? {
        let ciImage = CIImage(cgImage: image)
        let filter = CIFilter.colorControls()
        filter.inputImage = ciImage
        filter.saturation = 1.5 // Increase saturation
        return context.createCGImage(filter.outputImage!, from: ciImage.extent)
    }

    func applyVividWarmFilter(to image: CGImage) -> CGImage? {
        let ciImage = CIImage(cgImage: image)
        let filter = CIFilter.colorControls()
        filter.inputImage = ciImage
        filter.saturation = 1.5 // Increase saturation
        let warmthFilter = CIFilter.temperatureAndTint()
        warmthFilter.inputImage = filter.outputImage
        warmthFilter.targetNeutral = CIVector(x: 6500, y: 0) // Adjust warmth
        return context.createCGImage(warmthFilter.outputImage!, from: ciImage.extent)
    }
}



