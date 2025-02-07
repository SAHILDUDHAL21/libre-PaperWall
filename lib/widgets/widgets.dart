import 'package:flutter/material.dart';
import 'package:libre_paperwall/views/image_view.dart';
import '../model/wallpaper_model.dart';

Widget brandName() {
  return const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Libre",
        style: TextStyle(color: Colors.black87),
      ),
      Text(
        " PaperWall",
        style: TextStyle(color: Colors.blue),
      ),
    ],
  );
}

Widget wallpapersList({required List<WallpaperModel> wallpapers, required BuildContext context}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      children: wallpapers.map((wallpaper) {
        return GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ImageView(imgUrl: wallpaper.src?.portrait ?? '')
              ));
            },
            child: Hero(
              tag: wallpaper.src?.portrait ?? '',
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: wallpaper.src?.portrait != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          wallpaper.src?.portrait ?? '',
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
