//
//  HalfModalViewController.swift
//  Banner
//
//  Created by Zhihao Miao on 2023/05/27.
//

import UIKit

final class HalfModalViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLable: UILabel!
    @IBOutlet var leftBackGroudView: UIView!
    @IBOutlet var rightBackGroundView: UIView!
    @IBOutlet var leftSegueButton: UIButton!
    @IBOutlet var rightSegueButton: UIButton!
    private var firebaseUtil = FirebaseUtil()
    private var restaurantsData: [Restaurants] = []

    init() {
        super.init(nibName: R.nib.halfModalViewController.name, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setUpBackGroundView()
        self.leftSegueButton.isHidden = true
        self.rightSegueButton.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func segueToDetailView() {
        let detailVC = DetailViewController()
        self.present(detailVC, animated: true)
    }
}

private extension HalfModalViewController {
    func setUpView() {
        Task {
            do {
                restaurantsData = try await firebaseUtil.getDocuments()
                print(restaurantsData)
                guard
                    let leftData = restaurantsData.first?.name,
                    let rightData = restaurantsData.last?.name
                else {
                    return
                }
                self.leftLabel.text = restaurantsData.first?.name
                self.rightLable.text = restaurantsData.last?.name
            } catch {
                print("Failed to retrieve document data: \(error.localizedDescription)")
            }
        }
    }

    func setUpBackGroundView() {
        // 角丸を適用するために、UIViewのレイヤーのコーナー半径を設定
        leftBackGroudView.layer.cornerRadius = leftBackGroudView.frame.height * 0.1

        // シャドウの設定
        leftBackGroudView.layer.shadowColor = UIColor.black.cgColor // シャドウの色
        leftBackGroudView.layer.shadowOpacity = 0.5 // シャドウの透明度
        leftBackGroudView.layer.shadowOffset = CGSize(width: 2, height: 2) // シャドウのオフセット
        leftBackGroudView.layer.shadowRadius = 4 // シャドウのぼかしの範囲

        // 角丸を適用するために、UIViewのレイヤーのコーナー半径を設定
        rightBackGroundView.layer.cornerRadius = leftBackGroudView.frame.height * 0.1

        // シャドウの設定
        rightBackGroundView.layer.shadowColor = UIColor.black.cgColor // シャドウの色
        rightBackGroundView.layer.shadowOpacity = 0.5 // シャドウの透明度
        rightBackGroundView.layer.shadowOffset = CGSize(width: 2, height: 2) // シャドウのオフセット
        rightBackGroundView.layer.shadowRadius = 4 // シャドウのぼかしの範囲
    }
}
