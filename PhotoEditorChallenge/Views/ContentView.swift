//
//  ContentView.swift
//  PhotoEditorChallenge
//
//  Created by Ramar Parham on 10/14/24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI

// MARK: - ContentView
struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var processedImage: UIImage?
    
    // Adjustment values
    @State private var adjustments = AdjustmentValues()
    
    @State private var showingImagePicker = false

    var body: some View {
        VStack(spacing: 10) {
            imageView
            
            adjustmentsView
            
            filterButtons
            
            Button("Select Photo") {
                showingImagePicker = true // Show the image picker
            }
            .padding()
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
                .onChange(of: selectedImage) { newValue in
                    if let newValue = newValue {
                        print("Selected image: \(newValue)") // Debug statement
                        processedImage = newValue // Show the selected image
                        updateProcessedImage() // Apply adjustments
                    }
                }
        }
    }

    // MARK: - View Components

    private var imageView: some View {
        Group {
            if let image = processedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
            } else {
                Text("Select a Photo")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
    }

    private var adjustmentsView: some View {
        VStack(spacing: 4) {
            GridStack(rows: (AdjustmentValues.count + 5) / 6, columns: 6) { row, col in
                let index = row * 6 + col
                if index < AdjustmentValues.count {
                    SliderWithLabel(value: binding(for: index), label: AdjustmentValues.names[index])
                }
            }
        }
    }

    private var filterButtons: some View {
        HStack {
            Button("Apply Vivid Filter") {
                applyFilter(filterType: .vivid)
            }
            .padding()

            Button("Apply Vivid Warm Filter") {
                applyFilter(filterType: .vividWarm)
            }
        }
    }

    // MARK: - Functions

    private func binding(for index: Int) -> Binding<Float> {
        switch index {
        case 0: return $adjustments.exposure
        case 1: return $adjustments.brilliance
        case 2: return $adjustments.highlights
        case 3: return $adjustments.shadows
        case 4: return $adjustments.contrast
        case 5: return $adjustments.brightness
        case 6: return $adjustments.blackPoint
        case 7: return $adjustments.saturation
        case 8: return $adjustments.vibrance
        case 9: return $adjustments.warmth
        case 10: return $adjustments.tint
        default: return .constant(0.0) // Default fallback
        }
    }

    private func updateProcessedImage() {
        guard let image = selectedImage?.cgImage else {
            print("No selected image available") // Debug statement
            return
        }

        let adjustedImage = PhotoProcessor().applyAdjustments(
            to: image,
            exposure: mapSliderValueToFilterRange(adjustments.exposure),
            brilliance: mapSliderValueToFilterRange(adjustments.brilliance),
            highlights: mapSliderValueToFilterRange(adjustments.highlights),
            shadows: mapSliderValueToFilterRange(adjustments.shadows),
            contrast: mapSliderValueToFilterRange(adjustments.contrast),
            brightness: mapSliderValueToFilterRange(adjustments.brightness),
            blackPoint: mapSliderValueToFilterRange(adjustments.blackPoint),
            saturation: mapSliderValueToFilterRange(adjustments.saturation),
            vibrance: mapSliderValueToFilterRange(adjustments.vibrance),
            warmth: mapSliderValueToFilterRange(adjustments.warmth),
            tint: mapSliderValueToFilterRange(adjustments.tint)
        )

        if let adjustedImage = adjustedImage {
            processedImage = UIImage(cgImage: adjustedImage)
            print("Processed image updated") // Debug statement
        } else {
            print("Failed to process the image") // Debug statement
        }
    }

    private func mapSliderValueToFilterRange(_ value: Float) -> Float {
        return value / 100.0 // Normalize from -100 to +1
    }

    private func applyFilter(filterType: FilterType) {
        guard let image = selectedImage?.cgImage else {
            print("No selected image available for filtering") // Debug statement
            return
        }

        let filteredImage: CGImage?
        switch filterType {
        case .vivid:
            filteredImage = PhotoProcessor().applyVividFilter(to: image)
        case .vividWarm:
            filteredImage = PhotoProcessor().applyVividWarmFilter(to: image)
        }

        if let cgImage = filteredImage {
            self.processedImage = UIImage(cgImage: cgImage)
            print("Applied filter: \(filterType)") // Debug statement
        } else {
            print("Failed to apply filter") // Debug statement
        }
    }
}

// MARK: - Structs for Adjustments

struct AdjustmentValues {
    var exposure: Float = 0.0
    var brilliance: Float = 0.0
    var highlights: Float = 0.0
    var shadows: Float = 0.0
    var contrast: Float = 0.0
    var brightness: Float = 0.0
    var blackPoint: Float = 0.0
    var saturation: Float = 0.0
    var vibrance: Float = 0.0
    var warmth: Float = 0.0
    var tint: Float = 0.0
    
    static let names = [
        "Exposure", "Brilliance", "Highlights", "Shadows", "Contrast", "Brightness",
        "Black Point", "Saturation", "Vibrance", "Warmth", "Tint"
    ]
    
    static var count: Int { names.count }
}

enum FilterType {
    case vivid
    case vividWarm
}

// Custom View for Sliders with Labels
struct SliderWithLabel: View {
    @Binding var value: Float
    var label: String

    var body: some View {
        VStack {
            Text("\(label): \(value, specifier: "%.2f")")
                .font(.footnote)
            Slider(value: $value, in: -100...100)
        }
        .frame(maxWidth: .infinity)
    }
}

// Custom view to create a grid layout for adjustments
struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }

    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
}

// Preview
#Preview {
    ContentView()
}







