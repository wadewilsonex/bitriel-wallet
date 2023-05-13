class NetworkParams {
  //MN stand for Mainnet
  //TN stand for Testnet
  String? name;
  String? httpUrlMN;
  String? wsUrlMN;
  String? httpUrlTN;
  String? wsUrlTN;
  String? scanMn;
  String? scanTN;
  int? ss58;
  int? ss58MN;

  NetworkParams({
    this.name,
    this.httpUrlMN,
    this.wsUrlMN,
    this.httpUrlTN,
    this.wsUrlTN,
    this.scanMn,
    this.scanTN,
    this.ss58,
    this.ss58MN
  });
}
