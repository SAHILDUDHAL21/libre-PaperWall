import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'web_utils.dart' if (dart.library.html) 'web_utils_web.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;

  const ImageView({
    super.key,
    required this.imgUrl,
  });

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool _isLoading = false;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  Future<String> _getDownloadsPath() async {
    if (Platform.isAndroid) {
      final directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        return directory.path;
      }
      
      // Fallback to external storage
      final externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        throw Exception('Could not access external storage');
      }
      return '${externalDir.path}/Download';
    } else {
      final directory = await getDownloadsDirectory();
      if (directory == null) {
        throw Exception('Could not access Downloads directory');
      }
      return directory.path;
    }
  }

  Future<void> _checkAndRequestPermissions() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // Android 13 and above
        await Permission.photos.request();
      } else {
        // Below Android 13
        await Permission.storage.request();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Stack(
              children: [
                Hero(
                  tag: widget.imgUrl,
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(widget.imgUrl, fit: BoxFit.cover)),
                ),
                Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/1.45,
                        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white60,width: 1),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(30, 0, 0, 0),
                              Color.fromARGB(116, 0, 0, 0),
                              Color.fromARGB(86, 0, 0, 0),
                              Color.fromARGB(131, 0, 0, 0),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _isLoading ? null : _handleSave,
                              child: const Text(
                                "Set WallPaper",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 24
                                ),
                              ),
                            ),
                            const Text(
                              "Image Will Be Saved In Downloads",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 12,),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 16,),
                    ],
                  ),
                )
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withAlpha(128),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!mounted) return;

    if (kIsWeb) {
      // Handle web platform
      downloadOrOpenImage(widget.imgUrl, 'wallpaper_${DateTime.now().millisecondsSinceEpoch}.jpg');
      return;
    }

    bool hasPermission = false;
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // Android 13 and above
        final photos = await Permission.photos.request();
        hasPermission = photos.isGranted;
      } else {
        // Below Android 13
        final storage = await Permission.storage.request();
        hasPermission = storage.isGranted;
      }

      if (!hasPermission) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Storage permission is required to save images'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    await _save();
  }

  Future<void> _save() async {
    if (!mounted) return;
    
    try {
      setState(() {
        _isLoading = true;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saving image...'),
          duration: Duration(seconds: 1),
        )
      );

      // Get the downloads directory
      final downloadsPath = await _getDownloadsPath();
      final wallpaperDir = Directory('$downloadsPath/Libre PaperWall');
      if (!await wallpaperDir.exists()) {
        await wallpaperDir.create(recursive: true);
      }

      // Download and save the image
      final fileName = 'wallpaper_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('${wallpaperDir.path}/$fileName');
      
      final response = await Dio().get(
        widget.imgUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      
      await file.writeAsBytes(response.data);

      // Make it visible in gallery
      if (Platform.isAndroid) {
        await _scanFile(file.path);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image saved successfully to Downloads/Libre PaperWall!'),
          duration: Duration(seconds: 2),
        )
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        )
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _scanFile(String path) async {
    try {
      // Create a method channel to scan media
      const platform = MethodChannel('com.example.libre_paperwall/media');
      await platform.invokeMethod('scanFile', {'path': path});
    } catch (e) {
      debugPrint('Error scanning file: $e');
    }
  }
}
