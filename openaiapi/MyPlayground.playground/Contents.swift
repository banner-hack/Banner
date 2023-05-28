//import Foundation
//
//let apiKey = "ed4b254cca554e8a9a6268b6b85ce477"
//let apiUrl = URL(string: "https://aoai-hakodate.openai.azure.com/openai/deployments/hakodate/chat/completions?api-version=2023-03-15-preview")!
//
//// APIリクエストを送信して要約を取得する関数
//func summarizeComments(comments: [String], apiKey: String, completion: @escaping (Result<String, Error>) -> Void) {
//    let prompt = comments.joined(separator: "\n")
//
//    let parameters: [String: Any] = [
//        "prompt": prompt,
//        "max_tokens": 100
//    ]
//
//    let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
//
//    var request = URLRequest(url: apiUrl)
//    request.httpMethod = "POST"
//    request.setValue(apiKey, forHTTPHeaderField: "api-key")
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//    //            completion(.failure(APIError.invalidResponse))
//                return
//            }
//
//            if let responseString = String(data: data, encoding: .utf8) {
//                completion(.success(responseString))
//            } else {
//    //            completion(.failure(APIError.invalidResponse))
//            }
//        }
//
//        task.resume()
//    }
//
////    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
////        if let error = error {
////            completion(.failure(error))
////            return
////        }
////
////        guard let data = data else {
////            // completion(.failure(APIError.invalidResponse))
////            return
////        }
////
////        do {
////            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
////               let choices = json["choices"] as? [[String: Any]],
////               let firstChoice = choices.first,
////               let text = firstChoice["text"] as? String {
////                completion(.success(text))
////
////            } else {
//////                 completion(.failure(APIError.invalidResponse))
////            }
////        } catch {
////            completion(.failure(error))
////        }
////
////    }
////    task.resume()
////}
//
//
//// 1つのセットのコメントを要約する関数
//func summarizeCommentSet(commentSet: [String], apiKey: String) {
//    summarizeComments(comments: commentSet, apiKey: apiKey) { result in
//        switch result {
//        case .success(let summary):
//            print("Comment Set:")
//            for comment in commentSet {
//                print("- \(comment)")
//            }
//            print("Summary: \(summary)")
//            print("---------")
//
//        case .failure(let error):
//            print("Error: \(error)")
//        }
//    }
//}
//
//// ダミーデータとしてコメントセットを定義
//let commentSet = [
//    "店内の雰囲気が落ち着いており、食事をゆっくり楽しめた。",
//    "海鮮の新鮮さが感じられ、味わい深い一品だった。",
//    "スタッフの対応が素晴らしく、気持ちよく食事ができた。",
//    "海鮮の種類やボリュームが少なく、物足りなさを感じた。",
//    "ライスの量が多く、バランスが取りづらかった。",
//    "価格が高めで、コストパフォーマンスが少し劣る印象だった。",
//    "トッピングや具材の組み合わせがマンネリで、飽きが来た。",
//    "待ち時間が長く、サービスのスピードが改善できると良い。",
//    "音響が響きやすく、静かな食事が難しかった。",
//    "店内の清潔感や衛生管理に改善の余地があるように感じた。"
//]
//
//// コメントセットの要約を取得
//summarizeCommentSet(commentSet: commentSet, apiKey: apiKey)

