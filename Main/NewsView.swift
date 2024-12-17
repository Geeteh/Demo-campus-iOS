//
//  NewsView.swift
//  Campus
//
//  Created by Drake Geeteh on 2/27/24.
//

import Foundation

import SwiftUI
import SwiftSoup

struct NewsView: View {
    @State private var summary: String = "Loading summary..."

    func summarizeHTMLContent(from url: String) {
        guard getApiKey() != nil else {
            print("API key not found.")
            return
        }
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let htmlString = String(data: data, encoding: .utf8) {
                do {
                    let doc = try SwiftSoup.parse(htmlString)
                    let text = try doc.text()
                    self.summarizeText(text) // Call using self.summarizeText
                    // print(summary)
                } catch {
                    print("Error parsing HTML: \(error)")
                }
            }
        }.resume()
    }
        
    func summarizeText(_ text: String) {
        guard let apiKey = getApiKey() else {
            print("API key not found.")
            return
        }
        
        let prompt = "Summarize the following text in 2 sentences only:\n\n\(text)"
        let headers: [String: String] = ["Content-Type": "application/json",
                       "Authorization": "Bearer \(apiKey)"]
        let parameters: [String: Any] = ["model": "davinci-002", "prompt": prompt,
                          "max_tokens": 50] // Adjust max_tokens as needed
        
        guard let url = URL(string: "https://api.openai.com/v1/completions") else {
            print("Invalid API endpoint URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                print(jsonObject)
                if let jsonDict = jsonObject as? [String: Any], let choices = jsonDict["choices"] as? [[String: Any]], !choices.isEmpty {
                    if let text = choices[0]["text"] as? String {
                        DispatchQueue.main.async {
                            // print(text)
                            self.summary = text
                        }
                    }
                }
            } catch {
                print("Error parsing JSON response: \(error)")
            }
        }
        task.resume()
    }

        var body: some View {
            VStack {
                Text("Summarized Text")
                    .font(.title)
                    .padding()
                
                Text(summary)
                    .padding()
                    .onAppear {
                        summarizeHTMLContent(from: "https://en.wikipedia.org/wiki/Albert_Einstein")
                    }
                
                
                Spacer()
            }
        }
    
    
    func getApiKey() -> String? {
        return "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"
    }
}


