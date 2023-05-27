//
//  LocationModel.swift
//  Banner
//
//  Created by Keitaro Kawahara on 2023/05/27.
//

import CoreLocation
import Foundation

final class LocationModel: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()

    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        setUpLocation()
    }

    func setUpLocation() {
        // 常に使用する場合、バックグラウンドでも取得するようにする
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            // バックグラウンドでも取得

            locationManager.allowsBackgroundLocationUpdates = true
        } else {
            // バックグラウンドでは取得
            locationManager.allowsBackgroundLocationUpdates = false
        }

        // 位置情報の取得精度を指定
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // 更新に必要な最小移動距離
        // Int値を指定することで、○○m間隔で取得するようになります
        locationManager.distanceFilter = 10

        // 移動手段を指定
        // 徒歩、自動車等
        locationManager.activityType = .fitness
    }
}

extension CLAuthorizationStatus {
    var description: String {
        switch self {
        case .notDetermined:
            return "未選択"
        case .restricted:
            return "ペアレンタルコントロールなどの影響で制限中"
        case .denied:
            return "利用拒否"
        case .authorizedAlways:
            return "常に利用許可"
        case .authorizedWhenInUse:
            return "使用中のみ利用許可"
        default:
            return ""
        }
    }
}
