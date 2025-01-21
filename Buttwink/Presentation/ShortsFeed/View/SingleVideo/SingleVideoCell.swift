//
//  SingleVideoCell.swift
//  Buttwink
//
//  Created by 고영민 on 1/21/25.
//

import SwiftUI

struct ContentView: View {
  let videoURLs: [String] = [
    "https://www.youtube.com/shorts/q3ZOdrWTbl8",
    "https://www.youtube.com/shorts/sj_BoRg7pS8",
    "https://www.youtube.com/shorts/Rp5GI1wdHMs"
  ]
  
  @State private var currentVisibleIndex: Int = 0
  
  var body: some View {
    PagingScrollView(count: videoURLs.count) {
      LazyVStack(spacing: 0) {
        ForEach(videoURLs.indices, id: \.self) { index in
          GeometryReader { geometry in
            if isViewVisible(geometry: geometry) {
              ShortsView(
                viewModel: ShortsViewModel(contentURL: videoURLs[index]),
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
              .allowsHitTesting(false)
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
  }
  
  private func isViewVisible(geometry: GeometryProxy) -> Bool {
    let frame = geometry.frame(in: .global)
    return frame.intersects(UIScreen.main.bounds)
  }
  
  private func preloadAdjacentVideos(currentIndex: Int) {
    let prevIndex = max(0, currentIndex - 1)
    let nextIndex = min(videoURLs.count - 1, currentIndex + 1)
    
    if prevIndex != currentIndex {
      ShortsViewModel.preloadPlayer(for: videoURLs[prevIndex])
    }
    if nextIndex != currentIndex {
      ShortsViewModel.preloadPlayer(for: videoURLs[nextIndex])
    }
  }
}
