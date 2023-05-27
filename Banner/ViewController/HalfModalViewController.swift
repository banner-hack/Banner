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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
}
