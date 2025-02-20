//
//  SingleVideoCell.swift
//  Buttwink
//
//  Created by 고영민 on 1/21/25.
//

import SwiftUI
import RxSwift
import RxCocoa

struct ContentView: View {
    let videoURLs: [String] = [
        "https://www.youtube.com/shorts/q3ZOdrWTbl8",
        "https://www.youtube.com/shorts/sj_BoRg7pS8",
        "https://www.youtube.com/shorts/Rp5GI1wdHMs"
    ]
    
    @State private var currentVisibleIndex: Int = 0
    @State private var selectedVideoURL: String? = nil
    @State private var isNavigating: Bool = false
    @State private var selectedVideo: String
    
    init(selectedVideo: String) {
        self._selectedVideo = State(initialValue: selectedVideo)
    }
    
    var body: some View {
        NavigationStack {
            SingleVideoView(count: videoURLs.count) {
                LazyVStack(spacing: 0) {
                    ForEach(videoURLs.indices, id: \.self) { index in
                        GeometryReader { geometry in
                            if isViewVisible(geometry: geometry) {
                                ShortsView(
                                    viewModel: SingleVideoViewModel(contentURL: videoURLs[index]),
                                    isPlaying: Binding<Bool>(
                                        get: { self.currentVisibleIndex == index },
                                        set: { newValue in
                                            if newValue {
                                                self.currentVisibleIndex = index
                                                preloadAdjacentVideos(currentIndex: index)
                                            }
                                        }
                                    )
                                )
                                .onTapGesture {
                                    // 썸네일 클릭 시 URL을 selectedVideoURL에 할당
                                    Task {
                                        await updateSelectedVideoURL(with: videoURLs[index])
                                    }
                                }
                                .frame(height: UIScreen.main.bounds.height)
                            } else {
                                Color.clear.frame(height: UIScreen.main.bounds.height)
                            }
                        }
                        .frame(height: UIScreen.main.bounds.height)
                    }
                }
                .ignoresSafeArea()
            }
            .ignoresSafeArea()
            .onAppear {
                preloadAdjacentVideos(currentIndex: 0)
            }
            .background(
                // NavigationLink는 화면을 트리거하고, `isNavigating`이 true일 때 활성화됨
                NavigationLink(
                    destination: ShortsView(
                        viewModel: SingleVideoViewModel(contentURL: selectedVideo ?? ""),
                        isPlaying: .constant(true)
                    ),
                    isActive: $isNavigating
                ) {
                    EmptyView()
                }
                    .hidden()
            )
            .navigationDestination(isPresented: $isNavigating) {
                // 네비게이션이 트리거되었을 때 해당 비디오로 이동
                //                if let selectedVideo = selectedVideo {  // 비디오 URL이 있을 때만 네비게이션
                //                      ShortsView(viewModel: SingleVideoViewModel(contentURL: selectedVideo), isPlaying: .constant(true))
                //                  }🟩🟩🟩
            }
        }
    }
    
    private func navigateToVideoPlayer(with videoURL: String) {
        self.selectedVideoURL = videoURL
        self.isNavigating = true // Navigation 활성화
    }
    
    private func isViewVisible(geometry: GeometryProxy) -> Bool {
        let frame = geometry.frame(in: .global)
        return frame.intersects(UIScreen.main.bounds)
    }
    
    private func preloadAdjacentVideos(currentIndex: Int) {
        let prevIndex = max(0, currentIndex - 1)
        let nextIndex = min(videoURLs.count - 1, currentIndex + 1)
        
        if prevIndex != currentIndex {
            SingleVideoViewModel.preloadPlayer(for: videoURLs[prevIndex])
        }
        if nextIndex != currentIndex {
            SingleVideoViewModel.preloadPlayer(for: videoURLs[nextIndex])
        }
    }
    
    private func updateSelectedVideoURL(with videoURL: String) async {
        selectedVideo = videoURL
        selectedVideoURL = videoURL
        isNavigating = true // 네비게이션 활성화
    }
}
