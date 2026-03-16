import 'package:flutter/material.dart';

class MedicalSectionHeader extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color? color;

  const MedicalSectionHeader({
    super.key,
    required this.title,
    this.fontSize = 14,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: color ?? Theme.of(context).textTheme.bodySmall?.color,
        fontWeight: FontWeight.w800,
        fontSize: fontSize,
        letterSpacing: 1.2,
      ),
    );
  }
}

class MedicalTag extends StatelessWidget {
  final String text;

  const MedicalTag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class MedicalInfoBox extends StatelessWidget {
  final String title;
  final String text;
  final IconData icon;
  final Color? color;

  const MedicalInfoBox({
    super.key,
    required this.title,
    required this.text,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: themeColor, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MedicalPlaceholderImage extends StatelessWidget {
  final String label;
  final double height;
  final bool isMain;
  final String? imagePath;

  const MedicalPlaceholderImage({
    super.key,
    required this.label,
    this.height = 150,
    this.isMain = false,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isMain ? Theme.of(context).cardColor : Theme.of(context).dividerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isMain 
            ? Theme.of(context).primaryColor.withValues(alpha: 0.2) 
            : Theme.of(context).dividerColor, 
          width: 1.5,
        ),
      ),
      child: imagePath != null 
        ? Image.asset(
            imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(context),
          )
        : _buildPlaceholder(context),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isMain ? Icons.monitor_heart_outlined : Icons.add_photo_alternate_outlined,
            color: isMain 
              ? Theme.of(context).primaryColor.withValues(alpha: 0.3) 
              : Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.4),
            size: isMain ? 48 : 32,
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isMain 
                ? Theme.of(context).primaryColor.withValues(alpha: 0.4) 
                : Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.5),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class BulletPointItem extends StatelessWidget {
  final String text;

  const BulletPointItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class NumberedStepItem extends StatelessWidget {
  final int number;
  final String text;

  const NumberedStepItem({
    super.key,
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
