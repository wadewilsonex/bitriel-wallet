abstract class SDKRepository {
  /// 1.
  void setNetworkParam({String? network, int ss58});
  /// 2.
  Future<void> initBitrielSDK({required String jsCode});  
  /// 3.
  Future<void> connectNode({required String jsCode});
  

}