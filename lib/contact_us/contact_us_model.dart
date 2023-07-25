class ContactModel {
  int? id;
  String? slug;
  String? link;
  Title? title;
  Title? content;
  Excerpt? excerpt;

  ContactModel({this.id, this.slug, this.link, this.title, this.content, this.excerpt});

  ContactModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    link = json['link'];
    title = json['title'] != null ?  Title.fromJson(json['title']) : null;
    content = json['content'] != null ?  Title.fromJson(json['content']) : null;
    excerpt = json['excerpt'] != null ?  Excerpt.fromJson(json['excerpt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
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
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['rendered'] = rendered;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rendered'] = rendered;
    data['protected'] = protected;
    return data;
  }
}