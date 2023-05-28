//
//  HomeViewController.swift
//  Banner
//
//  Created by Keitaro Kawahara on 2023/05/27.
//

import CoreLocation
import MapKit
import UIKit

final class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UIAdaptivePresentationControllerDelegate {
    let imagePickerController = UIImagePickerController()

    @IBOutlet var halfModal: UIButton! {
        didSet {
            halfModal.layer.cornerRadius = 30
            // 影
            halfModal.layer.shadowColor = UIColor.black.cgColor
            halfModal.layer.shadowOpacity = 0.8
            halfModal.layer.shadowRadius = 8.0
            halfModal.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            halfModal.showsTouchWhenHighlighted = false
        }
    }

    private let firebaseUtil = FirebaseUtil()

    @IBOutlet var mapView: MKMapView!

    private var locationManager = CLLocationManager()

    init() {
        super.init(nibName: R.nib.homeViewController.name, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            let halfModal = HalfModalViewController()
            //            halfModal.showHalfModal()
        }

        locationManager.delegate = self
        setupMapView()
        print("CLLocationManager.authorizationStatus=\(CLLocationManager.authorizationStatus().description)")

        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        imagePickerController.cameraCaptureMode = .photo

        // 通知の許可をリクエストする
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { _, _ in
            // Enable or disable features based on authorization
        }
    }

    @IBAction func onRequestAlways(_ sender: Any) {
        locationManager.requestAlwaysAuthorization()
    }

    @IBAction func onRequestWhenInUse(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
    }

    //    @IBAction func testSaveToFirestore() {
    //        Task {
    //            try await firebaseUtil.addDocument()
    //        }
    //    }

    //    @IBAction func testGetData() {
    //        Task {
    //            do {
    //                let restaurantsData = try await firebaseUtil.getDocuments()
    //                print(restaurantsData)
    //            } catch {
    //                print("Failed to retrieve document data: \(error.localizedDescription)")
    //            }
    //        }
    //    }

    @IBAction func qrButtonTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            present(imagePickerController, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }

    @IBAction func halfModalButton() {
        let halfModal = HalfModalViewController()
        self.segueToHalfModalView()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Do something with the image
        }
        picker.dismiss(animated: true, completion: nil)

        // 写真撮影後通知がトリガーされる
        // 写真撮影後通知がトリガーされる
        let content = UNMutableNotificationContent()
        content.title = "撮影完了"
        content.body = "50Pt獲得しました"
        content.sound = .default

        if let imageUrl = Bundle.main.url(forResource: "notification_icon", withExtension: "png") {
            do {
                let attachment = try UNNotificationAttachment(identifier: "notification_icon", url: imageUrl, options: nil)
                content.attachments = [attachment]
            } catch {
                print("通知への画像の添付エラー: \(error.localizedDescription)")
            }
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知リクエストの追加エラー: \(error.localizedDescription)")
            } else {
                print("通知リクエストの追加に成功しました")
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension HomeViewController {
    // 位置情報の許可のステータス変更で呼ばれる
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorization status=\(status.description)")
        switch status {
        case .authorizedAlways:
            manager.requestLocation()
            break
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
            break
        case .notDetermined:
            break
        case .restricted:
            break
        case .denied:
            break
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("didUpdateLocations locations=\(locations)")
//
//        // 一度だけ位置情報を取得したら、位置更新の監視を停止します
//        locationManager.stopUpdatingLocation()
//
//        let location = locations.first
//        guard
//            let latitude = location?.coordinate.latitude,
//            let longitude = location?.coordinate.longitude
//        else {
//            return
//        }
//
//        var locationData = Location(latitude: latitude, longitude: longitude)
//        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        mapView.showsUserLocation = true
//        mapView.setRegion(region, animated: true)
//
//        print(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError error=\(error.localizedDescription)")
    }
    private func setupMapView() {
        // ユーザーの現在位置を取得
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()

        // 地図の初期表示領域を設定
        let initialLocation = CLLocation(latitude: 41.766423, longitude: 140.717687)
        let regionRadius: CLLocationDistance = 300
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)

        // ピンを追加
        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation.coordinate
        mapView.addAnnotation(annotation)
    }

}

private extension HomeViewController {
    @IBAction func getLocation() {
        let locationModel = LocationModel()
        locationModel.setUpLocation()
    }

    func segueToHalfModalView() {
        let halfModalView = HalfModalViewController()

        if let sheet = halfModalView.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(halfModalView, animated: true)
    }
}
