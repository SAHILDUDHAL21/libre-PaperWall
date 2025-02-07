import 'dart:convert';

import 'package:flutter/material.dart';

import '../data/data.dart';
import '../model/wallpaper_model.dart';
import '../widgets/widgets.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  final String searchQuery;

  const Search({super.key, required this.searchQuery});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  List<WallpaperModel> wallpapers = [];

  TextEditingController searchController = TextEditingController();
  
  getSearchWallpaper(String query) async {
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
    getSearchWallpaper(widget.searchQuery);
    searchController.text = widget.searchQuery;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Libre',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              TextSpan(
                text: 'PaperWall',
                style: TextStyle(
                  color: theme.brightness == Brightness.dark ? Colors.orange : theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(30),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withAlpha(179), // 0.7 * 255 ≈ 179
                      ),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        wallpapers.clear();
                        getSearchWallpaper(value);
                      }
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (searchController.text.isNotEmpty) {
                      wallpapers.clear();
                      getSearchWallpaper(searchController.text);
                    }
                  },
                  child: const Icon(Icons.search),
                )
              ],
            ),
          ),
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
