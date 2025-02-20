//
//  SingleVideoViewModel.swift
//  Buttwink
//
//  Created by 고영민 on 1/21/25.
//

import SwiftUI
import YouTubePlayerKit
import RxSwift

final class SingleVideoViewModel: ObservableObject {
    @Published var contentURL: String
    @Published var youtubePlayer: YouTubePlayer
    @State private var selectedVideo: String?
    
    private static let cache = YouTubePlayerCache()
    
    init(contentURL: String) {
        self.contentURL = contentURL
        self.youtubePlayer = SingleVideoViewModel.cache.getPlayer(
            for: contentURL,
            configuration: SingleVideoViewModel.playerConfiguration
        )
    }
    
    static func preloadPlayer(for url: String) {
        cache.preloadPlayer(
            for: url,
            configuration: SingleVideoViewModel.playerConfiguration
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
        print("Created YouTubePlayer for URL: \(url)")
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

// ShortsView 정의
public struct ShortsView: View {
    @StateObject var viewModel: SingleVideoViewModel
    @Binding var isPlaying: Bool
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresentingModal = false
    @State private var selectedVideo: String? // SwiftUI에서 상태 관리
    
    private let disposeBag = DisposeBag()
    
    public var body: some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .global)
            let screenHeight = UIScreen.main.bounds.height
            let midY = frame.midY
            
            ZStack {
                // 🎥 YouTube Player
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
                
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isPlaying.toggle()
                        if isPlaying {
                            viewModel.youtubePlayer.play()
                        } else {
                            viewModel.youtubePlayer.pause()
                        }
                    }
                
                GeometryReader { geometry in
                    VStack(spacing: 15) {
                        Button(action: {
                            print("좋아요 버튼 클릭됨!")
                        }) {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .frame(width: 33, height: 33)
                                .foregroundColor(.red)
                        }
                        
                        Button(action: {
                            // Show the UIKit modal when the comment button is clicked
                            isPresentingModal.toggle()
                        }) {
                            Image(systemName: "message.fill")
                                .resizable()
                                .frame(width: 33, height: 33)
                                .foregroundColor(.white)
                        }
                    }
                    .offset(x: geometry.size.width * 0.9, y: geometry.size.height * 0.6)
                }
            }
            
            // 비디오 선택에 따라 이동하는 NavigationLink
            NavigationLink(
                destination: ShortsView(viewModel: SingleVideoViewModel(contentURL: selectedVideo ?? ""), isPlaying: .constant(true)),
                isActive: Binding(
                    get: { selectedVideo != nil },
                    set: { _ in selectedVideo = nil }
                )
            ) {
                EmptyView()
            }
            .hidden()
            
            .sheet(isPresented: $isPresentingModal) {
                UIKitModalView() // Present the UIKit modal
            }
        }
    }
}

// UIKit Modal View
struct UIKitModalView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return CommentModalViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

// 비디오 URL을 선택하는 예시
struct SheetView: View {
    @State private var isShowingComments = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea() // 배경 색 (예시)
            
            Button(action: {
                isShowingComments.toggle()
            }) {
                Image(systemName: "message.fill")
                    .resizable()
                    .frame(width: 33, height: 33)
                    .foregroundColor(.white)
            }
        }
        .sheet(isPresented: $isShowingComments) {
            CommentBottomSheet()
                .presentationDetents([.medium, .large]) // 📌 iOS 16+ 지원: 중간/전체 크기 조절 가능
                .presentationDragIndicator(.visible) // 드래그 가능하게 표시
        }
    }
}

struct CommentBottomSheet: View {
    var body: some View {
        VStack {
            Text("댓글 128개")
                .font(.headline)
                .padding()
            
            Divider()
            
            ScrollView {
                ForEach(1..<20) { index in
                    HStack {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            Text("User \(index)")
                                .fontWeight(.bold)
                            Text("이건 댓글 예제입니다.")
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.white)
        .cornerRadius(16)
    }
}
