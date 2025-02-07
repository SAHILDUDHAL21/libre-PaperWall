import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/data.dart';
import '../model/wallpaper_model.dart';
import '../widgets/widgets.dart';

class Categories extends StatefulWidget {
  final String categorieName;

  const Categories({
    super.key,
    required this.categorieName,
  });

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<WallpaperModel> wallpapers = [];

  getCategoryWallpaper(String query) async {
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=80"),
        headers: {"Authorization": apiKey});

    Map<String, dynamic> jsonData = jsonDecode(response.body);

    jsonData["photos"].forEach((element) {
      WallpaperModel wallpaperModel = WallpaperModel.fromJson(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {});
  }

  @override
  void initState() {
    getCategoryWallpaper(widget.categorieName);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: brandName(),
        elevation: 0.0,
      ),
      body: Column(
        children: [

          const SizedBox(height: 16),
          Expanded(
            child: wallpapers.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              child: wallpapersList(wallpapers: wallpapers, context: context),
            ),
          )
        ],
      ),
    );
  }
}
