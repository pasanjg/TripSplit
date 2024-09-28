import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreview extends StatefulWidget {
  final ImageProvider imageProvider;

  const ImagePreview({
    super.key,
    required this.imageProvider,
  });

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Center(
                child: PhotoView(
                  imageProvider: widget.imageProvider,
                  backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
