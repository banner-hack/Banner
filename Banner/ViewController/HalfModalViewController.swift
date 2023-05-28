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
    
    private var jsonText: String = ""
    
    

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
    
    @IBAction func getGPTData() {
        Task{
            self.getGPTData()
        }
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
    
    func getGPT() async throws {
        let gptModel = GPTModel()
        let apiKey = "ed4b254cca554e8a9a6268b6b85ce477"
        let apiUrl = URL(string: "https://aoai-hakodate.openai.azure.com/openai/deployments/hakodate/chat/completions?api-version=2023-03-15-preview")!
        // ダミーデータとしてコメントセットを定義
        let commentSet = [
            "店内の雰囲気が落ち着いており、食事をゆっくり楽しめた。",
            "海鮮の新鮮さが感じられ、味わい深い一品だった。",
            "スタッフの対応が素晴らしく、気持ちよく食事ができた。",
            "海鮮の種類やボリュームが少なく、物足りなさを感じた。",
            "ライスの量が多く、バランスが取りづらかった。",
            "価格が高めで、コストパフォーマンスが少し劣る印象だった。",
            "トッピングや具材の組み合わせがマンネリで、飽きが来た。",
            "待ち時間が長く、サービスのスピードが改善できると良い。",
            "音響が響きやすく、静かな食事が難しかった。",
            "店内の清潔感や衛生管理に改善の余地があるように感じた。"
        ]
        
        Task {
            do {
                let summary = try await gptModel.summarizeComments(comments: commentSet, apiKey: apiKey, completion: <#(Result<String, Error>) -> Void#>)
                print("Summary: \(summary)")
            } catch {
                print("Error: \(error)")
            }
        }

        
    }
    
    
}
