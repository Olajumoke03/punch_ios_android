class NewsByCategoryModel {
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
  Meta? meta;
  List<int>? categories;
  List<int>? tags;
  String? yoastHead;
  YoastHeadJson? yoastHeadJson;
  String? jetpackFeaturedMediaUrl;
  Links? lLinks;

  NewsByCategoryModel(
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
        yoastHeadJson,
        jetpackFeaturedMediaUrl,
        lLinks});

  NewsByCategoryModel.fromJson(Map<String, dynamic> json) {
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
    content =
    json['content'] != null ? Content.fromJson(json['content']) : null;
    excerpt =
    json['excerpt'] != null ? Content.fromJson(json['excerpt']) : null;
    author = json['author'];
    featuredMedia = json['featured_media'];
    commentStatus = json['comment_status'];
    pingStatus = json['ping_status'];
    sticky = json['sticky'];
    template = json['template'];
    format = json['format'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    categories = json['categories'].cast<int>();
    tags = json['tags'].cast<int>();
    yoastHead = json['yoast_head'];
    yoastHeadJson = json['yoast_head_json'] != null
        ? YoastHeadJson.fromJson(json['yoast_head_json'])
        : null;
    jetpackFeaturedMediaUrl = json['jetpack_featured_media_url'];
    lLinks = json['_links'] != null ? Links.fromJson(json['_links']) : null;
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
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    data['categories'] = categories;
    data['tags'] = tags;
    data['yoast_head'] = yoastHead;
    if (yoastHeadJson != null) {
      data['yoast_head_json'] = yoastHeadJson!.toJson();
    }
    data['jetpack_featured_media_url'] = jetpackFeaturedMediaUrl;
    if (lLinks != null) {
      data['_links'] = lLinks!.toJson();
    }
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

class Meta {
  String? cscoSingularSidebar;
  String? cscoPageHeaderType;
  String? cscoAppearanceGrid;
  String? cscoPageLoadNextpost;
  String? cscoPostVideoLocationHash;
  String? cscoPostVideoUrl;
  int? cscoPostVideoBgStartTime;
  int? cscoPostVideoBgEndTime;

  Meta(
      {cscoSingularSidebar,
        cscoPageHeaderType,
        cscoAppearanceGrid,
        cscoPageLoadNextpost,
        cscoPostVideoLocationHash,
        cscoPostVideoUrl,
        cscoPostVideoBgStartTime,
        cscoPostVideoBgEndTime});

  Meta.fromJson(Map<String, dynamic> json) {
    cscoSingularSidebar = json['csco_singular_sidebar'];
    cscoPageHeaderType = json['csco_page_header_type'];
    cscoAppearanceGrid = json['csco_appearance_grid'];
    cscoPageLoadNextpost = json['csco_page_load_nextpost'];
    cscoPostVideoLocationHash = json['csco_post_video_location_hash'];
    cscoPostVideoUrl = json['csco_post_video_url'];
    cscoPostVideoBgStartTime = json['csco_post_video_bg_start_time'];
    cscoPostVideoBgEndTime = json['csco_post_video_bg_end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['csco_singular_sidebar'] = cscoSingularSidebar;
    data['csco_page_header_type'] = cscoPageHeaderType;
    data['csco_appearance_grid'] = cscoAppearanceGrid;
    data['csco_page_load_nextpost'] = cscoPageLoadNextpost;
    data['csco_post_video_location_hash'] = cscoPostVideoLocationHash;
    data['csco_post_video_url'] = cscoPostVideoUrl;
    data['csco_post_video_bg_start_time'] = cscoPostVideoBgStartTime;
    data['csco_post_video_bg_end_time'] = cscoPostVideoBgEndTime;
    return data;
  }
}

class YoastHeadJson {
  String? title;
  Robots? robots;
  String? canonical;
  String? ogLocale;
  String? ogType;
  String? ogTitle;
  String? ogDescription;
  String? ogUrl;
  String? ogSiteName;
  String? articlePublishedTime;
  List<OgImage>? ogImage;
  String? twitterCard;
  TwitterMisc? twitterMisc;
  Schema? schema;

  YoastHeadJson(
      {title,
        robots,
        canonical,
        ogLocale,
        ogType,
        ogTitle,
        ogDescription,
        ogUrl,
        ogSiteName,
        articlePublishedTime,
        ogImage,
        twitterCard,
        twitterMisc,
        schema});

  YoastHeadJson.fromJson(Map<String, dynamic> json) {
    title = json['title'];
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
  String? name;
  String? url;
  List<void>? sameAs;
  Logo? logo;
  Image? image;
  String? description;
  Publisher? publisher;
  List<PotentialAction>? potentialAction;
  String? inLanguage;
  String? contentUrl;
  int? width;
  int? height;
  Publisher? isPartOf;
  Publisher? primaryImageOfPage;
  String? datePublished;
  String? dateModified;
  Publisher? breadcrumb;
  List<ItemListElement>? itemListElement;
  Publisher? author;
  String? headline;
  Publisher? mainEntityOfPage;
  int? wordCount;
  int? commentCount;
  String? thumbnailUrl;
  List<String>? keywords;
  List<String>? articleSection;

  Graph(
      {type,
        id,
        name,
        url,
        sameAs,
        logo,
        image,
        description,
        publisher,
        potentialAction,
        inLanguage,
        contentUrl,
        width,
        height,
        isPartOf,
        primaryImageOfPage,
        datePublished,
        dateModified,
        breadcrumb,
        itemListElement,
        author,
        headline,
        mainEntityOfPage,
        wordCount,
        commentCount,
        thumbnailUrl,
        keywords,
        articleSection});

  Graph.fromJson(Map<String, dynamic> json) {
    type = json['@type'];
    id = json['@id'];
    name = json['name'];
    url = json['url'];
    logo = json['logo'] != null ? Logo.fromJson(json['logo']) : null;
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    description = json['description'];
    publisher = json['publisher'] != null
        ? Publisher.fromJson(json['publisher'])
        : null;
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
        ? Publisher.fromJson(json['isPartOf'])
        : null;
    primaryImageOfPage = json['primaryImageOfPage'] != null
        ? Publisher.fromJson(json['primaryImageOfPage'])
        : null;
    datePublished = json['datePublished'];
    dateModified = json['dateModified'];
    breadcrumb = json['breadcrumb'] != null
        ? Publisher.fromJson(json['breadcrumb'])
        : null;
    if (json['itemListElement'] != null) {
      itemListElement = <ItemListElement>[];
      json['itemListElement'].forEach((v) {
        itemListElement!.add(ItemListElement.fromJson(v));
      });
    }
    author =
    json['author'] != null ? Publisher.fromJson(json['author']) : null;
    headline = json['headline'];
    mainEntityOfPage = json['mainEntityOfPage'] != null
        ? Publisher.fromJson(json['mainEntityOfPage'])
        : null;
    wordCount = json['wordCount'];
    commentCount = json['commentCount'];
    thumbnailUrl = json['thumbnailUrl'];
    keywords = json['keywords'].cast<String>();
    articleSection = json['articleSection'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@type'] = type;
    data['@id'] = id;
    data['name'] = name;
    data['url'] = url;

    if (logo != null) {
      data['logo'] = logo!.toJson();
    }
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['description'] = description;
    if (publisher != null) {
      data['publisher'] = publisher!.toJson();
    }
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
    if (breadcrumb != null) {
      data['breadcrumb'] = breadcrumb!.toJson();
    }
    if (itemListElement != null) {
      data['itemListElement'] =
          itemListElement!.map((v) => v.toJson()).toList();
    }
    if (author != null) {
      data['author'] = author!.toJson();
    }
    data['headline'] = headline;
    if (mainEntityOfPage != null) {
      data['mainEntityOfPage'] = mainEntityOfPage!.toJson();
    }
    data['wordCount'] = wordCount;
    data['commentCount'] = commentCount;
    data['thumbnailUrl'] = thumbnailUrl;
    data['keywords'] = keywords;
    data['articleSection'] = articleSection;
    return data;
  }
}

class Logo {
  String? type;
  String? id;
  String? inLanguage;
  String? url;
  String? contentUrl;
  int? width;
  int? height;
  String? caption;

  Logo(
      {type,
        id,
        inLanguage,
        url,
        contentUrl,
        width,
        height,
        caption});

  Logo.fromJson(Map<String, dynamic> json) {
    type = json['@type'];
    id = json['@id'];
    inLanguage = json['inLanguage'];
    url = json['url'];
    contentUrl = json['contentUrl'];
    width = json['width'];
    height = json['height'];
    caption = json['caption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@type'] = type;
    data['@id'] = id;
    data['inLanguage'] = inLanguage;
    data['url'] = url;
    data['contentUrl'] = contentUrl;
    data['width'] = width;
    data['height'] = height;
    data['caption'] = caption;
    return data;
  }
}

class Image {
  String? id;
  String? type;
  String? inLanguage;
  String? url;
  String? contentUrl;
  String? caption;

  Image(
      {id,
        type,
        inLanguage,
        url,
        contentUrl,
        caption});

  Image.fromJson(Map<String, dynamic> json) {
    id = json['@id'];
    type = json['@type'];
    inLanguage = json['inLanguage'];
    url = json['url'];
    contentUrl = json['contentUrl'];
    caption = json['caption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@id'] = id;
    data['@type'] = type;
    data['inLanguage'] = inLanguage;
    data['url'] = url;
    data['contentUrl'] = contentUrl;
    data['caption'] = caption;
    return data;
  }
}

class Publisher {
  String? id;

  Publisher({id});

  Publisher.fromJson(Map<String, dynamic> json) {
    id = json['@id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@id'] = id;
    return data;
  }
}

class PotentialAction {
  String? type;
  Target? target;
  String? queryInput;
  String? name;

  PotentialAction({type, target, queryInput, name});

  PotentialAction.fromJson(Map<String, dynamic> json) {
    type = json['@type'];
    target =
    json['target'] != null ? Target.fromJson(json['target']) : null;
    queryInput = json['query-input'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@type'] = type;
    if (target != null) {
      data['target'] = target!.toJson();
    }
    data['query-input'] = queryInput;
    data['name'] = name;
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
