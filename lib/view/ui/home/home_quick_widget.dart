import 'package:box_app/core/app_color.dart';
import 'package:box_app/view/ui/product/new_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../product/offer_product_screen.dart';

class PremiumHomeQuickButtons extends StatelessWidget {
  const PremiumHomeQuickButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Text(
                'تصفح بسرعة'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1E1E),
                  letterSpacing: -0.6,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 18,
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),

          const SizedBox(height: 20),

          /// Buttons
          Row(
            children: [
              _item(
                context,
                'وصل حديثاً',
                'assets/images/new (1).gif',
                AppColor.primaryColor3,
                () {
                  Get.to(() => const NewProductScreen(isCart: false,));
                },
              ),
              const SizedBox(width: 14),
              _item(
                context,
                'عروض مميزة',
                'assets/images/sales (1).gif',
                AppColor.primaryColor3,
                () {
                  Get.to(() => const OfferProductScreen(isCart: false,));
                },
              ),
              // const SizedBox(width: 14),
              // _item(context, 'كاش باك', 'assets/images/cashflow (2).gif',
              //     AppColor.primaryColor3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String title, String asset, Color color,
      void Function() onTap) {
    return Expanded(
      child: PremiumActionButton(
        title: title,
        gifAsset: asset,
        accentColor: color,
        onTap: onTap,
      ),
    );
  }
}

class PremiumActionButton extends StatefulWidget {
  final String title;
  final String gifAsset;
  final Color accentColor;
  final VoidCallback onTap;

  const PremiumActionButton({
    super.key,
    required this.title,
    required this.gifAsset,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<PremiumActionButton> createState() => _PremiumActionButtonState();
}

class _PremiumActionButtonState extends State<PremiumActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(_controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: widget.accentColor.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              children: [
                /// Decorative Background Circle
                Positioned(
                  top: -20,
                  left: -20,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: widget.accentColor.withOpacity(0.04),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Image Area with Glow
                      Expanded(
                        child: Center(
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              widget.gifAsset,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// Title
                      Text(
                        widget.title.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2D3436),
                          height: 1.2,
                        ),
                        maxLines: 1,
                      ),

                      const SizedBox(height: 8),

                      /// Minimalist Handle Bar
                      Container(
                        height: 4,
                        width: 20,
                        decoration: BoxDecoration(
                          color: widget.accentColor.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// class HomeQuickButtons extends StatelessWidget {
//   const HomeQuickButtons({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           // Title with icon
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.blue[50],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(
//                     Icons.flash_on_rounded,
//                     color: Colors.blue,
//                     size: 24,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Text(
//                   'تصفح بسرعة'.tr,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w800,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Buttons Grid
//           const Row(
//             children: [
//               Expanded(
//                 child: ModernActionButton(
//                   title: 'وصل حديثاً',
//                   icon: Icons.new_releases_rounded,
//                   gradient: [Color(0xFF4361EE), Color(0xFF3A0CA3)],
//                   iconColor: Colors.white,
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: ModernActionButton(
//                   title: 'عروض مميزة',
//                   icon: Icons.local_offer_rounded,
//                   gradient: [Color(0xFFF72585), Color(0xFF7209B7)],
//                   iconColor: Colors.white,
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: ModernActionButton(
//                   title: 'كاش باك',
//                   icon: Icons.monetization_on_rounded,
//                   gradient: [Color(0xFF4CC9F0), Color(0xFF4895EF)],
//                   iconColor: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ModernActionButton extends StatefulWidget {
//   final String title;
//   final IconData icon;
//   final List<Color> gradient;
//   final Color iconColor;
//
//   const ModernActionButton({
//     super.key,
//     required this.title,
//     required this.icon,
//     required this.gradient,
//     required this.iconColor,
//   });
//
//   @override
//   State<ModernActionButton> createState() => _ModernActionButtonState();
// }
//
// class _ModernActionButtonState extends State<ModernActionButton> {
//   bool _isHovered = false;
//   bool _isPressed = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       child: GestureDetector(
//         onTapDown: (_) => setState(() => _isPressed = true),
//         onTapUp: (_) => setState(() => _isPressed = false),
//         onTapCancel: () => setState(() => _isPressed = false),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           height: 130,
//           transform: Matrix4.identity()
//             ..translate(0.0, _isPressed ? 4.0 : 0.0)
//             ..scale(_isPressed ? 0.98 : 1.0),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: widget.gradient,
//               stops: [0.0, 0.8],
//             ),
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: widget.gradient.first.withOpacity(_isHovered ? 0.4 : 0.25),
//                 blurRadius: _isHovered ? 24 : 16,
//                 offset: const Offset(0, 8),
//                 spreadRadius: -4,
//               ),
//               if (_isHovered)
//                 BoxShadow(
//                   color: Colors.white.withOpacity(0.2),
//                   blurRadius: 4,
//                   offset: const Offset(-2, -2),
//                 ),
//             ],
//             border: Border.all(
//               color: Colors.white.withOpacity(0.2),
//               width: 1.5,
//             ),
//           ),
//           child: Stack(
//             children: [
//               // Background Pattern
//               Positioned(
//                 top: -20,
//                 right: -20,
//                 child: Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.1),
//                   ),
//                 ),
//               ),
//
//               // Content
//               Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Icon with background
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(14),
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.3),
//                           width: 1.5,
//                         ),
//                       ),
//                       child: Center(
//                         child: Icon(
//                           widget.icon,
//                           color: widget.iconColor,
//                           size: 24,
//                         ),
//                       ),
//                     ),
//
//                     // Title
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.title.tr,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w800,
//                             color: Colors.white,
//                             letterSpacing: -0.2,
//                             height: 1.2,
//                           ),
//                           maxLines: 2,
//                         ),
//                         const SizedBox(height: 8),
//
//                         // Arrow icon
//                         Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: const Icon(
//                             Icons.arrow_back_ios_new_rounded,
//                             color: Colors.white,
//                             size: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Glow effect on hover
//               if (_isHovered)
//                 Positioned.fill(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       gradient: RadialGradient(
//                         center: Alignment.center,
//                         radius: 1.5,
//                         colors: [
//                           Colors.white.withOpacity(0.1),
//                           Colors.transparent,
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Alternative Minimal Design Option
