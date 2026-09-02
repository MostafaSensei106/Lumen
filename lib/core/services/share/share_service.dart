abstract class ShareService {
  Future<void> shareText(String text, {String? subject});
  Future<void> shareUrl(String url, {String? subject});
}
