//
//  GPTModel.swift
//  Banner
//
//  Created by Keitaro Kawahara on 2023/05/28.
//

import Foundation

class GPTModel {
    
    // ChatGPTのAPIエンドポイントとAPIキー
    let apiKey = "ed4b254cca554e8a9a6268b6b85ce477"
    let apiUrl = URL(string: "https://aoai-hakodate.openai.azure.com/openai/deployments/hakodate/chat/completions?api-version=2023-03-15-preview")!
    
    enum APIError: Error {
        case invalidResponse
    }

//    func summarizeComments(comments: [String], apiKey: String) async throws -> String {
//        var messages = [[String: String]]()
//
//        let systemMessage = ["role": "system", "content": "You are a helpful assistant."]
//        messages.append(systemMessage)
//
//        for comment in comments {
//            let userMessage = ["role": "user", "content": comment]
//            messages.append(userMessage)
//        }
//
//        let parameters: [String: Any] = [
//            "model": "gpt-3.5-turbo",
//            "messages": messages,
//            "max_tokens": 300
//        ]
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
//
//        var request = URLRequest(url: apiUrl)
//        request.httpMethod = "POST"
//        request.setValue(apiKey, forHTTPHeaderField: "api-key")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
//            let errorMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
//            print("Invalid response: \(statusCode) - \(errorMessage)")
//            throw APIError.invalidResponse
//        }
//
//        let json = try JSONSerialization.jsonObject(with: data, options: [])
//        guard let jsonArray = json as? [String: Any] else {
//            let jsonString = String(data: data, encoding: .utf8) ?? "Invalid JSON"
//            print("Invalid JSON response: \(jsonString)")
//            throw APIError.invalidResponse
//        }
//
//        if let choices = jsonArray["choices"] as? [[String: Any]],
//           let firstChoice = choices.first,
//           let message = firstChoice["message"] as? [String: Any],
//           let content = message["content"] as? String {
//            return content
//        } else {
//            throw APIError.invalidResponse
//        }
//    }

    
//    // APIリクエストを送信して要約を取得する関数
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

    

}
