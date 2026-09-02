abstract class GamesServices {
  Future<void> initialize();
  Future<bool> signIn();
  Future<void> submitScore({required String leaderboardId, required int score});
  Future<void> unlockAchievement({required String achievementId});
  Future<void> showLeaderboards();
  Future<void> showAchievements();
}
