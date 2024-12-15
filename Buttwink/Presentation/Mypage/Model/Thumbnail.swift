////
////  Thumbnail.swift
////  Buttwink
////
////  Created by 고영민 on 12/10/24.
////
//
//import UIKit
//
//
//
//enum CodyRecommendCategory: String, Codable, CaseIterable {
//    case WEIGHT
//    case PILATES
//    case MALE
//    case FEMALE
//    
//    var categoryName: String {
//        switch self {
//        case .WEIGHT: return "헬스 코디"
//        case .PILATES: return "필라테스 코디"
//        case .MALE: return "남자 코디"
//        case .FEMALE: return "여자 코디"
//        }
//    }
//    
//    var allCases: [CodyRecommendCategory] {
//        return CodyRecommendCategory.allCases
//    }
//}
//
//
//
//enum ThumbnailData {
//    
//    case 첫번째(image: UIImage, title: String, subtitle: String)
//    case 두번째(image: UIImage, title: String, subtitle: String)
//    case 세번째(image: UIImage, title: String, subtitle: String)
//    
//    var textColor: UIColor {
//        switch self {
//        case .첫번째:
//            return .blue
//        case .두번째:
//            return .red
//        case .세번째:
//            return .green
//        }
//    }
//
//    // 추가된 초기화 생성자
//    init?(imageName: String, title: String, subtitle: String) {
//        guard let image = UIImage(named: imageName) else { return nil }
//        
//        switch title {
//        case "첫번째":
//            self = .첫번째(image: image, title: title, subtitle: subtitle)
//        case "두번째":
//            self = .두번째(image: image, title: title, subtitle: subtitle)
//        case "세번째":
//            self = .세번째(image: image, title: title, subtitle: subtitle)
//        default:
//            return nil
//        }
//    }
//    
//    // 이제 image, title, subtitle을 직접적으로 반환하도록 수정
//    var image: UIImage {
//        switch self {
//        case .첫번째(let image, _, _):
//            return image
//        case .두번째(let image, _, _):
//            return image
//        case .세번째(let image, _, _):
//            return image
//        }
//    }
//    
//    var title: String {
//        switch self {
//        case .첫번째(_, let title, _):
//            return title
//        case .두번째(_, let title, _):
//            return title
//        case .세번째(_, let title, _):
//            return title
//        }
//    }
//    
//    var subtitle: String {
//        switch self {
//        case .첫번째(_, _, let subtitle):
//            return subtitle
//        case .두번째(_, _, let subtitle):
//            return subtitle
//        case .세번째(_, _, let subtitle):
//            return subtitle
//        }
//    }
//}
