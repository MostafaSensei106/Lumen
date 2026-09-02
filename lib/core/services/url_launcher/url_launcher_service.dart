abstract class UrlLauncherService {
  Future<bool> launch(String url);
  Future<bool> canLaunch(String url);
}
