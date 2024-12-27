//
//  MJViewModel.swift
//  Buttwink
//
//  Created by 이명진 on 12/23/24.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input, disposeBag: DisposeBag) async -> Output
}

final class MJViewModel: ViewModelType {
    
    let provider = Providers.movieProvider
    
    struct Input {
        let viewDidLoad: Void
    }
    
    struct Output {
        let movieData: [BoxOffice]
    }
    
    func transform(input: Input, disposeBag: DisposeBag) async -> Output {
        do {
            let movieData = try await fetchMovieData(date: getOneWeekAgoDate())
//            print(movieData)
            return Output(movieData: movieData)
        } catch {
            print("Error \(error)")
            return Output(movieData: [])
        }
    }
    
    private func fetchMovieData(date: String) async throws -> [BoxOffice] {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.getMovieData(date: date)) { result in
                switch result {
                case .success(let response):
                    do {
                        let responseDto = try response.map(BoxOfficeResponse.self)
                        
                        let data = responseDto.boxOfficeResult
                        
                        continuation.resume(returning: data.dailyBoxOfficeList)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func getOneWeekAgoDate() -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"

        // 오늘 날짜로부터 7일 전 날짜 계산
        if let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) {
            return dateFormatter.string(from: oneWeekAgo)
        }
        
        // 오류 발생 시 기본값 반환
        return dateFormatter.string(from: Date())
    }
}
