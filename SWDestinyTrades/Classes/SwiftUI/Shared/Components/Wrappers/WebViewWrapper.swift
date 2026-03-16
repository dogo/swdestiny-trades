//
//  WebViewWrapper.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI
import WebKit

struct WebViewWrapper: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {}

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {}

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation, withError error: Error) {
            OSLogDiagnosticsLogger.shared.logError("WebView navigation failed: \(error.localizedDescription)")
        }
    }
}

#Preview {
    let previewURL = URL(string: "https://www.coruscant-initiative.org") ?? URL(fileURLWithPath: "/")
    return WebViewWrapper(url: previewURL)
}
