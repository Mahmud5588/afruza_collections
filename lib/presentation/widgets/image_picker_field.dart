import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:dio/dio.dart";
import "dart:io";
import "../../core/di.dart";

class ImagePickerField extends StatefulWidget {
  const ImagePickerField({
    super.key,
    this.initialImages = const [],
    required this.onImagesSelected,
    this.maxImages = 5,
  });

  final List<String> initialImages;
  final Function(List<String>) onImagesSelected;
  final int maxImages;

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  late List<String> _selectedImages;
  bool _isUploading = false;
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedImages = List.from(widget.initialImages);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _addManualUrl() async {
    final url = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Rasm URL qo'shish"),
        content: TextField(
          controller: _urlController,
          decoration: const InputDecoration(
            hintText: "https://example.com/image.jpg",
            labelText: "Rasm URL",
          ),
          autofocus: true,
          onSubmitted: (value) {
            Navigator.pop(context, value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Bekor qilish"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context, _urlController.text.trim());
            },
            child: const Text("Qo'shish"),
          ),
        ],
      ),
    );

    if (url != null && url.isNotEmpty && mounted) {
      if (url.startsWith('http://') || url.startsWith('https://')) {
        setState(() {
          _selectedImages.add(url);
        });
        widget.onImagesSelected(_selectedImages);
        _urlController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("URL qo'shildi"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("URL http:// yoki https:// bilan boshlanishi kerak"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= widget.maxImages) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Maximum ${widget.maxImages} images allowed")),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Show loading
      if (!mounted) return;
      setState(() {
        _isUploading = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Rasm yuklanmoqda..."),
          duration: Duration(seconds: 30),
        ),
      );

      try {
        // Upload to backend
        final dio = sl<Dio>();
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
            pickedFile.path,
            filename: pickedFile.name,
          ),
        });

        final response = await dio.post('/upload/image', data: formData);

        if (response.statusCode == 200) {
          final imageUrl = response.data['url'] as String;

          if (!mounted) return;
          setState(() {
            _selectedImages.add(imageUrl);
            _isUploading = false;
          });
          widget.onImagesSelected(_selectedImages);

          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Rasm yuklandi: ${pickedFile.name}"),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _isUploading = false;
        });

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Xatolik: Rasmni yuklashda xatolik yuz berdi. Backend'da /upload/image endpoint yo'qmi?"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    widget.onImagesSelected(_selectedImages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rasmlar (${_selectedImages.length}/${widget.maxImages})",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        if (_selectedImages.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final imagePath = _selectedImages[index];
                final isNetworkImage = imagePath.startsWith("http") ||
                    imagePath.startsWith("https");

                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: isNetworkImage
                          ? Image.network(
                              imagePath,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (_, __, ___) => Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image),
                              ),
                            )
                          : Image.file(
                              File(imagePath),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isUploading
                    ? null
                    : (_selectedImages.length < widget.maxImages
                        ? _pickImage
                        : null),
                icon: _isUploading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add_photo_alternate_outlined),
                label: Text(
                  _isUploading ? "Yuklanmoqda..." : "Galerey",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _selectedImages.length < widget.maxImages
                    ? _addManualUrl
                    : null,
                icon: const Icon(Icons.link),
                label: const Text(
                  "URL",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
