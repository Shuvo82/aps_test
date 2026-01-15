import 'package:flutter/material.dart';
import '../../../core/constant/app_colors.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;

  const HeaderSection({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (icon != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 50, color: AppColors.white),
              ),
            if (icon != null) const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
