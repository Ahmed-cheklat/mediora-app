import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorCard extends StatelessWidget {
  final String fullName;
  final String specialty;
  final String? assetImage;
  final String? networkImage; // ← add this
  final VoidCallback? onTap;

  const DoctorCard({
    super.key,
    required this.fullName,
    required this.specialty,
    this.assetImage,
    this.networkImage, // ← add this
    this.onTap,
  });

  ImageProvider? get _image {
    if (networkImage != null &&
        networkImage!.startsWith('http') &&
        networkImage! != 'string') {
      return NetworkImage(networkImage!);
    }
    if (assetImage != null) return AssetImage(assetImage!);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final image = _image;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFFE8EFFD),
            backgroundImage: image,
            child: image == null
                ? const Icon(Icons.person, color: Color(0xFF2463EB), size: 28)
                : null,
          ),
          title: Text(
            fullName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
          ),
          subtitle: Text(
            specialty,
            style: TextStyle(color: const Color(0xFF2463EB), fontSize: 12.sp),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF2463EB),
            size: 16,
          ),
        ),
      ),
    );
  }
}