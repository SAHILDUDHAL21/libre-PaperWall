class WallpaperModel {
  String? photographer;
  String? photographerUrl;
  int? photographerId;
  SrcModel? src;

  WallpaperModel(
    this.src,
    this.photographer,
    this.photographerUrl,
    this.photographerId,
  );

  factory WallpaperModel.fromJson(Map<String, dynamic> jsonData) {
    return WallpaperModel(
      SrcModel.fromJson(jsonData["src"]),
      jsonData["photographer"],
      jsonData["photographerUrl"],
      jsonData["photographerId"],
    );
  }
}

class SrcModel {
  String original;
  String small;
  String portrait;

  SrcModel(this.original, this.small, this.portrait);

  factory SrcModel.fromJson(Map<String, dynamic> jsonData) {
    return SrcModel(
      jsonData["original"],
      jsonData["small"],
      jsonData["portrait"],
    );
  }
}