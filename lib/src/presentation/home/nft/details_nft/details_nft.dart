import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/presentation/home/nft/details_nft/body_details_nft.dart';

class DetailsNFT extends StatefulWidget {
  const DetailsNFT({Key? key}) : super(key: key);

  @override
  State<DetailsNFT> createState() => _DetailsNFTState();
}

class _DetailsNFTState extends State<DetailsNFT> {
  @override
  Widget build(BuildContext context) {
    return const DetailsNFTBody();
  }
}