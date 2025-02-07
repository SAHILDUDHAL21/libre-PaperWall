import 'package:flutter/material.dart';
import 'package:libre_paperwall/data/data.dart';
import 'package:libre_paperwall/model/wallpaper_model.dart';
import 'package:libre_paperwall/views/category.dart';
import 'package:libre_paperwall/views/search.dart';
import '../model/catagories_model.dart';
import '../widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'about_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoriesModel> catagories = [];
  List<WallpaperModel> wallpapers = [];

  TextEditingController searchController = TextEditingController();

  getTreandingWallpaper() async {
    var responce = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated?per_page=80"),
        headers: {"Authorization": apiKey});

    Map<String, dynamic> jsonData = jsonDecode(responce.body);
    jsonData["photos"].forEach((element) {
      WallpaperModel wallpaperModel = WallpaperModel.fromJson(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {});
  }

  @override
  void initState() {
    catagories = getCatagories();
    getTreandingWallpaper();
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
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: theme.colorScheme.onSurface),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
            tooltip: 'About',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: (theme.colorScheme.onSurface.a * 0.7),
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Search(
                                searchQuery: value,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (searchController.text.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Search(
                              searchQuery: searchController.text,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Icon(Icons.search),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 60,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: catagories.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: CategoriesTile(
                      title: catagories[index].categoriesName,
                      imgUrl: catagories[index].imgUrl,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            wallpapersList(wallpapers: wallpapers, context: context)
          ],
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgUrl;
  final String title;

  const CategoriesTile({
    super.key,
    required this.title,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Categories(categorieName: title.toLowerCase()),
          ),
        );
      },
      child: Container(
        width: 120,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgUrl,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              ),
            ),
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
