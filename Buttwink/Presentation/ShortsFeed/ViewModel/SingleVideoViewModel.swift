//
//  SingleVideoViewModel.swift
//  Buttwink
//
//  Created by 고영민 on 1/21/25.
//

import SwiftUI
import YouTubePlayerKit

class ShortsViewModel: ObservableObject {
  @Published var contentURL: String
  @Published var youtubePlayer: YouTubePlayer
  
  private static let cache = YouTubePlayerCache()
  
  init(contentURL: String) {
    self.contentURL = contentURL
    self.youtubePlayer = ShortsViewModel.cache.getPlayer(
      for: contentURL,
      configuration: ShortsViewModel.playerConfiguration
    )
  }
  
  static func preloadPlayer(for url: String) {
    cache.preloadPlayer(
      for: url,
      configuration: ShortsViewModel.playerConfiguration
    )
  }
  
  private static var playerConfiguration: YouTubePlayer.Configuration {
    return .init(
      autoPlay: true,
      showControls: false,
      loopEnabled: true,
      showRelatedVideos: false
    )
  }
}

class YouTubePlayerCache {
  private var cache: [String: YouTubePlayer] = [:]
  private let maxCacheSize = 5
  
  func getPlayer(for url: String, configuration: YouTubePlayer.Configuration) -> YouTubePlayer {
    if let cachedPlayer = cache[url] {
      return cachedPlayer
    }
    
    let newPlayer = YouTubePlayer(source: .url(url), configuration: configuration)
    cache[url] = newPlayer
    
    if cache.count > maxCacheSize {
      cache.removeValue(forKey: cache.keys.first!)
    }
    
    return newPlayer
  }
  
  func preloadPlayer(for url: String, configuration: YouTubePlayer.Configuration) {
    _ = getPlayer(for: url, configuration: configuration)
  }
}

public struct ShortsView: View {
  @StateObject var viewModel: ShortsViewModel
  @Binding var isPlaying: Bool
  @Environment(\.scenePhase) private var scenePhase
  
  public var body: some View {
    GeometryReader { geometry in
      let frame = geometry.frame(in: .global)
      let screenHeight = UIScreen.main.bounds.height
      let midY = frame.midY
      
      YouTubePlayerView(viewModel.youtubePlayer)
        .onChange(of: midY) { newValue in
          let wasPlaying = isPlaying
          isPlaying = (midY > 0 && midY < screenHeight)
          if isPlaying {
            if !wasPlaying {
              viewModel.youtubePlayer.seek(to: Measurement(value: 0, unit: UnitDuration.seconds))
              viewModel.youtubePlayer.play()
            } else {
              viewModel.youtubePlayer.play()
            }
          } else {
            viewModel.youtubePlayer.pause()
          }
        }
        .onChange(of: scenePhase) { newPhase in
          switch newPhase {
          case .active:
            if isPlaying {
              viewModel.youtubePlayer.play()
            }
          default:
            break
          }
        }
        .onDisappear {
          viewModel.youtubePlayer.pause()
        }
    }
  }
}
