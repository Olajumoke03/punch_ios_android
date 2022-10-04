class LatestNewsModel {
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
  String? xFeaturedMediaLarge;
  List<String>? categoriesString;
  String? xCategories;
  String? xTags;
  String? xFeaturedMedia;
  String? xFeaturedMediaMedium;
  String? xFeaturedMediaOriginal;
  String? xDate;
  String? xAuthor;

  LatestNewsModel(
      {this.id,
        this.date,
        this.dateGmt,
        this.link,
        this.title,
        this.content,
        this.excerpt,
        this.author,
        this.featuredMedia,
        this.categories,
        this.xCategories,
        this.xTags,
        this.xFeaturedMediaLarge,
        this.categoriesString,
        this.xFeaturedMedia,
        this.xFeaturedMediaMedium,
        this.xFeaturedMediaOriginal,
        this.xDate,
        this.xAuthor
      });

  LatestNewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    dateGmt = json['date_gmt'];
    link = json['link'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    content =
    json['content'] != null ? new Content.fromJson(json['content']) : null;
    excerpt =
    json['excerpt'] != null ? new Content.fromJson(json['excerpt']) : null;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['date_gmt'] = this.dateGmt;
    data['link'] = this.link;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    if (this.excerpt != null) {
      data['excerpt'] = this.excerpt!.toJson();
    }
    data['author'] = this.author;
    data['featured_media'] = this.featuredMedia;
    data['categories'] = this.categories;
    data['x_categories'] = this.xCategories;
    data['x_tags'] = this.xTags;
    data['x_featured_media'] = this.xFeaturedMedia;
    data['x_featured_media_medium'] = this.xFeaturedMediaMedium;
    data['x_featured_media_original'] = this.xFeaturedMediaOriginal;
    data['x_featured_media_large'] = this.xFeaturedMediaLarge;
    data['x_date'] = this.xDate;
    data['x_author'] = this.xAuthor;
    return data;
  }
}

class Title {
  String? rendered;

  Title({this.rendered});

  Title.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rendered'] = this.rendered;
    return data;
  }
}

class Content {
  String? rendered;
  bool? protected;

  Content({this.rendered, this.protected});

  Content.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
    protected = json['protected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rendered'] = this.rendered;
    data['protected'] = this.protected;
    return data;
  }
}