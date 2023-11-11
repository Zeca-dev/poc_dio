import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppWebView extends StatefulWidget {
  const AppWebView({
    super.key,
    required this.title,
    required this.url,
    required this.messageError,
  });

  final String title;
  final String url;
  final String messageError;

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  bool hasError = false;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              ),
            hasError
                ? Center(
                    child: Text(
                    widget.messageError,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
                  ))
                : Expanded(child: WebViewWidget(controller: _createWebViewController())),
          ],
        ));
  }

  _createWebViewController() => WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
          //todo: Verificar o loading
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {
          setState(() {
            isLoading = false;
            hasError = true;
          });
        },
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(widget.url));
}
