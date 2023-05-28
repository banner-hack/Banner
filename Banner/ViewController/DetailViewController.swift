//
//  DetailViewController.swift
//  Banner
//
//  Created by Keitaro Kawahara on 2023/05/28.
//

import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var shopName: UILabel!

    private var firebaseUtil = FirebaseUtil()
    private var restaurantsData: [Restaurants] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUp()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

private extension DetailViewController {
    func setUp() {
        Task {
            do {
                self.restaurantsData = try await firebaseUtil.getDocuments()
                guard let shopName = restaurantsData.first?.name
                else {
                    return
                }
                self.shopName.text = shopName
            } catch {
                print("error")
            }
        }
    }
}
