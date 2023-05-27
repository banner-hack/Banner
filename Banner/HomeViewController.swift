//
//  HomeViewController.swift
//  Banner
//
//  Created by Keitaro Kawahara on 2023/05/27.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        checkLocationAuthorization()
    }
    
    private func setupMapView() {
        // ユーザーの現在位置を取得
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // 地図の初期表示領域を設定
        let initialLocation = locationManager.location ?? CLLocation(latitude: 35.6895, longitude: 139.6917)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        // ピンを追加
        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation.coordinate
        mapView.addAnnotation(annotation)
    }
    
    private func checkLocationAuthorization() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            mapView.showsUserLocation = true
        } else if authorizationStatus == .denied || authorizationStatus == .restricted {
            // 位置情報の使用が許可されていない場合の処理
            // 必要なエラーハンドリングやユーザーへの案内を追加してください
        } else if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    // 位置情報の更新があった場合に呼ばれるメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation() // 一度現在地が表示されたら更新を停止する
    }
    
    // 位置情報の使用許可状態が変更された場合に呼ばれるメソッド
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
}
