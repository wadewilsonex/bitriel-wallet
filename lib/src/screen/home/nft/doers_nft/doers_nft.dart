import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wallet_apps/src/screen/home/nft/doers_nft/body_doers_nft.dart';

class DoersNFT extends StatefulWidget {
  const DoersNFT({Key? key}) : super(key: key);

  @override
  State<DoersNFT> createState() => _DoersNFTState();
}

class _DoersNFTState extends State<DoersNFT> {

  @override
  initState(){

    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DoersNFTBody();
  }
}