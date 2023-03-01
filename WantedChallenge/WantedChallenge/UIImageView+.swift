//
//  UIImageView+.swift
//  WantedChallenge
//
//  Created by Hyeonsoo Kim on 2023/03/01.
//

import UIKit

extension UIImageView {
    func fetchImage(from url: URL) async throws {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else { throw NetworkError.invalidResponse(url) }
            guard let image = UIImage(data: data) else { throw NetworkError.invalidDataForImage }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        } catch {
            throw NetworkError.throwError(url: url, error)
        }
    }
}

enum NetworkError: Error {
    case invalidStringForURL
    case invalidDataForImage
    case unsupportedURL(_ url: URL)
    case notConnectedToInternet
    case invalidResponse(_ url: URL)
    case cancelled
    case unexpectedURLError(_ errorCode: Int)
    case unknownError
    
    /// 에러 메시지입니다. catch문에서 error를 NetworkError로 캐스팅한후 .message로 에러문 출력하면 됩니다.
    var message: String {
        switch self {
        case .invalidStringForURL: return "✍🏻 url로 변환이 불가능한 문자열입니다."
        case .invalidDataForImage: return "🌁 UIImage로 변환이 불가능한 Data입니다."
        case .unsupportedURL(let url): return "📪 지원하지않는 url 주소입니다. URL: \(url)"
        case .notConnectedToInternet: return "💤 네트워크가 꺼져있습니다."
        case .invalidResponse: return "👹 유효하지 않은 response입니다."
        case .cancelled: return "🏹 새로운 요청으로 인한 이전 요청 취소"
        case .unexpectedURLError(let errorCode): return "⁉️ 미리 예상하지못한 URL관련 에러입니다. 에러 코드: \(errorCode)"
        case .unknownError: return "🤯 원인을 알 수 없는 에러입니다!"
        }
    }
    
    /// UIImageView의 fetchImage(from:) 메서드에서 발생가능한 에러들을 상황별로 구분하여 반환하는 메서드입니다.
    static func throwError(url: URL, _ error: Error) -> NetworkError {
        if let error = error as? URLError {
            switch error.errorCode {
            case -1002:
                return NetworkError.unsupportedURL(url)
            case -1009:
                return NetworkError.notConnectedToInternet
            case -999:
                return NetworkError.cancelled
            default:
                return NetworkError.unexpectedURLError(error.errorCode)
            }
        } else {
            return NetworkError.invalidResponse(url)
        }
    }
}
