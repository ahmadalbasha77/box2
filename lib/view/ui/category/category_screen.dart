import 'package:box_app/controller/category/category_controller.dart';
import 'package:box_app/model/home/category_model.dart';
import 'package:box_app/view/ui/category/sub_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../core/app_color.dart';
import '../../widget/cache_image_widget.dart';

class CategoryScreen extends StatelessWidget {
  final bool isCart;

  CategoryScreen({super.key, this.isCart = true});

  final _controller = CategoryController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // appBar: _buildAppBar(),
      appBar: AppBar(
        title: Text(
          'الاصناف'.tr,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,

        // foregroundColor: Colors.black,
        backgroundColor: AppColor.primaryColor,
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildSearchSection(),
            const SizedBox(height: 24),
            Expanded(
              child: GetBuilder<CategoryController>(
                builder: (logic) {
                  return PagedGridView<int, CategoryData>(
                    pagingController: logic.pagingController,
                    padding: const EdgeInsets.only(bottom: 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.6,
                    ),
                    builderDelegate: PagedChildBuilderDelegate<CategoryData>(
                      itemBuilder: (context, item, index) {
                        return _CategoryCard(data: item);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: _controller.controllerSearch,
        onChanged: (value) {
          if (value.trim().isEmpty) {
            _controller.refreshScreen();
          }
        },
        onSubmitted: (_) => _controller.refreshScreen(),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Container(
            margin: const EdgeInsets.only(left: 16),
            child: const Icon(
              Icons.search_rounded,
              color: AppColor.primaryColor,
              size: 22,
            ),
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 20),
              onPressed: () => _controller.refreshScreen(),
              padding: EdgeInsets.zero,
            ),
          ),
          hintText: 'ابحث عن صنف'.tr,
          hintStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.grey[500],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColor.primaryColor.withOpacity(0.3),
              width: 2,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final CategoryData data;

  const _CategoryCard({required this.data});

  @override
  State<_CategoryCard> createState() => __CategoryCardState();
}

class __CategoryCardState extends State<_CategoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          Get.to(
            () => SubCategoryScreen(
              category: widget.data,
            ),
            arguments: {'id': widget.data.id},
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 350),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -4.0 : 0.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.04),
                blurRadius: _isHovered ? 25 : 15,
                offset: Offset(0, _isHovered ? 12 : 6),
              ),
            ],
            border: Border.all(
              color: Colors.grey[100]!,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Image Container with Gradient
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColor.primaryColor.withOpacity(0.08),
                        AppColor.primaryColor.withOpacity(0.02),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child:Hero(
                          tag: 'category_${widget.data.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CacheImageWidget(
                              image: widget.data.imageUrl,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),

                      ),

                      /// Hover Overlay
                      if (_isHovered)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColor.primaryColor.withOpacity(0.1),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              /// Category Name and Arrow
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? AppColor.primaryColor.withOpacity(0.05)
                      : Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        widget.data.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // AnimatedContainer(
                    //   duration: Duration(milliseconds: 200),
                    //   margin: EdgeInsets.only(right: 4),
                    //   padding: EdgeInsets.all(4),
                    //   decoration: BoxDecoration(
                    //     color: _isHovered ? AppColor.primaryColor : Colors.grey[200],
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   child: Icon(
                    //     Icons.arrow_forward_ios_rounded,
                    //     size: 12,
                    //     color: _isHovered ? Colors.white : Colors.grey[600],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