//import Foundation
//
//// ChatGPTのAPIエンドポイントとAPIキー
//let apiKey = "YOUR_API_KEY"
//let apiUrl = URL(string: "https://api.openai.com/v1/chat/completions")!
//
//// APIリクエストを送信して要約を取得する関数
//func summarizeComments(comments: [String], apiKey: String, completion: @escaping (Result<String, Error>) -> Void) {
//    var messages = [[String: String]]()
//
//    // システムメッセージの追加
//    let systemMessage = ["role": "system", "content": "You are a helpful assistant."]
//    messages.append(systemMessage)
//
//    // ユーザーメッセージの追加
//    for comment in comments {
//        let userMessage = ["role": "user", "content": comment]
//        messages.append(userMessage)
//    }
//
//    let parameters: [String: Any] = [
//        "model": "gpt-3.5-turbo",
//        "messages": messages,
//        "max_tokens": 100
//    ]
//
//    let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
//
//    var request = URLRequest(url: apiUrl)
//    request.httpMethod = "POST"
//    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.httpBody = jsonData
//
//    enum APIError: Error {
//        case invalidResponse
//    }
//
//    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//        if let error = error {
//            completion(.failure(error))
//            return
//        }
//
//        guard let data = data else {
//            print("111")
//            completion(.failure(APIError.invalidResponse))
//            return
//        }
//
//        do {
//            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//               let choices = json["choices"] as? [[String: Any]],
//               let firstChoice = choices.first,
//               let message = firstChoice["message"] as? [String: Any],
//               let content = message["content"] as? String {
//                completion(.success(content))
//
//            } else {
//                print("112")
//                completion(.failure(APIError.invalidResponse))
//            }
//        } catch {
//            completion(.failure(error))
//        }
//    }
//
//    task.resume()
//}
//
//// コメントセットを100文字で要約する関数
//func summarizeCommentSet(commentSet: [String], apiKey: String) {
//    summarizeComments(comments: commentSet, apiKey: apiKey) { result in
//        switch result {
//        case .success(let summary):
//            print("Comment Set:")
//            for comment in commentSet {
//                print("- \(comment)")
//            }
//            print("Summary:")
//            print(summary)
//            print("---------")
//
//        case .failure(let error):
//            print("Error: \(error)")
//        }
//    }
//}
//
//// ダミーデータとしてコメントセットを定義
//let commentSet = [
//    "店内の雰囲気が落ち着いており、食事をゆっくり楽しめた。",
//    "海鮮の新鮮さが感じられ、味わい深い一品だった。",
//    "スタッフの対応が素晴ら"]
//
//summarizeCommentSet(commentSet: commentSet, apiKey: apiKey)

//import Foundation
//
//// ChatGPTのAPIエンドポイントとAPIキー
//let apiKey = "ed4b254cca554e8a9a6268b6b85ce477"
//let apiUrl = URL(string: "https://aoai-hakodate.openai.azure.com/openai/deployments/hakodate/chat/completions?api-version=2023-03-15-preview")!
//
//// APIリクエストを送信して要約を取得する関数
//func summarizeComments(comments: [String], apiKey: String, completion: @escaping (Result<String, Error>) -> Void) {
//    var messages = [[String: String]]()
//
//    // システムメッセージの追加
//    let systemMessage = ["role": "system", "content": "You are a helpful assistant."]
//    messages.append(systemMessage)
//
//    // ユーザーメッセージの追加
//    for comment in comments {
//        let userMessage = ["role": "user", "content": comment]
//        messages.append(userMessage)
//    }
//
//    let parameters: [String: Any] = [
//        "model": "gpt-3.5-turbo",
//        "messages": messages,
//        "max_tokens": 100
//    ]
//
//    let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
//
//    var request = URLRequest(url: apiUrl)
//    request.httpMethod = "POST"
//    request.setValue(apiKey, forHTTPHeaderField: "api-key")
//    //request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.httpBody = jsonData
//
//    enum APIError: Error {
//        case invalidResponse
//    }
//
//    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//        if let error = error {
//            completion(.failure(error))
//            return
//        }
//
//        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
//            let errorMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
//            completion(.failure(APIError.invalidResponse))
//            print("Invalid response: \(statusCode) - \(errorMessage)")
//            return
//        }
//
//        guard let data = data else {
//            completion(.failure(APIError.invalidResponse))
//            return
//        }
//
//        do {
//            let json = try JSONSerialization.jsonObject(with: data, options: [])
//            guard let jsonArray = json as? [String: Any] else {
//                let jsonString = String(data: data, encoding: .utf8) ?? "Invalid JSON"
//                completion(.failure(APIError.invalidResponse))
//                print("Invalid JSON response: \(jsonString)")
//                return
//            }
//
//            if let choices = jsonArray["choices"] as? [[String: Any]],
//               let firstChoice = choices.first,
//               let message = firstChoice["message"] as? [String: Any],
//               let content = message["content"] as? String {
//                completion(.success(content))
//            } else {
//                completion(.failure(APIError.invalidResponse))
//            }
//        } catch {
//            completion(.failure(error))
//        }
//    }
//
//    task.resume()
//}
//
//// コメントセットを100文字で要約する関数
//func summarizeCommentSet(commentSet: [String], apiKey: String) {
//    summarizeComments(comments: commentSet, apiKey: apiKey) { result in
//        switch result {
//        case .success(let summary):
//            print("Comment Set:")
//            for comment in commentSet {
//                print("- \(comment)")
//            }
//            print("Summary:")
//            print(summary)
//            print("---------")
//
//        case .failure(let error):
//            print("Error: \(error)")
//        }
//    }
//}
//
//// ダミーデータとしてコメントセットを定義
//let commentSet = [
//        "店内の雰囲気が落ち着いており、食事をゆっくり楽しめた。",
//        "海鮮の新鮮さが感じられ、味わい深い一品だった。",
//        "スタッフの対応が素晴らしく、気持ちよく食事ができた。",
//        "海鮮の種類やボリュームが少なく、物足りなさを感じた。",
//        "ライスの量が多く、バランスが取りづらかった。",
//        "価格が高めで、コストパフォーマンスが少し劣る印象だった。",
//        "トッピングや具材の組み合わせがマンネリで、飽きが来た。",
//        "待ち時間が長く、サービスのスピードが改善できると良い。",
//        "音響が響きやすく、静かな食事が難しかった。",
//        "店内の清潔感や衛生管理に改善の余地があるように感じた。"
//    ]
//
//summarizeCommentSet(commentSet: commentSet, apiKey: apiKey)

