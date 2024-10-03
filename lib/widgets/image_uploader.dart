import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../common/extensions/extensions.dart';
import '../common/helpers/ui_helper.dart';

import '../models/trip_model.dart';
import 'image_preview.dart';

class ImageUploader extends StatefulWidget {
  final Widget child;
  final String? imageUrl;
  final Function(String? imageUrl) onUpload;

  const ImageUploader({
    super.key,
    required this.child,
    required this.imageUrl,
    required this.onUpload,
  });

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  String? imageUrl;

  OverlayEntry? loader;

  @override
  void initState() {
    super.initState();
    loader = UIHelper.overlayLoader(context);
    imageUrl = widget.imageUrl;
  }

  @override
  didUpdateWidget(ImageUploader oldWidget) {
    super.didUpdateWidget(oldWidget);
    imageUrl = widget.imageUrl;
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    PermissionStatus permissionStatus;

    if (source == ImageSource.camera) {
      permissionStatus = await Permission.camera.request();
    } else {
      permissionStatus = await Permission.photos.request();
    }

    if (permissionStatus.isGranted) {
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        await _uploadImage(image);
      } else {
        UIHelper.of(context).showSnackBar('Image selection cancelled', error: true);
      }
    } else {
      _openSettings();
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadImage(XFile image) async {
    Overlay.of(context).insert(loader!);

    final tripModel = Provider.of<TripModel>(context, listen: false);
    imageUrl = await tripModel.uploadImage(image);

    if (imageUrl != null) {
      widget.onUpload(imageUrl!);
    } else {
      if (imageUrl == null || tripModel.errorMessage == null) {
        UIHelper.of(context).showSnackBar(tripModel.errorMessage ?? 'Failed to upload image', error: true);
      }
    }

    loader!.remove();
  }

  void _deleteImage() {
    UIHelper.of(context).showCustomAlertDialog(
      title: 'Delete Image',
      content: const Text('Are you sure you want to delete this image?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              imageUrl = null;
              widget.onUpload(null);
            });
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }

  void _openSettings() {
    UIHelper.of(context).showCustomAlertDialog(
      title: 'Permission Required',
      content: const Text('Please allow the app to access your photos to upload an image.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            openAppSettings();
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Open Settings'),
        ),
      ],
    );
  }

  Widget _buildChild() {
    return Column(
      children: [
        if (imageUrl != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => ImagePreview(
                          imageProvider: CachedNetworkImageProvider(imageUrl!),
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: CircleAvatar(
                    radius: 18.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: 20.0,
                        color: Theme.of(context).primaryColor.darken(),
                      ),
                      onPressed: _deleteImage,
                    ),
                  ),
                ),
              ],
            ),
          ),
        GestureDetector(
          onTap: () => _showPicker(context),
          child: widget.child,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildChild();
  }
}
