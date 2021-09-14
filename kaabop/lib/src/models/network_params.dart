class NetworkParams {
  //MN stand for Mainnet
  //TN stand for Testnet

  String httpUrlMN;
  String wsUrlMN;
  String httpUrlTN;
  String wsUrlTN;
  int ss58;

  NetworkParams({
    this.httpUrlMN,
    this.wsUrlMN,
    this.httpUrlTN,
    this.wsUrlTN,
    this.ss58,
  });
}
