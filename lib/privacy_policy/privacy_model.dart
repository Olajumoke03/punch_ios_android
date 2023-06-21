class PrivacyPolicyModel {
  int? id;
  String? slug;
  String? link;
  Title? title;
  Title? content;
  Excerpt? excerpt;

  PrivacyPolicyModel({this.id, this.slug, this.link, this.title, this.content, this.excerpt});

  PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    link = json['link'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    content = json['content'] != null ? new Title.fromJson(json['content']) : null;
    excerpt = json['excerpt'] != null ? new Excerpt.fromJson(json['excerpt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
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

class Excerpt {
  String? rendered;
  bool? protected;

  Excerpt({this.rendered, this.protected});

  Excerpt.fromJson(Map<String, dynamic> json) {
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