//
//  HalfModalViewController.swift
//  Banner
//
//  Created by Zhihao Miao on 2023/05/27.
//

import UIKit

class HalfModalViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    init() {
        super.init(nibName: R.nib.halfModalViewController.name, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

    func showHalfModal() {
        let nextVC = UIViewController(nibName: R.nib.halfModalViewController.name, bundle: nil)
//        let nextVC = R.storyboard.main.halfModalVC()!

        if let sheet = nextVC.presentationController as? UISheetPresentationController {
            sheet.detents = [
                .custom { context in 0.3 * context.maximumDetentValue }
            ]
        }
        nextVC.presentationController?.delegate = self

        DispatchQueue.main.async {
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true, completion: nil)
        }
    }
    
}
