import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';

/// NicheSphere — Avatar Widget
class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final Color? borderColor;
  final double borderWidth;

  const AvatarWidget({
    super.key,
    this.imageUrl,
    this.size = 40,
    this.borderColor,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor ?? Colors.white.withOpacity(0.6),
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonPurple.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.gradEnd.withOpacity(0.3),
                  child: Icon(
                    Icons.person_rounded,
                    size: size * 0.5,
                    color: AppColors.textHint,
                  ),
                ),
                errorWidget: (_, __, ___) => _defaultAvatar(),
              )
            : _defaultAvatar(),
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: AppColors.gradEnd.withOpacity(0.3),
      child: Icon(
        Icons.person_rounded,
        size: size * 0.5,
        color: AppColors.neonPurple.withOpacity(0.5),
      ),
    );
  }
}
