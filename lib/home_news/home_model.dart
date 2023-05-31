
class HomeNewsModel {
  int? id;
  String? date;
  String? dateGmt;
  Guid? guid;
  String? modified;
  String? modifiedGmt;
  String? slug;
  String? status;
  String? type;
  String? link;
  Guid? title;
  Content? content;
  Content? excerpt;
  int? author;
  int? featuredMedia;
  String? commentStatus;
  String? pingStatus;
  bool? sticky;
  String? template;
  String? format;
  List<void>? meta;
  List<int>? categories;
  List<int>? tags;
  String? yoastHead;
  // YoastHeadJson? yoastHeadJson;
  String? jetpackFeaturedMediaUrl;
  Links? lLinks;
  String? xCategories;
  String? xAuthor;
  List<String>? articleSplit;
  String? xFeaturedMediaLarge;
  List<String>? categoriesString;
  String? xTags;
  String? xFeaturedMedia;
  String? xFeaturedMediaMedium;
  String? xFeaturedMediaOriginal;
  String? xDate;


  HomeNewsModel(
      {id,
        date,
        dateGmt,
        guid,
        modified,
        modifiedGmt,
        slug,
        status,
        type,
        link,
        title,
        content,
        excerpt,
        author,
        featuredMedia,
        commentStatus,
        pingStatus,
        sticky,
        template,
        format,
        meta,
        categories,
        tags,
        yoastHead,
        // yoastHeadJson,
        jetpackFeaturedMediaUrl,
        lLinks,
      xCategories,
      xAuthor,
      articleSplit,
      categoriesString,
      xDate,
      xFeaturedMedia,
      xFeaturedMediaLarge,
      xFeaturedMediaMedium,
      xFeaturedMediaOriginal,
      xTags});

  HomeNewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    dateGmt = json['date_gmt'];
    guid = json['guid'] != null ? Guid.fromJson(json['guid']) : null;
    modified = json['modified'];
    modifiedGmt = json['modified_gmt'];
    slug = json['slug'];
    status = json['status'];
    type = json['type'];
    link = json['link'];
    title = json['title'] != null ? Guid.fromJson(json['title']) : null;
    content = json['content'] != null ? Content.fromJson(json['content']) : null;
    excerpt = json['excerpt'] != null ? Content.fromJson(json['excerpt']) : null;
    author = json['author'];
    featuredMedia = json['featured_media'];
    commentStatus = json['comment_status'];
    pingStatus = json['ping_status'];
    sticky = json['sticky'];
    template = json['template'];
    format = json['format'];
    xCategories = json['x_categories'];
    xAuthor = json['x_author'];
    articleSplit = json['content']['rendered'].replaceAll('<p','@#%!<p').split('@#%!');
    categories = json['categories'].cast<int>();
    tags = json['tags'].cast<int>();
    yoastHead = json['yoast_head'];
    // yoastHeadJson = json['yoast_head_json'] != null
    //     ? YoastHeadJson.fromJson(json['yoast_head_json'])
    //     : null;
    jetpackFeaturedMediaUrl = json['jetpack_featured_media_url'];
    lLinks = json['_links'] != null ? Links.fromJson(json['_links']) : null;
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
    if (guid != null) {
      data['guid'] = guid!.toJson();
    }
    data['modified'] = modified;
    data['modified_gmt'] = modifiedGmt;
    data['slug'] = slug;
    data['status'] = status;
    data['type'] = type;
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
    data['comment_status'] = commentStatus;
    data['ping_status'] = pingStatus;
    data['sticky'] = sticky;
    data['template'] = template;
    data['format'] = format;
    data['categories'] = categories;
    data['x_author'] = xAuthor;
    data['x_categories'] = xCategories;
    data['tags'] = tags;
    data['yoast_head'] = yoastHead;
    // if (yoastHeadJson != null) {
    //   data['yoast_head_json'] = yoastHeadJson!.toJson();
    // }
    data['jetpack_featured_media_url'] = jetpackFeaturedMediaUrl;
    if (lLinks != null) {
      data['_links'] = lLinks!.toJson();
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

class Guid {
  String? rendered;

  Guid({rendered});

  Guid.fromJson(Map<String, dynamic> json) {
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

class YoastHeadJson {
  String? title;
  String? description;
  Robots? robots;
  String? canonical;
  String? ogLocale;
  String? ogType;
  String? ogTitle;
  String? ogDescription;
  String? ogUrl;
  String? ogSiteName;
  String? articlePublishedTime;
  String? articleModifiedTime;
  List<OgImage>? ogImage;
  String? twitterCard;
  TwitterMisc? twitterMisc;
  Schema? schema;

  YoastHeadJson(
      {title,
        description,
        robots,
        canonical,
        ogLocale,
        ogType,
        ogTitle,
        ogDescription,
        ogUrl,
        ogSiteName,
        articlePublishedTime,
        articleModifiedTime,
        ogImage,
        twitterCard,
        twitterMisc,
        schema});

  YoastHeadJson.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    robots =
    json['robots'] != null ? Robots.fromJson(json['robots']) : null;
    canonical = json['canonical'];
    ogLocale = json['og_locale'];
    ogType = json['og_type'];
    ogTitle = json['og_title'];
    ogDescription = json['og_description'];
    ogUrl = json['og_url'];
    ogSiteName = json['og_site_name'];
    articlePublishedTime = json['article_published_time'];
    articleModifiedTime = json['article_modified_time'];
    if (json['og_image'] != null) {
      ogImage = <OgImage>[];
      json['og_image'].forEach((v) {
        ogImage!.add(OgImage.fromJson(v));
      });
    }
    twitterCard = json['twitter_card'];
    twitterMisc = json['twitter_misc'] != null
        ? TwitterMisc.fromJson(json['twitter_misc'])
        : null;
    schema =
    json['schema'] != null ? Schema.fromJson(json['schema']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    if (robots != null) {
      data['robots'] = robots!.toJson();
    }
    data['canonical'] = canonical;
    data['og_locale'] = ogLocale;
    data['og_type'] = ogType;
    data['og_title'] = ogTitle;
    data['og_description'] = ogDescription;
    data['og_url'] = ogUrl;
    data['og_site_name'] = ogSiteName;
    data['article_published_time'] = articlePublishedTime;
    data['article_modified_time'] = articleModifiedTime;
    if (ogImage != null) {
      data['og_image'] = ogImage!.map((v) => v.toJson()).toList();
    }
    data['twitter_card'] = twitterCard;
    if (twitterMisc != null) {
      data['twitter_misc'] = twitterMisc!.toJson();
    }
    if (schema != null) {
      data['schema'] = schema!.toJson();
    }
    return data;
  }
}

class Robots {
  String? index;
  String? follow;
  String? maxSnippet;
  String? maxImagePreview;
  String? maxVideoPreview;

  Robots(
      {index,
        follow,
        maxSnippet,
        maxImagePreview,
        maxVideoPreview});

  Robots.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    follow = json['follow'];
    maxSnippet = json['max-snippet'];
    maxImagePreview = json['max-image-preview'];
    maxVideoPreview = json['max-video-preview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    data['follow'] = follow;
    data['max-snippet'] = maxSnippet;
    data['max-image-preview'] = maxImagePreview;
    data['max-video-preview'] = maxVideoPreview;
    return data;
  }
}

class OgImage {
  int? width;
  int? height;
  String? url;
  String? type;

  OgImage({width, height, url, type});

  OgImage.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    url = json['url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['width'] = width;
    data['height'] = height;
    data['url'] = url;
    data['type'] = type;
    return data;
  }
}

class TwitterMisc {
  String? writtenBy;
  String? estReadingTime;

  TwitterMisc({writtenBy, estReadingTime});

  TwitterMisc.fromJson(Map<String, dynamic> json) {
    writtenBy = json['Written by'];
    estReadingTime = json['Est. reading time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Written by'] = writtenBy;
    data['Est. reading time'] = estReadingTime;
    return data;
  }
}

class Schema {
  String? context;
  List<Graph>? graph;

  Schema({context, graph});

  Schema.fromJson(Map<String, dynamic> json) {
    context = json['@context'];
    if (json['@graph'] != null) {
      graph = <Graph>[];
      json['@graph'].forEach((v) {
        graph!.add(Graph.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@context'] = context;
    if (graph != null) {
      data['@graph'] = graph!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Graph {
  String? type;
  String? id;
  String? url;
  String? name;
  String? description;
  List<PotentialAction>? potentialAction;
  String? inLanguage;
  String? contentUrl;
  int? width;
  int? height;
  IsPartOf? isPartOf;
  IsPartOf? primaryImageOfPage;
  String? datePublished;
  String? dateModified;
  IsPartOf? author;
  IsPartOf? breadcrumb;
  List<ItemListElement>? itemListElement;
  NewsImage? image;

  Graph(
      {type,
        id,
        url,
        name,
        description,
        potentialAction,
        inLanguage,
        contentUrl,
        width,
        height,
        isPartOf,
        primaryImageOfPage,
        datePublished,
        dateModified,
        author,
        breadcrumb,
        itemListElement,
        image});

  Graph.fromJson(Map<String, dynamic> json) {
    type = json['@type'];
    id = json['@id'];
    url = json['url'];
    name = json['name'];
    description = json['description'];
    if (json['potentialAction'] != null) {
      potentialAction = <PotentialAction>[];
      json['potentialAction'].forEach((v) {
        potentialAction!.add(PotentialAction.fromJson(v));
      });
    }
    inLanguage = json['inLanguage'];
    contentUrl = json['contentUrl'];
    width = json['width'];
    height = json['height'];
    isPartOf = json['isPartOf'] != null
        ? IsPartOf.fromJson(json['isPartOf'])
        : null;
    primaryImageOfPage = json['primaryImageOfPage'] != null
        ? IsPartOf.fromJson(json['primaryImageOfPage'])
        : null;
    datePublished = json['datePublished'];
    dateModified = json['dateModified'];
    author =
    json['author'] != null ? IsPartOf.fromJson(json['author']) : null;
    breadcrumb = json['breadcrumb'] != null
        ? IsPartOf.fromJson(json['breadcrumb'])
        : null;
    if (json['itemListElement'] != null) {
      itemListElement = <ItemListElement>[];
      json['itemListElement'].forEach((v) {
        itemListElement!.add(ItemListElement.fromJson(v));
      });
    }
    image = json['image'] != null ? NewsImage.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@type'] = type;
    data['@id'] = id;
    data['url'] = url;
    data['name'] = name;
    data['description'] = description;
    if (potentialAction != null) {
      data['potentialAction'] =
          potentialAction!.map((v) => v.toJson()).toList();
    }
    data['inLanguage'] = inLanguage;
    data['contentUrl'] = contentUrl;
    data['width'] = width;
    data['height'] = height;
    if (isPartOf != null) {
      data['isPartOf'] = isPartOf!.toJson();
    }
    if (primaryImageOfPage != null) {
      data['primaryImageOfPage'] = primaryImageOfPage!.toJson();
    }
    data['datePublished'] = datePublished;
    data['dateModified'] = dateModified;
    if (author != null) {
      data['author'] = author!.toJson();
    }
    if (breadcrumb != null) {
      data['breadcrumb'] = breadcrumb!.toJson();
    }
    if (itemListElement != null) {
      data['itemListElement'] =
          itemListElement!.map((v) => v.toJson()).toList();
    }
    if (image != null) {
      data['image'] = image!.toJson();
    }
    return data;
  }
}

class PotentialAction {
  String? type;
  Target? target;
  String? queryInput;

  PotentialAction({type, target, queryInput});

  PotentialAction.fromJson(Map<String, dynamic> json) {
    type = json['@type'];
    target =
    json['target'] != null ? Target.fromJson(json['target']) : null;
    queryInput = json['query-input'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@type'] = type;
    if (target != null) {
      data['target'] = target!.toJson();
    }
    data['query-input'] = queryInput;
    return data;
  }
}

class Target {
  String? type;
  String? urlTemplate;

  Target({type, urlTemplate});

  Target.fromJson(Map<String, dynamic> json) {
    type = json['@type'];
    urlTemplate = json['urlTemplate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@type'] = type;
    data['urlTemplate'] = urlTemplate;
    return data;
  }
}

class IsPartOf {
  String? id;

  IsPartOf({id});

  IsPartOf.fromJson(Map<String, dynamic> json) {
    id = json['@id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@id'] = id;
    return data;
  }
}

class ItemListElement {
  String? type;
  int? position;
  String? name;
  String? item;

  ItemListElement({type, position, name, item});

  ItemListElement.fromJson(Map<String, dynamic> json) {
    type = json['@type'];
    position = json['position'];
    name = json['name'];
    item = json['item'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@type'] = type;
    data['position'] = position;
    data['name'] = name;
    data['item'] = item;
    return data;
  }
}

class NewsImage {
  String? type;
  String? id;
  String? inLanguage;
  String? url;
  String? contentUrl;
  String? caption;

  NewsImage(
      {type,
        id,
        inLanguage,
        url,
        contentUrl,
        caption});

  NewsImage.fromJson(Map<String, dynamic> json) {
    type = json['@type'];
    id = json['@id'];
    inLanguage = json['inLanguage'];
    url = json['url'];
    contentUrl = json['contentUrl'];
    caption = json['caption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@type'] = type;
    data['@id'] = id;
    data['inLanguage'] = inLanguage;
    data['url'] = url;
    data['contentUrl'] = contentUrl;
    data['caption'] = caption;
    return data;
  }
}

class Links {
  List<Self>? self;
  List<Author>? author;
  List<VersionHistory>? versionHistory;
  List<PredecessorVersion>? predecessorVersion;
  List<WpTerm>? wpTerm;
  List<Curies>? curies;

  Links(
      {self,

        author,
        versionHistory,
        predecessorVersion,
        wpTerm,
        curies});

  Links.fromJson(Map<String, dynamic> json) {
    if (json['self'] != null) {
      self = <Self>[];
      json['self'].forEach((v) {
        self!.add(Self.fromJson(v));
      });
    }
    if (json['author'] != null) {
      author = <Author>[];
      json['author'].forEach((v) {
        author!.add(Author.fromJson(v));
      });
    }

    if (json['version-history'] != null) {
      versionHistory = <VersionHistory>[];
      json['version-history'].forEach((v) {
        versionHistory!.add(VersionHistory.fromJson(v));
      });
    }
    if (json['predecessor-version'] != null) {
      predecessorVersion = <PredecessorVersion>[];
      json['predecessor-version'].forEach((v) {
        predecessorVersion!.add(PredecessorVersion.fromJson(v));
      });
    }

    if (json['wp:term'] != null) {
      wpTerm = <WpTerm>[];
      json['wp:term'].forEach((v) {
        wpTerm!.add(WpTerm.fromJson(v));
      });
    }
    if (json['curies'] != null) {
      curies = <Curies>[];
      json['curies'].forEach((v) {
        curies!.add(Curies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (self != null) {
      data['self'] = self!.map((v) => v.toJson()).toList();
    }

    if (author != null) {
      data['author'] = author!.map((v) => v.toJson()).toList();
    }

    if (versionHistory != null) {
      data['version-history'] =
          versionHistory!.map((v) => v.toJson()).toList();
    }
    if (predecessorVersion != null) {
      data['predecessor-version'] =
          predecessorVersion!.map((v) => v.toJson()).toList();
    }

    if (wpTerm != null) {
      data['wp:term'] = wpTerm!.map((v) => v.toJson()).toList();
    }
    if (curies != null) {
      data['curies'] = curies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Self {
  String? href;

  Self({href});

  Self.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['href'] = href;
    return data;
  }
}

class Author {
  bool? embeddable;
  String? href;

  Author({embeddable, href});

  Author.fromJson(Map<String, dynamic> json) {
    embeddable = json['embeddable'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['embeddable'] = embeddable;
    data['href'] = href;
    return data;
  }
}

class VersionHistory {
  int? count;
  String? href;

  VersionHistory({count, href});

  VersionHistory.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['href'] = href;
    return data;
  }
}

class PredecessorVersion {
  int? id;
  String? href;

  PredecessorVersion({id, href});

  PredecessorVersion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['href'] = href;
    return data;
  }
}

class WpTerm {
  String? taxonomy;
  bool? embeddable;
  String? href;

  WpTerm({taxonomy, embeddable, href});

  WpTerm.fromJson(Map<String, dynamic> json) {
    taxonomy = json['taxonomy'];
    embeddable = json['embeddable'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['taxonomy'] = taxonomy;
    data['embeddable'] = embeddable;
    data['href'] = href;
    return data;
  }
}

class Curies {
  String? name;
  String? href;
  bool? templated;

  Curies({name, href, templated});

  Curies.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    href = json['href'];
    templated = json['templated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['href'] = href;
    data['templated'] = templated;
    return data;
  }
}
