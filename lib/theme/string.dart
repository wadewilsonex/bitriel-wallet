// ignore: avoid_classes_with_only_static_members
class AppString {
  static String appName = "Bitriel";

  //route_name
  static const String splashScreenView = '/';
  static const String localAuth = '/localAuth';
  static const String txActivityView = '/txactivity';
  static const String checkinView = '/checkin';
  static const String accountView = '/account';
  static const String contactBookView = '/contactbook';
  static const String passcodeView = '/passcode';
  static const String importAccView = '/import';
  static const String contentBackup = '/contentsbackup';
  static const String recieveWalletView = '/recieveWallet';
  static const String claimAirdropView = '/claimairdrop';
  static const String navigationDrawerView = '/navigationdrawer';
  static const String inviteFriendView = '/invitefriend';
  static const String setupAccView = '/importUserInfo';
  static const String confirmationTxView = '/confirmationTx';

  static const String contactAppBarTitle = 'Contact List';
  static const String confirmTxTitle = 'Confirm Transaction';

  static String contentConnection = "Something wrong with your connection ";

  static String backupPassphrase = "Backup Passphrase";

  //create account guide description
  static String backup = "Backup prom";
  static String offlineStorage = "Offline storage";
  static String getMnemonic =
      "Getting a passphrase equals ownership of the wallet asset.";
  static String keepMnemonic =
      "Use paper and pen to correctly copy passphrase.";
  static String mnemonicAdvise =
      "Keep it safe to a safe place on the isolated network.\n\nDo not share and store passphrase in a networked environment, such as emails, photo albums, social applications.";

  //generate mnenomnic screen note's text
  static String screenshotNote =
      "Note: Do not take screenshot, someone will have fully access to your assets, if they get your passphrase! Please write down your passphrase, then store it at a safe place.";

  //confirm mnenomic screen text
  static String confirmMnemonic = "Confirm the passphrase";
  static String clickMnemonic =
      "Please click on the passphrase in the correct order to confirm";

  static String claimAirdropNote =
      "Share Selendra's love to your friends by posting this airdrop on your social media profile Twitter, Linkedin, Facebook.";
  static String createAccTitle = "Getting Started";
  static String importAccTitle = "Restore Wallet";

  static String reset = "Reset";
  static String welcome = "Welcome to";
  static String next = "Next";

  //for loading balance pattern
  static const String loadingPattern = '--.--';

  //transaction confirmation
  static const amtToSend = 'Amount To Send:';
  static const to = 'TO:';
  static const gasFee = 'GAS FEE:';
  static const gasPrice = 'Gas Price';
  static const gasLimit = 'Gas Limit:';
  static const total = 'TOTAL';
  static const amtPGasFee = 'AMOUNT + GAS FEE';
  static const confirm = 'CONFIRM';

  //swap screen description
  static const String swapNote = 'Swapping Note';
  static const String swapfirstNote =
      'This swap is only applied for SEL token holders, whom received SEL v1 during the Selendra\'s airdrop first session.';
  static const String swapSecondNote =
      '🚀 Swap rewards: this is part of the airdrop 2. For example, if you have 100 SEL v1, after swapped you will have 200 SEL v2 to keep and use in the future.';
  static const String swapThirdNote =
      '🚀 SEL v2 will be the utility token for Selendra with cross-chains capability. This meant that SEL v2 will be able to perform on both Selendra network as well as other network such as Polygon, Ethereum, BSC.';

  // Presale contents
  static const String header = "How it works";
  static const String contents = """
A very simple and easy method for participation in a presale Please follow the steps:
1. Connect you metamask wallet.
2. Enter the contribution amount in BNB.
3. Press Contribute.

OFFICIAL SELENDRA TOKEN ADDRESS : 0xF3840e453f751ecA77467da08781C58C1A156B04
  """;
}