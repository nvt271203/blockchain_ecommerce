import 'package:flutter/material.dart';
import 'package:sales_business_app/controllers/product_controller.dart';
import 'package:sales_business_app/views/screens/CreateProductPage.dart';
import 'package:sales_business_app/views/screens/add_product_screen.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/popular_product_widget.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/product_card_gridview.dart';
import 'package:sales_business_app/views/screens/widgets/button_widget.dart';
import '../../../models/product.dart';
import '../../../services/ContractFactoryServies.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; // Để sử dụng Clipboard

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});
  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  late Future<List<Product>> futureProducts;
  final ContractFactoryServies _contractFactoryServies = ContractFactoryServies();
  String? walletAddress;
  bool isLoading = false;
  bool isLoadingProducts = true;
  String? balance;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _checkExistingConnection();
      var contractFactory = Provider.of<ContractFactoryServies>(context, listen: false);
      setState(() {
        isLoadingProducts = true;
      });
      await contractFactory.getUserProducts(walletAddress!);
      setState(() {
        isLoadingProducts = false;
      });
    });
  }

  Future<void> _checkExistingConnection() async {
    setState(() {
      isLoading = true;
    });

    final address = await _contractFactoryServies.restoreWalletConnection();
    if (address != null) {
      setState(() {
        walletAddress = address;
        print('walletAddress: $walletAddress');
        _contractFactoryServies.getBalance(address).then((value) {
          setState(() {
            balance = value;
            print('Số dư ví: $balance');
          });
        });
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phiên làm việc hết hạn. Vui lòng đăng nhập lại.')),
      );
    }
  }

  // Hàm cắt ngắn địa chỉ ví
  String _shortenAddress(String address) {
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  // Hàm sao chép địa chỉ ví
  void _copyAddress() {
    Clipboard.setData(ClipboardData(text: walletAddress!));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Đã sao chép địa chỉ ví'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var contractFactory = Provider.of<ContractFactoryServies>(context);
    print('contractFactory.allUserProducts.length - ${contractFactory.allUserProducts.length}');

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header "My Store"
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.grey[800]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Store',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Icon(
                      Icons.storefront,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),

              // Phần địa chỉ ví tùy chỉnh
              isLoading
                  ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Đang tải dữ liệu...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              )
                  : walletAddress != null
                  ? Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Ví: ${_shortenAddress(walletAddress!)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _copyAddress,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.copy,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Colors.grey,
                      size: 30,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Vui lòng đăng nhập để quản lý sản phẩm',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Nút Add Banner và Add Product
              Row(
                children: [
                  ButtonWidget(
                    onClick: () {},
                    title: 'Add Banner',
                    icon: Icons.add,
                    colorTitle: Colors.white,
                    colorBackground: Colors.black,
                  ),
                  ButtonWidget(
                    onClick: () async {
                      await _checkExistingConnection();
                      if (walletAddress != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateProductPage(walletAddress: walletAddress!),
                          ),
                        );
                      }
                    },
                    title: 'Add Product',
                    icon: Icons.add,
                    colorTitle: Colors.white,
                    colorBackground: Colors.blue,
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Phần Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    'No Banner Available',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Divider và tiêu đề My Products
              Divider(thickness: 1.5, color: Colors.grey[400]),
              SizedBox(height: 10),
              Text(
                'My Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),

              // Hiển thị sản phẩm hoặc thông báo
              isLoadingProducts
                  ? Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Đang tải dữ liệu...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              )
                  : walletAddress == null
                  ? Center(
                child: Text(
                  'Vui lòng đăng nhập để quản lý sản phẩm',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
                  : contractFactory.allUserProducts.isEmpty
                  ? Center(
                child: Text(
                  'Bạn chưa có sản phẩm nào',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tổng sản phẩm: ${contractFactory.allUserProducts.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.70,
                    child: ListView.builder(
                      itemCount: contractFactory.allUserProducts.length,
                      itemBuilder: (context, index) {
                        return customProductCardWidget(
                          context,
                          contractFactory.allUserProducts[index].image,
                          contractFactory.allUserProducts[index].name,
                          contractFactory.allUserProducts[index].price.toString(),
                          contractFactory.allUserProducts[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}