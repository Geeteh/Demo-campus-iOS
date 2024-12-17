//
//  MapView.swift
//  Campus
//
//  Created by Drake Geeteh on 2/22/24.
//

import Foundation
import SwiftUI
import WebKit

struct InteractiveMap: UIViewRepresentable {
    
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("Provisional navigation failed with error: \(error.localizedDescription)")
    }
        
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Navigation failed with error: \(error.localizedDescription)")
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let script = """
               var newElement = document.createElement("div");
               // Set some attributes to the new element
               newElement.setAttribute("id", "testElement");
               newElement.setAttribute("class", "test-class");
               // Set some text content to the new element
               newElement.textContent = "This is a test element added by JavaScript.";
               // Append the new element to the body of the document
               document.body.appendChild(newElement);
            """
            webView.evaluateJavaScript(script, completionHandler: nil)
        }
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
}

struct MapView: View {
    var body: some View {
        InteractiveMap(urlString: "https://map.okstate.edu")
        
    }
}
