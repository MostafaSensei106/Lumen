abstract class IapService {
  Future<void> initialize();
  Stream<dynamic> get purchaseStream; // usually Stream<List<PurchaseDetails>>
  Future<bool> isAvailable();
  Future<void> queryProductDetails(Set<String> productIds);
  Future<void> buyProduct(String productId);
  Future<void> restorePurchases();
}
