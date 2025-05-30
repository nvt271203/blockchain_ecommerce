import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_business_app/services/ContractFactoryServies.dart';
import 'package:sales_business_app/services/Models/ProductModel.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/banner_widget.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/category_widget.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/grid_product_widget.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/header_widget.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/slider_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../utils/Constants.dart';
import 'widgets/product_card_gridview.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Constants constants = Constants();
  String categoryNameSelected = "Model";
  // late ContractFactoryServies _contractFactoryServies ;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var contractFactory = Provider.of<ContractFactoryServies>(context);
    //phải cs hàm này ms lấy ra đc dữ liệu của danh mục sản phẩm mặc định
    contractFactory.getCategoryProducts(categoryNameSelected);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 52),
            const HeaderWidget(),

            const BannerWidget(),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.white],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Icon(Icons.filter_alt_sharp),
                ],
              ),
            ),
            const SizedBox(height: 10),
            CategoryWidget(
              onCategorySelected: (categoryName) async {
                print('HomeScreen nhận được danh mục: $categoryName');
                setState(() {
                  categoryNameSelected =
                      categoryName; // Cập nhật danh mục được chọn
                });
                await Provider.of<ContractFactoryServies>(context,
                    listen: false)
                    .getCategoryProducts(categoryName);
              },
            ),
            const SizedBox(height: 20),
            Consumer<ContractFactoryServies>(
              builder: (context, contractFactoryServies, child) {
                return Column(
                  children: [
                    // Hiển thị số lượng sản phẩm
                    Text(
                      'Tổng sản phẩm: ${contractFactory.categoryProducts.length}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    // Hiển thị trạng thái tải hoặc danh sách sản phẩm
                    if (contractFactory.storeProductsLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (contractFactory.categoryProducts.isEmpty)
                      const Center(
                          child:
                          Text('Cửa hàng hiện chưa có danh mục sản phẩm này'))
                    else
                      Container(
                        child: AlignedGridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          padding: const EdgeInsets.all(15),
                          itemCount: contractFactory.categoryProducts.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          crossAxisCount: 2,
                          itemBuilder: (context, index) {
                            return customProductCardWidget(
                              context,
                              contractFactory.categoryProducts[index].image,
                              contractFactory.categoryProducts[index].name,
                              contractFactory.categoryProducts[index].price
                                  .toString(),
                              contractFactory.categoryProducts[index],
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
