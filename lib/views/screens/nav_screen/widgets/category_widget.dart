import 'package:flutter/material.dart';
import 'package:sales_business_app/models/category.dart';
import 'package:sales_business_app/views/screens/nav_screen/widgets/slider_widget.dart';
import '../../../../models/banner.dart';
import '../../../../utils/Constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key, this.onCategorySelected});
  final Function(String categoryName)? onCategorySelected;

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  late List<Category> categories;
  // Biến để theo dõi index của category được chọn
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    // Tạo danh sách Category từ Constants.categoryList
    categories = Constants().categoryList.asMap().entries.map((entry) {
      final index = entry.key;
      final categoryName = entry.value;

      // Lấy ảnh từ categoryImageList, nếu không có thì dùng ảnh mặc định
      final image = index < Constants().categoryImageList.length
          ? Constants().categoryImageList[index]
          : Constants().imageMoke;

      return Category(
        id: categoryName.toLowerCase(), // Tạo ID từ tên danh mục
        name: categoryName,
        image: image, // Gán ảnh tương ứng
        banner: '', // Giữ nguyên banner rỗng
      );
    }).toList();

    // Đặt phần tử đầu tiên được chọn mặc định
    _selectedIndex = 0;

    print('Hello E-commerce');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Cuộn theo chiều ngang
      child: Row(
        children: categories.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;

          // Kiểm tra xem category này có được chọn hay không
          final bool isSelected = _selectedIndex == index;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Tránh lỗi Overflow
              children: [
                // Sử dụng GestureDetector để lắng nghe sự kiện click
                GestureDetector(
                  onTap: () {
                    setState(() {
                      print('You already clicked ${category.name}');
                      // Cập nhật index của category được chọn
                      _selectedIndex = index;
                      // Gọi callback nếu có
                      if (widget.onCategorySelected != null) {
                        widget.onCategorySelected!(category.name);
                      }
                    });
                  },
                  child: Container(
                    // Thêm màu nền xanh lam nếu category được chọn
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.cyan : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(4.0), // Khoảng cách giữa icon và nền
                    child: SvgPicture.asset(
                      category.image,
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 8), // Khoảng cách giữa ảnh và text
                Text(
                  category.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}