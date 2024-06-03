//
//  ContentView.swift
//  Instafilter
//
//  Created by 임지성 on 6/4/24.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    
    @State private var selectedItem: PhotosPickerItem?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext() // 이렇게 뷰 전역으로 선언해서 재사용하기!
    
    @State private var showingFilters = false // confirmation dialog용
    
    @AppStorage("filterCount") var filterCount = 0 // 필터를 사용한 횟수
    @Environment(\.requestReview) var requestReview // 사용자에게 리뷰 요청
    
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
                
                // Spacer()를 두 개 사용함으로써 이미지 공간을 확보하고 슬라이더와 버튼을
                // 화면 최하단에 고정시킴
                
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity, applyProcessing)
                    // slider에 value파라미터만 넘기면 슬라이더 값이 범위는 0부터 1까지, 현재 값은 0.5로 초기화됨
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter", action: changeFilter)
                    // 함수가 간단하더라도 이렇게 버튼의 action을 함수에 분리하는 게 clean code!
                    
                    Spacer()
                    
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("InstaFilter")
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
        Task { // 각 과정을 이렇게 진행하는 이유는 노션 참고
            // 1. selectedItem에 값이 들어오면(사진이 선택되면) 원하는 타입으로 변환하기
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            
            // 2. 변환한 데이터를 UIImage로 바꾸기
            guard let inputImage = UIImage(data: imageData) else { return }
            
            // 3. UIImage를 CIImage로 바꾸기
            let beginImage = CIImage(image: inputImage)
            // 4. Core Image filter에 CIImage 보내서 필터 적용하기
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            
            applyProcessing()
        }
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
        // filterIntensity에 특정 숫자를 곱한 이유는 필터에 적절한 범위의 값을 전달하기 위함임
        // (+) default slider의 범위는 0부터 1까지임
        
        // 필터값을 설정한 후 해당 필터의 outputImage에 접근해 필터를 적용한 사진을 반환받음
        guard let outputImage = currentFilter.outputImage else { return }
        // CIContext가 필터를 적용한 사진을 렌더링해서 CGImage를 생성
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        // 생성된 CGImage를 UIImage로 변환함
        let uiImage = UIImage(cgImage: cgImage)
        // 생성된 UIImage를 SwiftUI image로 변환함
        processedImage = Image(uiImage: uiImage)
    }
    
    @MainActor func setFilter(_ filter: CIFilter) {
        // @MainActor: requestReview()때문에 달아준 거
        currentFilter = filter
        loadImage()
        
        filterCount += 1
        
        if filterCount > 20 {
            requestReview()
        }
    }
}

#Preview {
    ContentView()
}
