import Foundation

extension Bundle {
    var kakaoAppKey: String {
        return infoDictionary?["KAKAO_APP_KEY"] as? String ?? ""
    }

    var adMobInterstitialAdUnitID: String {
        return infoDictionary?["ADMOB_INTERSTITIAL_AD_UNIT_ID"] as? String ?? ""
    }
}
