//
//  ContentView.swift
//  Instafilter
//
//  Created by David Hernandez on 4/09/24.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    //PhotosUI property
    @State private var selectedItem: PhotosPickerItem?
    //CoreImage properties
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    //confirmationDialog() property
    @State private var showingFilters = false
    //requestReview properties
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                .onChange(of: selectedItem, loadImage)

                Spacer()

                // Intensity slider
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .disabled(processedImage == nil) // disable if no image
                        .onChange(of: filterIntensity, applyProcessing)
                }
                .padding(.vertical)

                // Radius slider (for filters that support it)
                HStack {
                    Text("Radius")
                    Slider(value: $filterRadius)
                        .disabled(processedImage == nil || !currentFilter.inputKeys.contains(kCIInputRadiusKey))
                        .onChange(of: filterRadius, applyProcessing)
                }
                .padding(.vertical)

                // Scale slider (for filters that support it)
                HStack {
                    Text("Scale")
                    Slider(value: $filterScale)
                        .disabled(processedImage == nil || !currentFilter.inputKeys.contains(kCIInputScaleKey))
                        .onChange(of: filterScale, applyProcessing)
                }
                .padding(.vertical)

                HStack {
                    Button("Change Filter", action: changeFilter)
                        .disabled(processedImage == nil) // disable if no image

                    // ShareLink
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Cancel", role: .cancel) { }
            }
        }
    }

    func changeFilter() {
        showingFilters = true
    }

    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }

            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }

    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey) }

        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }

    @MainActor func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()

        filterCount += 1

        if filterCount >= 3 {
            requestReview()
        }
    }
}

#Preview {
    ContentView()
}