//
//  HalfModalViewController.swift
//  Banner
//
//  Created by Zhihao Miao on 2023/05/27.
//

import UIKit

class HalfModalViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.showHalfModal()
        }
        
    }

    private func showHalfModal() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modalVC = storyboard.instantiateViewController(withIdentifier: "modal")
        let nextVC = UIViewController(nibName: R.nib.halfModalViewController.name, bundle: nil)
        if let sheet = nextVC.sheetPresentationController {
            sheet.detents = [
                .custom { context in 0.3 * context.maximumDetentValue }
            ]
        }
        nextVC.presentationController?.delegate = self
        present(nextVC, animated: true, completion: nil)
    }
}
