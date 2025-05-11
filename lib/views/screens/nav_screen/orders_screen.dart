import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_business_app/services/ContractFactoryServies.dart';
import 'package:sales_business_app/services/Models/ProductModel.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/product_card_gridview.dart';
import 'package:flutter/services.dart'; // Để sử dụng Clipboard

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isLoadingProducts = true;
  String? walletAddress;
  final ContractFactoryServies _contractFactoryServies = ContractFactoryServies();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _checkExistingConnection();
    });
  }

  Future<void> _checkExistingConnection() async {
    if (!mounted) return;

    setState(() {
      isLoadingProducts = true;
    });

    try {
      final address = await _contractFactoryServies.restoreWalletConnection();
      if (address == null) {
        setState(() {
          isLoadingProducts = false;
          walletAddress = null;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không thể kết nối ví. Vui lòng đăng nhập lại.'),
            ),
          );
        }
        return;
      }

      setState(() {
        walletAddress = address;
      });

      var contractFactory = Provider.of<ContractFactoryServies>(context, listen: false);
      await contractFactory.getUserPurchasedProducts(walletAddress!);
      if (mounted) {
        setState(() {
          isLoadingProducts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingProducts = false;
          walletAddress = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
          ),
        );
      }
    }
  }

  // Hàm cắt ngắn địa chỉ ví
  String _shortenAddress(String address) {
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  // Hàm sao chép địa chỉ ví
  void _copyAddress(BuildContext context) {
    Clipboard.setData(ClipboardData(text: walletAddress!));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã sao chép địa chỉ ví')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<ContractFactoryServies>(
          builder: (context, contractFactory, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
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

                  // Kiểm tra trạng thái tải ví/sản phẩm
                  isLoadingProducts
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
                      : walletAddress == null
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
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.grey,
                          size: 30,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Vui lòng đăng nhập để mua hàng',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hiển thị thông tin ví
                      Container(
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
                              onTap: () => _copyAddress(context),
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
                      ),
                      const SizedBox(height: 16),

                      // Hiển thị danh sách sản phẩm hoặc thông báo
                      contractFactory.purchasedProducts.isEmpty
                          ? const Center(
                        child: Text(
                          'Bạn chưa mua sản phẩm nào',
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
                            'Tổng sản phẩm đã mua: ${contractFactory.purchasedProducts.length}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: contractFactory.purchasedProducts.length,
                            itemBuilder: (context, index) {
                              final product = contractFactory.purchasedProducts[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: customProductCardWidget(
                                  context,
                                  product.image,
                                  product.name,
                                  product.price.toString(),
                                  product,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}