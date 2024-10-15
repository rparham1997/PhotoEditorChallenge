//
//  ImageProcessor.swift
//  PhotoEditorChallenge
//
//  Created by Ramar Parham on 10/14/24.
//

import CoreImage
import CoreImage.CIFilterBuiltins

struct PhotoProcessor {
    let context = CIContext()

    // Apply all adjustments
    func applyAdjustments(
        to cgImage: CGImage,
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
        let ciImage = CIImage(cgImage: cgImage)
        
        // Apply Exposure Adjustment
        let exposureFilter = CIFilter.exposureAdjust()
        exposureFilter.inputImage = ciImage
        exposureFilter.ev = exposure
        guard let exposureOutput = exposureFilter.outputImage else { return nil }
        
        // Apply Brightness, Contrast, Saturation, Vibrance Adjustments
        let colorControlsFilter = CIFilter.colorControls()
        colorControlsFilter.inputImage = exposureOutput
        colorControlsFilter.brightness = brightness / 100 // Scale to -1 to +1
        colorControlsFilter.contrast = contrast / 100
        colorControlsFilter.saturation = saturation / 100
        guard let colorOutput = colorControlsFilter.outputImage else { return nil }

        // Apply Highlights and Shadows adjustments using color controls
        let shadowAmount = shadows / 100 // Scale shadows
        let highlightAmount = highlights / 100 // Scale highlights
        
        // Create a contrast adjustment for shadows and highlights
        let shadowHighlightFilter = CIFilter.colorControls()
        shadowHighlightFilter.inputImage = colorOutput
        shadowHighlightFilter.brightness = shadowAmount // Shadows as negative brightness
        shadowHighlightFilter.contrast = highlightAmount + 1.0 // Highlights as contrast
        
        guard let finalOutput = shadowHighlightFilter.outputImage else { return nil }

        // Warmth and Tint Adjustments
        let warmthFilter = CIFilter.temperatureAndTint()
        warmthFilter.inputImage = finalOutput
        warmthFilter.neutral = CIVector(x: 6500 + CGFloat(warmth * 10), y: CGFloat(tint * 10)) // Adjust temperature based on warmth and tint sliders

        guard let finalImage = warmthFilter.outputImage else { return nil }

        // Convert CIImage back to CGImage
        return context.createCGImage(finalImage, from: finalImage.extent)
    }

    // Apply Vivid filter
    func applyVividFilter(to cgImage: CGImage) -> CGImage? {
        let ciImage = CIImage(cgImage: cgImage)

        // Apply a Vivid filter by increasing saturation and contrast
        let vividFilter = CIFilter.colorControls()
        vividFilter.inputImage = ciImage
        vividFilter.saturation = 1.5 // Adjust this value for stronger effects
        vividFilter.contrast = 1.2 // Optional: Increase contrast

        guard let outputImage = vividFilter.outputImage else { return nil }

        return context.createCGImage(outputImage, from: outputImage.extent)
    }

    // Apply Vivid Warm filter
    func applyVividWarmFilter(to cgImage: CGImage) -> CGImage? {
        let ciImage = CIImage(cgImage: cgImage)

        // Apply Vivid Warm effect
        let vividWarmFilter = CIFilter.colorControls()
        vividWarmFilter.inputImage = ciImage
        vividWarmFilter.saturation = 1.5 // Adjust this value for stronger effects
        vividWarmFilter.brightness = 0.1 // Optional: slight brightness adjustment

        guard let outputImage = vividWarmFilter.outputImage else { return nil }

        return context.createCGImage(outputImage, from: outputImage.extent)
    }
}



