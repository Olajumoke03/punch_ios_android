class FeaturedNewsModel {
  int? id;
  String? date;
  String? dateGmt;
  String? link;
  Title? title;
  Content? content;
  Content? excerpt;
  int? author;
  int? featuredMedia;
  List<int>? categories;
  String? xCategories;
  List<String>? categoriesString;
  String? xTags;
  String? xFeaturedMedia;
  String? xFeaturedMediaMedium;
  String? xFeaturedMediaLarge;
  String? xFeaturedMediaOriginal;
  String? xDate;
  String? xAuthor;

  FeaturedNewsModel(
      {id,
        date,
        dateGmt,
        link,
        title,
        content,
        excerpt,
        author,
        featuredMedia,
        categories,
        categoriesString,
        xCategories,
        xTags,
        xFeaturedMedia,
        xFeaturedMediaMedium,
        xFeaturedMediaOriginal,
        xFeaturedMediaLarge,
        xDate,
        xAuthor
      });

  FeaturedNewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    dateGmt = json['date_gmt'];
    link = json['link'];
    title = json['title'] != null ? Title.fromJson(json['title']) : null;
    content =
    json['content'] != null ? Content.fromJson(json['content']) : null;
    excerpt =
    json['excerpt'] != null ? Content.fromJson(json['excerpt']) : null;
    author = json['author'];
    featuredMedia = json['featured_media'];
    categories = json['categories'].cast<int>();
    categoriesString = json['x_categories'].split(',');
    xCategories = json['x_categories'];
    xTags = json['x_tags'];
    xFeaturedMedia = json['x_featured_media'];
    xFeaturedMediaMedium = json['x_featured_media_medium'];
    xFeaturedMediaOriginal = json['x_featured_media_original'];
    xFeaturedMediaLarge = json['x_featured_media_large'];
    xDate = json['x_date'];
    xAuthor = json['x_author'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['date_gmt'] = dateGmt;
    data['link'] = link;
    if (title != null) {
      data['title'] = title!.toJson();
    }
    if (content != null) {
      data['content'] = content!.toJson();
    }
    if (excerpt != null) {
      data['excerpt'] = excerpt!.toJson();
    }
    data['author'] = author;
    data['featured_media'] = featuredMedia;
    data['categories'] = categories;
    data['x_categories'] = xCategories;
    data['x_tags'] = xTags;
    data['x_featured_media'] = xFeaturedMedia;
    data['x_featured_media_medium'] = xFeaturedMediaMedium;
    data['x_featured_media_original'] = xFeaturedMediaOriginal;
    data['x_featured_media_large'] = xFeaturedMediaLarge;
    data['x_date'] = xDate;
    data['x_author'] = xAuthor;
    return data;
  }
}

class Title {
  String? rendered;

  Title({rendered});

  Title.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rendered'] = rendered;
    return data;
  }
}

class Content {
  String? rendered;
  bool? protected;

  Content({rendered, protected});

  Content.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
    protected = json['protected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rendered'] = rendered;
    data['protected'] = protected;
    return data;
  }
}