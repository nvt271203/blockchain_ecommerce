
import 'package:flutter/material.dart';

class Constants {
  /// WALLET RELATED CONSTANTS
  // static const netWorkEndpoints = "https://rpc-mumbai.maticvigil.com/";
  static const netWorkEndpoints = "https://matic-mumbai.chainstacklabs.com/";

  // static const netWorkEndpoints = "https://polygon-rpc.com/";

  static const String aud = 'https://walletconnect.org/login';
  static const String domain = 'walletconnect.org';



  //=======>Blockchain Data
  //Contract Data
  // final CONTRACT_ADDRESS = "0x37369b8a6befccc4c5d4a6d0e9284e5b002e795f";

  // final CONTRACT_ADDRESS = "0x5a7f23b2b209f4aeb0e0c41343f3cd8367309242";
  // final CONTRACT_ADDRESS = "0xa89b2ceb338485ac2a7d0765ecae37af62a67b9e";
  // final CONTRACT_ADDRESS = "0xe5747f557496554f780730df7c87d4c2a748f9eb";
  // final CONTRACT_ADDRESS = "0xe010bb29d365f0b2ab7328dcc69b6f70c26ed836";
  // final CONTRACT_ADDRESS = "0x39cabbbd033963b236e4395ebd3bc63e7ff76d5c";
  final CONTRACT_ADDRESS = "0xddef2b9dab22501892af54f2fcd3b9ae8c791671";

  // final CONTRACT_ABI_PATH = "assets/abis/MarketplaceProducts.json";
  final CONTRACT_ABI_PATH = "images/abis/MarketplaceProducts.json";

  //Blockchain Network Data // mạng này để connect đến blockchain.

  // final NETWORK_HTTPS_RPC = "https://sepolia.infura.io/v3/80bf8f251e6b4d468a47a90985640a64";
  // final  NETWORK_WSS_RPC = "wss://sepolia.infura.io/ws/v3/80bf8f251e6b4d468a47a90985640a64";

  // final NETWORK_HTTPS_RPC = "https://sepolia.infura.io/v3/24517b325a5c46d8b8e02d72ab4b9000";
  // final  NETWORK_WSS_RPC = "https://sepolia.infura.io/v3/24517b325a5c46d8b8e02d72ab4b9000";
  //
  final NETWORK_HTTPS_RPC = "https://sepolia.infura.io/v3/f380e79857164e81b31c8e5b5d776ddb";
  final  NETWORK_WSS_RPC = "wss://sepolia.infura.io/ws/v3/f380e79857164e81b31c8e5b5d776ddb";


  final CHAIN_ID =11155111;
  final imageMoke = "https://images.unsplash.com/photo-1618042164219-62c820f10723?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1374&q=80";

  //PINATA DATA
  // final PINATA_API_KEY = "c601b0a25ab4ee0b36e8";
  // final PINATA_API_SECRET_KEY ="6e6be430f9b28768c2fa678fe8a4c6dab48f2ed22191099e685713bac4d1e12b";
  // final PINATA_API_KEY = "2f0c21b4c1aa8e3fd541";
  // final PINATA_API_SECRET_KEY ="45b0beea3c49b6965fd08f1f2e86597afe54a392e278f38dc32a35baf409f2e2";
  final PINATA_API_KEY = "dc1bbf5783fbeee4cce5";
  final PINATA_API_SECRET_KEY ="ce2e9735b016837f74f7fe6deba1bc4fb8c55d721b0bb5f2f64ee624e32dfe90";



  final PINATE_END_POINT_API ="https://api.pinata.cloud/pinning/pinFileToIPFS";
  final PINATE_FETCH_IMAGE_URL = "https://gateway.pinata.cloud/ipfs/";


  //========>
  final mainYellowColor =  Color(0xffF1B026);
  final mainBlackColor =  Color(0xff08090B);
  final mainGrayColor =  Color(0xffA2A9C2);
  final mainBGColor =  Color(0xffF4F4F5);
  final mainWhiteGColor =  Color(0xffF8F1FC);
  final mainButttonColor =  Color(0xffF8F0FD);
  final mainRedColor =  Color(0xffC2161E);

    // final List<String> categoryList = <String>[
    //   "Games",
    //   "Art",
    //   "Sport",
    //   "3D",
    //   "Photograpghy",
    //   "Collectables"
    // ];

  final List<String> categoryList = <String>[
    "Model",
    "Lego",
    "Toy",
    "Car",
    "3D",
    "T-Shirt",
    "Shorts",
    "Dress",
  ];
  final List<String> categoryImageList = <String>[
    'assets/icons/icon_model.svg',
    'assets/icons/icon_lego.svg',
    'assets/icons/icon_toy.svg',
    'assets/icons/icon_car.svg',
    'assets/icons/icon_3d.svg',
    'assets/icons/icon_toy.svg',
    'assets/icons/icon_car.svg',
    'assets/icons/icon_3d.svg',
  ];
    final mokeParagraph = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,";
}