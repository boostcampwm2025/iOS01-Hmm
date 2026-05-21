import Foundation

extension Bundle {
    var kakaoAppKey: String {
        return infoDictionary?["KAKAO_APP_KEY"] as? String ?? ""
    }
}
