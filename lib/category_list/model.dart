
class CategoryListModel {
  String? id;
  String? categoryName;
  String? categoryId;
  String? slug;
  String? imageUrl;

  CategoryListModel(
      {id, categoryName, categoryId, slug, imageUrl});

  CategoryListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['title'];
    categoryId = json['tag_id'];
    slug = json['slug'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = categoryName;
    data['tag_id'] = categoryId;
    data['slug'] = slug;
    data['image_url'] = imageUrl;
    return data;
  }
}
