import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../services/ContractFactoryServies.dart';
import '../../../../services/Models/ProductModel.dart';
import '../../../../utils/Constants.dart';
import '../widgets/CustomButtonWIdget.dart';

class ProductDetailsPage extends StatefulWidget {
  ProductModel product;

  ProductDetailsPage({required this.product, Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Constants constants = Constants();
  final ContractFactoryServies _contractFactoryServies = ContractFactoryServies();
  String? walletAddress;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkExistingConnection();
  }

  Future<void> _checkExistingConnection() async {
    setState(() {
      isLoading = true;
    });

    try {
      final address = await _contractFactoryServies.restoreWalletConnection();
      setState(() {
        walletAddress = address;
        print('walletAddress: $walletAddress');
        isLoading = false;
      });
      if (address == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể kết nối ví. Vui lòng thử lại.')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi kết nối ví: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var contractFactory = Provider.of<ContractFactoryServies>(context);
    var convertedPrice =
    (int.parse(widget.product.price.toString()) / 1000000000000000000)
        .toString();

    return Scaffold(
      backgroundColor: constants.mainBGColor,
      appBar: AppBar(
        backgroundColor: constants.mainBGColor,
        elevation: 0,
        title: Text(
          widget.product.name,
          style: TextStyle(color: constants.mainYellowColor),
        ),
        iconTheme: IconThemeData(color: constants.mainYellowColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.40,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.product.image),
                  fit: BoxFit.cover,
                  scale: 1,
                ),
              ),
            ),
            Container(
              color: constants.mainBlackColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.gamepad_rounded,
                          color: constants.mainYellowColor,
                          size: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            children: [
                              Text(
                                "Category",
                                style:
                                TextStyle(color: constants.mainYellowColor),
                              ),
                              Text(
                                widget.product.category,
                                style: TextStyle(
                                    color: constants.mainWhiteGColor,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        final url =
                            'https://etherscan.io/address/${widget.product.owner}';
                        if (await canLaunchUrlString(url)) {
                          await launchUrlString(url);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Không thể mở Etherscan')),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.link,
                            color: constants.mainYellowColor,
                            size: 40,
                          ),
                          Text(
                            "Explore",
                            style: TextStyle(
                                color: constants.mainYellowColor, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0, left: 8, bottom: 8),
              child: Text(
                "Description",
                style: TextStyle(
                    color: constants.mainBlackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0, left: 18),
              child: Text(
                widget.product.description,
                style: TextStyle(
                    color: constants.mainBlackColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 15),
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                color: constants.mainWhiteGColor,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      RandomAvatar(widget.product.owner.toString(),
                          height: 50, width: 50),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Seller",
                              style: TextStyle(color: constants.mainBlackColor),
                            ),
                            Text(
                              widget.product.owner.toString(),
                              style: TextStyle(
                                  color: constants.mainGrayColor, fontSize: 12,fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  " ETH ${convertedPrice.length >= 5 ? convertedPrice.substring(0, 5) : convertedPrice} ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: constants.mainBlackColor),
                ),
                widget.product.owner.toString() != walletAddress
                    ? isLoading
                      ? CircularProgressIndicator(
                    color: constants.mainYellowColor,
                  )
                      : customButtonWidget(() async {
                    // Gọi hàm kiểm tra kết nối ví
                    await _checkExistingConnection();

                    // Kiểm tra nếu walletAddress tồn tại thì thực hiện mua
                    if (walletAddress != null) {
                      print('wallet_restore_address $walletAddress');
                      try {
                        await contractFactory.buyProduct(
                          widget.product.id,
                          walletAddress!,
                          widget.product.price,
                        );
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //       content:
                        //       Text('Mua sản phẩm thành công!')),
                        // );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Lỗi khi mua sản phẩm: $e')),
                        );
                      }
                    }
                  }, 15, constants.mainBlackColor, "BUY NOW",
                      constants.mainWhiteGColor, 150)
                    : Text(
                  "Can not Buy Yours",
                  style: TextStyle(
                      fontSize: 10, color: constants.mainRedColor),
                ),
              ],
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}