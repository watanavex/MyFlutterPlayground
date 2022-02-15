import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomImageWidget extends HookConsumerWidget {
  const CustomImageWidget({
    Key? key,
    required this.imageUrl,
    required this.placeholder,
  }) : super(key: key);

  final String imageUrl;
  final Widget Function() placeholder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => placeholder(),
        errorWidget: (context, url, error) => placeholder(),
      ),
    );
  }
}
