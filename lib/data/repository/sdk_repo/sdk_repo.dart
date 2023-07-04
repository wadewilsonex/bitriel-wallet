abstract class SDKRepository {
  /// 1.
  void initParam();
  /// 2.
  Future<void> initBitrielSDK({required String jsCode, int nodeIndex = 0});  
  /// 3.
  Future<void> connectNode({required String jsCode});

}