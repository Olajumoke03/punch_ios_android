// class CategoryListModel {
//   String categoryId;
//   int count;
//   String link;
//   String categoryName;
//   int parent;
//
//   CategoryListModel({this.categoryId, this.count, this.link, this.categoryName, this.parent});
//
//     factory CategoryListModel.fromJson(Map<String, dynamic> parsedJson) {
//     return CategoryListModel(
//       categoryId: parsedJson['tag_id'],
//       categoryName: parsedJson['title'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['tag_id'] = this.categoryId;
//     data['count'] = this.count;
//     data['link'] = this.link;
//     data['title'] = this.categoryName;
//     data['parent'] = this.parent;
//     return data;
//   }
// }
//


class CategoryListModel {
  String? id;
  String? categoryName;
  String? categoryId;
  String? slug;
  String? imageUrl;

  CategoryListModel(
      {this.id, this.categoryName, this.categoryId, this.slug, this.imageUrl});

  CategoryListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['title'];
    categoryId = json['tag_id'];
    slug = json['slug'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.categoryName;
    data['tag_id'] = this.categoryId;
    data['slug'] = this.slug;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