import Foundation

// ChatGPTのAPIエンドポイントとAPIキー
let apiKey = "ed4b254cca554e8a9a6268b6b85ce477"
let apiUrl = URL(string: "https://aoai-hakodate.openai.azure.com/openai/deployments/hakodate/chat/completions?api-version=2023-03-15-preview")!

// APIリクエストを送信して要約を取得する関数
func summarizeComments(comments: [String], apiKey: String, completion: @escaping (Result<String, Error>) -> Void) {
    var messages = [[String: String]]()
    
    // システムメッセージの追加
    let systemMessage = ["role": "system", "content": "You are a helpful assistant."]
    messages.append(systemMessage)
    
    // ユーザーメッセージの追加
    for comment in comments {
        let userMessage = ["role": "user", "content": comment]
        messages.append(userMessage)
    }
    
    let parameters: [String: Any] = [
        "model": "gpt-3.5-turbo",
        "messages": messages,
        "max_tokens": 300
    ]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
    
    var request = URLRequest(url: apiUrl)
    request.httpMethod = "POST"
    request.setValue(apiKey, forHTTPHeaderField: "api-key")
    //request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    enum APIError: Error {
        case invalidResponse
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            let errorMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            completion(.failure(APIError.invalidResponse))
            print("Invalid response: \(statusCode) - \(errorMessage)")
            return
        }
        
        guard let data = data else {
            completion(.failure(APIError.invalidResponse))
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonArray = json as? [String: Any] else {
                let jsonString = String(data: data, encoding: .utf8) ?? "Invalid JSON"
                completion(.failure(APIError.invalidResponse))
                print("Invalid JSON response: \(jsonString)")
                return
            }
            
            if let choices = jsonArray["choices"] as? [[String: Any]],
               let firstChoice = choices.first,
               let message = firstChoice["message"] as? [String: Any],
               let content = message["content"] as? String {
                completion(.success(content))
            } else {
                completion(.failure(APIError.invalidResponse))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    task.resume()
}

// コメントセットを100文字で要約する関数
func summarizeCommentSet(commentSet: [String], apiKey: String) {
    var prompt: [String: String] = [
        "role": "system",
        "content": "You are a helpful assistant."
    ]
    prompt["content"] = "あなたはユーモアのあるジェントルマンです。初めて来店される観光客に向けて、入店したくなるような店舗紹介文を書いてください。"
    var messages = [[String: String]]()
    messages.append(prompt)
    
    for comment in commentSet {
        let userMessage = ["role": "user", "content": comment]
        messages.append(userMessage)
    }
    
    let parameters: [String: Any] = [
        "model": "gpt-3.5-turbo",
        "messages": messages,
        "max_tokens": 300
    ]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
    
    var request = URLRequest(url: apiUrl)
    request.httpMethod = "POST"
    request.setValue(apiKey, forHTTPHeaderField: "api-key")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    enum APIError: Error {
        case invalidResponse
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            let errorMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            print("Invalid response: \(statusCode) - \(errorMessage)")
            return
        }
        
        guard let data = data else {
            print("Invalid response")
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonArray = json as? [String: Any] else {
                let jsonString = String(data: data, encoding: .utf8) ?? "Invalid JSON"
                print("Invalid JSON response: \(jsonString)")
                return
            }
            
            if let choices = jsonArray["choices"] as? [[String: Any]],
               let firstChoice = choices.first,
               let message = firstChoice["message"] as? [String: Any],
               let content = message["content"] as? String {
                print("Comment Set:")
                for comment in commentSet {
                    print("- \(comment)")
                }
                print("Summary:")
                print(content)
                print("---------")
            } else {
                print("Invalid response")
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    task.resume()
}

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

summarizeCommentSet(commentSet: commentSet, apiKey: apiKey)
