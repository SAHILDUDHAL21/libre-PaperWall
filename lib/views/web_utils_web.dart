import 'dart:html' as html;

void downloadOrOpenImage(String url, String filename) {
  final anchor = html.AnchorElement(href: url)
    ..target = '_blank'
    ..download = filename;
  html.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
}
