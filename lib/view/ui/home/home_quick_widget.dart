import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeQuickCards extends StatelessWidget {
  const HomeQuickCards({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: MinimalVerticalCard(
              title: 'وصل حديثاً',
              subtitle: 'اكتشف أحدث المنتجات',
              icon: Icons.auto_awesome,
              accent: Color(0xFF2196F3),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: MinimalVerticalCard(
              title: 'عروض مميزة',
              subtitle: 'خصومات لفترة محدودة',
              icon: Icons.local_fire_department,
              accent: Color(0xFFFF9800),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: MinimalVerticalCard(
              title: 'كاش باك',
              subtitle: 'استرجع جزء من مشترياتك',
              icon: Icons.sync,
              accent: Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }
}

class MinimalVerticalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;

  const MinimalVerticalCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: accent.withOpacity(0.18),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Icon
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withOpacity(0.10),
            ),
            child: Icon(
              icon,
              size: 24,
              color: accent,
            ),
          ),

          const SizedBox(height: 18),

          /// Title
          Text(
            title.tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              height: 1.25,
            ),
          ),

          const SizedBox(height: 8),

          /// Subtitle
          Expanded(
            child: Text(
              subtitle.tr,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey.shade600,
                height: 1.45,
              ),
            ),
          ),

          /// Bottom accent line
          Container(
            height: 3,
            width: 32,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
