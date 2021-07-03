import 'package:amplify_instagram/utils/storage_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'circular_progress_bar.dart';

// A widget that displays and image given a storage key
class AmplifyStorageImage extends StatelessWidget {
  const AmplifyStorageImage({
    Key? key,
    required this.storageKey,
  }) : super(key: key);

  final String storageKey;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getImageUrl(storageKey),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CachedNetworkImage(
            cacheKey: storageKey, // uses the S3 storage key to cache the image
            fadeInDuration: Duration(milliseconds: 200),
            fadeOutDuration: Duration.zero,
            placeholderFadeInDuration: Duration.zero,
            imageUrl: snapshot.data!,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) {
              return Container(
                color: Colors.grey[200],
                child: Center(
                  child: CircleProgressBar(
                    foregroundColor: Colors.grey[700]!,
                    value: downloadProgress.progress ?? 0,
                  ),
                ),
              );
            },
            errorWidget: (context, url, error) =>
                Center(child: Icon(Icons.cloud_off, size: 36)),
          );
        } else if (snapshot.hasError) {
          return Center(child: Icon(Icons.cloud_off, size: 36));
        } else {
          return Container(
            color: Colors.grey[200],
            child: Center(
                child: CircleProgressBar(
              foregroundColor: Colors.grey[700]!,
              value: 0,
            )),
          );
        }
      },
    );
  }
}
