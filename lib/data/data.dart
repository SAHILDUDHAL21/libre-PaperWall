import 'package:libre_paperwall/model/catagories_model.dart';

String apiKey = "Your_Api_Key"; //pexel cha api use kela ahe

List<CategoriesModel> getCatagories() {
  List<CategoriesModel> categories = [];

  // Nature
  categories.add(CategoriesModel(
      imgUrl:
          "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg",
      categoriesName: "Nature"));

  // Abstract
  categories.add(CategoriesModel(
      imgUrl:
          "https://images.pexels.com/photos/2110951/pexels-photo-2110951.jpeg",
      categoriesName: "Abstract"));

  // City
  categories.add(CategoriesModel(
      imgUrl:
          "https://images.pexels.com/photos/466685/pexels-photo-466685.jpeg",
      categoriesName: "City"));

  // Minimal
  categories.add(CategoriesModel(
      imgUrl:
          "https://images.pexels.com/photos/1738434/pexels-photo-1738434.jpeg",
      categoriesName: "Minimal"));

  // Cars
  categories.add(CategoriesModel(
      imgUrl:
          "https://images.pexels.com/photos/3802510/pexels-photo-3802510.jpeg",
      categoriesName: "Cars"));

  // Space
  categories.add(CategoriesModel(
      imgUrl:
          "https://images.pexels.com/photos/1169754/pexels-photo-1169754.jpeg",
      categoriesName: "Space"));

  return categories;
}
