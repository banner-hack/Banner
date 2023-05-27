import SwiftUI
import Alamofire

struct ContentView: View {
    @State private var generatedText: String = ""
    
    var body: some View {
        VStack {
            Text(generatedText)
                .padding()
            
            Button("Generate Text") {
                generateTextFromAPI()
            }
            .padding()
        }
    }
    
    func generateTextFromAPI() {
        let apiKey = "ed4b254cca554e8a9a6268b6b85ce477"
        let apiUrl = "https://aoai-hakodate.openai.azure.com/"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        // JSONファイルのパスを指定します
        guard let jsonFilePath = Bundle.main.path(forResource: "input", ofType: "json") else {
            print("JSON file not found")
            return
        }
        
        // JSONデータを読み込みます
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonFilePath)) else {
            print("Failed to read JSON data")
            return
        }
        
        do {
            // JSONデータをパースします
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            // パースされたデータをAPIリクエストのパラメータとして使用します
            let parameters: Parameters = jsonObject as? Parameters ?? [:]
            
            AF.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        // リクエストが成功した場合の処理
                        if let jsonResponse = value as? [String: Any],
                           let choices = jsonResponse["choices"] as? [[String: Any]],
                           let generatedText = choices.first?["text"] as? String {
                            DispatchQueue.main.async {
                                self.generatedText = generatedText
                            }
                        }
                    case .failure(let error):
                        // リクエストが失敗した場合の処理
                        print(error)
                    }
                }
        } catch {
            print("Failed to parse JSON data: \(error)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
