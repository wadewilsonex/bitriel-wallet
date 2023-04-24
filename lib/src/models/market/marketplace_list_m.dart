import 'package:wallet_apps/index.dart';

List<Map<String, dynamic>> defiList = [];

List<Map<String, dynamic>> marketPlaceList = [];

void initDefiList(){

  AppProvider appPr = Provider.of<AppProvider>(AppProvider.buildContext!, listen: false);

  defiList = [
    {
      "title": "Uniswap",
      "subtitle": "Uniswap is a cryptocurrency exchange which uses a decentralized network protocol. Uniswap is also the name of the company that initially built the Uniswap protocol. The protocol facilitates automated transactions between cryptocurrency tokens on the Ethereum blockchain through the use of smart contracts.",
      "asset": "${appPr.dirPath}/logo/uniswap-logo.png",
      "url": "https://app.uniswap.org/#/swap?chain=mainnet"
    },
    {
      "title": "PancakeSwap",
      "subtitle": "PancakeSwap has the most users of any decentralized platform, ever.",
      "asset": "${appPr.dirPath}/logo/pancake.png",
      "url": "https://pancakeswap.finance/swap"
    },
    {
      "title": "Sushi Swap",
      "subtitle": "SushiSwap is a decentralized exchange (DEX) in which users can exchange between different virtual currencies using a connected cryptocurrency wallet, such as MetaMask.",
      "asset": "${appPr.dirPath}/logo/sushi.png",
      "url": "https://app.sushi.com/en/swap"
    },
    {
      "title": "1Inch",
      "subtitle": "1inch Network is a decentralized exchange (DEX) aggregator to help users discover the best trade prices for tokens. Instead of swapping tokens from a single liquidity pool of a DEX, 1inch will aggregate across different pools and suggest the most efficient way to trade tokens.",
      "asset": "${appPr.dirPath}/logo/1inch.png",
      "url": "https://app.1inch.io/#/1/swap/ETH/DAI"
    },
    {
      "title": "Curve",
      "subtitle": "Curve Finance is a decentralized exchange (DEX) running on Ethereum. It's specifically designed for swapping between stablecoins.",
      "asset": "${appPr.dirPath}/logo/curve.png",
      "url": "https://curve.fi/"
    },
  ];

  marketPlaceList = [

    // {
    //   "title": "Qalima",
    //   "subtitle": "Discover, Collect, and sell extraordinary NFTs.",
    //   "asset": "${appPr.dirPath}/logo/qalima.png",
    //   "url": "https://qalima.vercel.app/"
    // },
    {
      "title": "Krama NFT Marketplace",
      "subtitle": "Krama Marketplace is a niche marketplace for the auction and sale of Non-fungible Tokens (“NFTs”).",
      'asset': "${appPr.dirPath}/logo/krama.png",
      "url": "https://krama.io/"
    },
    {
      "title": "Opensea",
      "subtitle": "The world's first and largest digital marketplace for crypto collectibles and non-fungible tokens (NFTs). Buy, sell, and discover exclusive digital items.",
      "asset": "${appPr.dirPath}/logo/opensea.png",
      "url": "https://opensea.io/login"
    },
    {
      "title": "Rarible",
      "subtitle": "Discover, sell and buy NFTs on Rarible! Whether it's Ethereum NFTs, Solana NFTs or Tezos NFTs, get them on Web3's first multichain marketplace.",
      "asset": "${appPr.dirPath}/logo/rarible.png",
      "url": "https://rarible.com/"
    }
  ];
}