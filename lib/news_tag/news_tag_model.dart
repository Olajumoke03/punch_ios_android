class NewsTagModel {
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
  // List<String>? categoriesString;
  List<int>? categories;
  List<String>? articleSplit;

  List<int>? tags;
  String? jetpackFeaturedMediaUrl;
  Links? lLinks;
  String? xCategories;
  String? xAuthor;

  NewsTagModel(
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
        // categoriesString,
        jetpackFeaturedMediaUrl,
        xCategories,
        xAuthor,
        articleSplit,
        lLinks});

  NewsTagModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    dateGmt = json['date_gmt'];
    guid = json['guid'] != null ?  Guid.fromJson(json['guid']) : null;
    modified = json['modified'];
    modifiedGmt = json['modified_gmt'];
    slug = json['slug'];
    status = json['status'];
    type = json['type'];
    link = json['link'];
    title = json['title'] != null ?  Guid.fromJson(json['title']) : null;
    content =
    json['content'] != null ?  Content.fromJson(json['content']) : null;
    excerpt =
    json['excerpt'] != null ?  Content.fromJson(json['excerpt']) : null;
    author = json['author'];
    featuredMedia = json['featured_media'];
    commentStatus = json['comment_status'];
    pingStatus = json['ping_status'];
    sticky = json['sticky'];
    template = json['template'];
    format = json['format'];
    // articleSplit = json['content']['rendered'].replaceAll('<p','@#%!<p').split('@#%!');
    meta = json['meta'] != null ?  Meta.fromJson(json['meta']) : null;
    categories = json['categories'].cast<int>();
    // categoriesString = json['x_categories'].split(',');
    xCategories = json['x_categories'];
    xAuthor = json['x_author'];

    tags = json['tags'].cast<int>();
    jetpackFeaturedMediaUrl = json['jetpack_featured_media_url'];
    lLinks = json['_links'] != null ?  Links.fromJson(json['_links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
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
    data['x_author'] = xCategories;
    data['x_categories'] = xAuthor;

    data['tags'] = tags;
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
    final Map<String, dynamic> data =  <String, dynamic>{};
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
    final Map<String, dynamic> data =  <String, dynamic>{};
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
  // List<Null>? cscoPostVideoLocation;
  String? cscoPostVideoLocationHash;
  String? cscoPostVideoUrl;
  int? cscoPostVideoBgStartTime;
  int? cscoPostVideoBgEndTime;

  Meta(
      {cscoSingularSidebar,
        cscoPageHeaderType,
        cscoAppearanceGrid,
        cscoPageLoadNextpost,
        // cscoPostVideoLocation,
        cscoPostVideoLocationHash,
        cscoPostVideoUrl,
        cscoPostVideoBgStartTime,
        cscoPostVideoBgEndTime});

  Meta.fromJson(Map<String, dynamic> json) {
    cscoSingularSidebar = json['csco_singular_sidebar'];
    cscoPageHeaderType = json['csco_page_header_type'];
    cscoAppearanceGrid = json['csco_appearance_grid'];
    cscoPageLoadNextpost = json['csco_page_load_nextpost'];
    // if (json['csco_post_video_location'] != null) {
    //   cscoPostVideoLocation = <Null>[];
    //   json['csco_post_video_location'].forEach((v) {
    //     cscoPostVideoLocation!.add(Null.fromJson(v));
    //   });
    // }
    cscoPostVideoLocationHash = json['csco_post_video_location_hash'];
    cscoPostVideoUrl = json['csco_post_video_url'];
    cscoPostVideoBgStartTime = json['csco_post_video_bg_start_time'];
    cscoPostVideoBgEndTime = json['csco_post_video_bg_end_time'];
  }

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data =  <String, dynamic>{};
    data['csco_singular_sidebar'] = cscoSingularSidebar;
    data['csco_page_header_type'] = cscoPageHeaderType;
    data['csco_appearance_grid'] = cscoAppearanceGrid;
    data['csco_page_load_nextpost'] = cscoPageLoadNextpost;
    // if (cscoPostVideoLocation != null) {
    //   data['csco_post_video_location'] = cscoPostVideoLocation!.map((v) => v.toJson()).toList();
    // }
    data['csco_post_video_location_hash'] = cscoPostVideoLocationHash;
    data['csco_post_video_url'] = cscoPostVideoUrl;
    data['csco_post_video_bg_start_time'] = cscoPostVideoBgStartTime;
    data['csco_post_video_bg_end_time'] = cscoPostVideoBgEndTime;
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
        self!.add( Self.fromJson(v));
      });
    }

    if (json['author'] != null) {
      author = <Author>[];
      json['author'].forEach((v) {
        author!.add( Author.fromJson(v));
      });
    }

    if (json['version-history'] != null) {
      versionHistory = <VersionHistory>[];
      json['version-history'].forEach((v) {
        versionHistory!.add( VersionHistory.fromJson(v));
      });
    }
    if (json['predecessor-version'] != null) {
      predecessorVersion = <PredecessorVersion>[];
      json['predecessor-version'].forEach((v) {
        predecessorVersion!.add( PredecessorVersion.fromJson(v));
      });
    }

    if (json['wp:term'] != null) {
      wpTerm = <WpTerm>[];
      json['wp:term'].forEach((v) {
        wpTerm!.add( WpTerm.fromJson(v));
      });
    }
    if (json['curies'] != null) {
      curies = <Curies>[];
      json['curies'].forEach((v) {
        curies!.add( Curies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
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
    final Map<String, dynamic> data =  <String, dynamic>{};
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
    final Map<String, dynamic> data =  <String, dynamic>{};
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
    final Map<String, dynamic> data =  <String, dynamic>{};
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
    final Map<String, dynamic> data =  <String, dynamic>{};
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
    final Map<String, dynamic> data =  <String, dynamic>{};
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
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['name'] = name;
    data['href'] = href;
    data['templated'] = templated;
    return data;
  }

}



//
// class HomeNewsModel {
//   int? id;
//   String? date;
//   String? dateGmt;
//   Guid? guid;
//   String? modified;
//   String? modifiedGmt;
//   String? slug;
//   String? status;
//   String? type;
//   String? link;
//   Guid? title;
//   Guid? content;
//   Excerpt? excerpt;
//   int? author;
//   int? featuredMedia;
//   String? commentStatus;
//   String? pingStatus;
//   bool? sticky;
//   String? template;
//   String? format;
//   Meta? meta;
//   List<int>? categories;
//   List<int>? tags;
//   String? yoastHead;
//   YoastHeadJson? yoastHeadJson;
//   String? jetpackFeaturedMediaUrl;
//   String? xCategories;
//   String? xTags;
//   String? xFeaturedMedia;
//   String? xFeaturedMediaMedium;
//   String? xFeaturedMediaLarge;
//   String? xFeaturedMediaOriginal;
//   String? xDate;
//   String? xAuthor;
//   String? xGravatar;
//   XMetadata? xMetadata;
//   Links? lLinks;
//
//   HomeNewsModel(
//       {this.id,
//         this.date,
//         this.dateGmt,
//         this.guid,
//         this.modified,
//         this.modifiedGmt,
//         this.slug,
//         this.status,
//         this.type,
//         this.link,
//         this.title,
//         this.content,
//         this.excerpt,
//         this.author,
//         this.featuredMedia,
//         this.commentStatus,
//         this.pingStatus,
//         this.sticky,
//         this.template,
//         this.format,
//         this.meta,
//         this.categories,
//         this.tags,
//         this.yoastHead,
//         this.yoastHeadJson,
//         this.jetpackFeaturedMediaUrl,
//         this.xCategories,
//         this.xTags,
//         this.xFeaturedMedia,
//         this.xFeaturedMediaMedium,
//         this.xFeaturedMediaLarge,
//         this.xFeaturedMediaOriginal,
//         this.xDate,
//         this.xAuthor,
//         this.xGravatar,
//         this.xMetadata,
//         this.lLinks});
//
//   HomeNewsModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     date = json['date'];
//     dateGmt = json['date_gmt'];
//     guid = json['guid'] != null ? new Guid.fromJson(json['guid']) : null;
//     modified = json['modified'];
//     modifiedGmt = json['modified_gmt'];
//     slug = json['slug'];
//     status = json['status'];
//     type = json['type'];
//     link = json['link'];
//     title = json['title'] != null ? new Guid.fromJson(json['title']) : null;
//     content =
//     json['content'] != null ? new Guid.fromJson(json['content']) : null;
//     excerpt =
//     json['excerpt'] != null ? new Excerpt.fromJson(json['excerpt']) : null;
//     author = json['author'];
//     featuredMedia = json['featured_media'];
//     commentStatus = json['comment_status'];
//     pingStatus = json['ping_status'];
//     sticky = json['sticky'];
//     template = json['template'];
//     format = json['format'];
//     meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
//     categories = json['categories'].cast<int>();
//     tags = json['tags'].cast<int>();
//     yoastHead = json['yoast_head'];
//     yoastHeadJson = json['yoast_head_json'] != null
//         ? new YoastHeadJson.fromJson(json['yoast_head_json'])
//         : null;
//     jetpackFeaturedMediaUrl = json['jetpack_featured_media_url'];
//     xTags = json['x_tags'];
//     xFeaturedMedia = json['x_featured_media'];
//     xFeaturedMediaMedium = json['x_featured_media_medium'];
//     xFeaturedMediaLarge = json['x_featured_media_large'];
//     xFeaturedMediaOriginal = json['x_featured_media_original'];
//     xDate = json['x_date'];
//     xAuthor = json['x_author'];
//     xGravatar = json['x_gravatar'];
//     xMetadata = json['x_metadata'] != null
//         ? new XMetadata.fromJson(json['x_metadata'])
//         : null;
//     lLinks = json['_links'] != null ? new Links.fromJson(json['_links']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['date'] = this.date;
//     data['date_gmt'] = this.dateGmt;
//     if (this.guid != null) {
//       data['guid'] = this.guid!.toJson();
//     }
//     data['modified'] = this.modified;
//     data['modified_gmt'] = this.modifiedGmt;
//     data['slug'] = this.slug;
//     data['status'] = this.status;
//     data['type'] = this.type;
//     data['link'] = this.link;
//     if (this.title != null) {
//       data['title'] = this.title!.toJson();
//     }
//     if (this.content != null) {
//       data['content'] = this.content!.toJson();
//     }
//     if (this.excerpt != null) {
//       data['excerpt'] = this.excerpt!.toJson();
//     }
//     data['author'] = this.author;
//     data['featured_media'] = this.featuredMedia;
//     data['comment_status'] = this.commentStatus;
//     data['ping_status'] = this.pingStatus;
//     data['sticky'] = this.sticky;
//     data['template'] = this.template;
//     data['format'] = this.format;
//     if (this.meta != null) {
//       data['meta'] = this.meta!.toJson();
//     }
//     data['categories'] = this.categories;
//     data['tags'] = this.tags;
//     data['yoast_head'] = this.yoastHead;
//     if (this.yoastHeadJson != null) {
//       data['yoast_head_json'] = this.yoastHeadJson!.toJson();
//     }
//     data['jetpack_featured_media_url'] = this.jetpackFeaturedMediaUrl;
//     data['x_categories'] = this.xCategories;
//     data['x_tags'] = this.xTags;
//     data['x_featured_media'] = this.xFeaturedMedia;
//     data['x_featured_media_medium'] = this.xFeaturedMediaMedium;
//     data['x_featured_media_large'] = this.xFeaturedMediaLarge;
//     data['x_featured_media_original'] = this.xFeaturedMediaOriginal;
//     data['x_date'] = this.xDate;
//     data['x_author'] = this.xAuthor;
//     data['x_gravatar'] = this.xGravatar;
//     if (this.xMetadata != null) {
//       data['x_metadata'] = this.xMetadata!.toJson();
//     }
//     if (this.lLinks != null) {
//       data['_links'] = this.lLinks!.toJson();
//     }
//     return data;
//   }
// }
//
// class Guid {
//   String? rendered;
//
//   Guid({this.rendered});
//
//   Guid.fromJson(Map<String, dynamic> json) {
//     rendered = json['rendered'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['rendered'] = this.rendered;
//     return data;
//   }
// }
//
// class Excerpt {
//   String? rendered;
//   bool? protected;
//
//   Excerpt({this.rendered, this.protected});
//
//   Excerpt.fromJson(Map<String, dynamic> json) {
//     rendered = json['rendered'];
//     protected = json['protected'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['rendered'] = this.rendered;
//     data['protected'] = this.protected;
//     return data;
//   }
// }
//
// class Meta {
//   String? cscoSingularSidebar;
//   String? cscoPageHeaderType;
//   String? cscoAppearanceGrid;
//   String? cscoPageLoadNextpost;
//   List<Null>? cscoPostVideoLocation;
//   String? cscoPostVideoLocationHash;
//   String? cscoPostVideoUrl;
//   int? cscoPostVideoBgStartTime;
//   int? cscoPostVideoBgEndTime;
//
//   Meta(
//       {this.cscoSingularSidebar,
//         this.cscoPageHeaderType,
//         this.cscoAppearanceGrid,
//         this.cscoPageLoadNextpost,
//         this.cscoPostVideoLocation,
//         this.cscoPostVideoLocationHash,
//         this.cscoPostVideoUrl,
//         this.cscoPostVideoBgStartTime,
//         this.cscoPostVideoBgEndTime});
//
//   Meta.fromJson(Map<String, dynamic> json) {
//     cscoSingularSidebar = json['csco_singular_sidebar'];
//     cscoPageHeaderType = json['csco_page_header_type'];
//     cscoAppearanceGrid = json['csco_appearance_grid'];
//     cscoPageLoadNextpost = json['csco_page_load_nextpost'];
//
//     cscoPostVideoLocationHash = json['csco_post_video_location_hash'];
//     cscoPostVideoUrl = json['csco_post_video_url'];
//     cscoPostVideoBgStartTime = json['csco_post_video_bg_start_time'];
//     cscoPostVideoBgEndTime = json['csco_post_video_bg_end_time'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['csco_singular_sidebar'] = this.cscoSingularSidebar;
//     data['csco_page_header_type'] = this.cscoPageHeaderType;
//     data['csco_appearance_grid'] = this.cscoAppearanceGrid;
//     data['csco_page_load_nextpost'] = this.cscoPageLoadNextpost;
//
//     data['csco_post_video_location_hash'] = this.cscoPostVideoLocationHash;
//     data['csco_post_video_url'] = this.cscoPostVideoUrl;
//     data['csco_post_video_bg_start_time'] = this.cscoPostVideoBgStartTime;
//     data['csco_post_video_bg_end_time'] = this.cscoPostVideoBgEndTime;
//     return data;
//   }
// }
//
// class YoastHeadJson {
//   String? title;
//   Robots? robots;
//   String? canonical;
//   String? ogLocale;
//   String? ogType;
//   String? ogTitle;
//   String? ogDescription;
//   String? ogUrl;
//   String? ogSiteName;
//   String? articlePublishedTime;
//   List<OgImage>? ogImage;
//   String? twitterCard;
//   TwitterMisc? twitterMisc;
//   Schema? schema;
//
//   YoastHeadJson(
//       {this.title,
//         this.robots,
//         this.canonical,
//         this.ogLocale,
//         this.ogType,
//         this.ogTitle,
//         this.ogDescription,
//         this.ogUrl,
//         this.ogSiteName,
//         this.articlePublishedTime,
//         this.ogImage,
//         this.twitterCard,
//         this.twitterMisc,
//         this.schema});
//
//   YoastHeadJson.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     robots =
//     json['robots'] != null ? new Robots.fromJson(json['robots']) : null;
//     canonical = json['canonical'];
//     ogLocale = json['og_locale'];
//     ogType = json['og_type'];
//     ogTitle = json['og_title'];
//     ogDescription = json['og_description'];
//     ogUrl = json['og_url'];
//     ogSiteName = json['og_site_name'];
//     articlePublishedTime = json['article_published_time'];
//     if (json['og_image'] != null) {
//       ogImage = <OgImage>[];
//       json['og_image'].forEach((v) {
//         ogImage!.add(new OgImage.fromJson(v));
//       });
//     }
//     twitterCard = json['twitter_card'];
//     twitterMisc = json['twitter_misc'] != null
//         ? new TwitterMisc.fromJson(json['twitter_misc'])
//         : null;
//     schema =
//     json['schema'] != null ? new Schema.fromJson(json['schema']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['title'] = this.title;
//     if (this.robots != null) {
//       data['robots'] = this.robots!.toJson();
//     }
//     data['canonical'] = this.canonical;
//     data['og_locale'] = this.ogLocale;
//     data['og_type'] = this.ogType;
//     data['og_title'] = this.ogTitle;
//     data['og_description'] = this.ogDescription;
//     data['og_url'] = this.ogUrl;
//     data['og_site_name'] = this.ogSiteName;
//     data['article_published_time'] = this.articlePublishedTime;
//     if (this.ogImage != null) {
//       data['og_image'] = this.ogImage!.map((v) => v.toJson()).toList();
//     }
//     data['twitter_card'] = this.twitterCard;
//     if (this.twitterMisc != null) {
//       data['twitter_misc'] = this.twitterMisc!.toJson();
//     }
//     if (this.schema != null) {
//       data['schema'] = this.schema!.toJson();
//     }
//     return data;
//   }
// }
//
// class Robots {
//   String? index;
//   String? follow;
//   String? maxSnippet;
//   String? maxImagePreview;
//   String? maxVideoPreview;
//
//   Robots(
//       {this.index,
//         this.follow,
//         this.maxSnippet,
//         this.maxImagePreview,
//         this.maxVideoPreview});
//
//   Robots.fromJson(Map<String, dynamic> json) {
//     index = json['index'];
//     follow = json['follow'];
//     maxSnippet = json['max-snippet'];
//     maxImagePreview = json['max-image-preview'];
//     maxVideoPreview = json['max-video-preview'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['index'] = this.index;
//     data['follow'] = this.follow;
//     data['max-snippet'] = this.maxSnippet;
//     data['max-image-preview'] = this.maxImagePreview;
//     data['max-video-preview'] = this.maxVideoPreview;
//     return data;
//   }
// }
//
// class OgImage {
//   int? width;
//   int? height;
//   String? url;
//   String? type;
//
//   OgImage({this.width, this.height, this.url, this.type});
//
//   OgImage.fromJson(Map<String, dynamic> json) {
//     width = json['width'];
//     height = json['height'];
//     url = json['url'];
//     type = json['type'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['width'] = this.width;
//     data['height'] = this.height;
//     data['url'] = this.url;
//     data['type'] = this.type;
//     return data;
//   }
// }
//
// class TwitterMisc {
//   String? writtenBy;
//   String? estReadingTime;
//
//   TwitterMisc({this.writtenBy, this.estReadingTime});
//
//   TwitterMisc.fromJson(Map<String, dynamic> json) {
//     writtenBy = json['Written by'];
//     estReadingTime = json['Est. reading time'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Written by'] = this.writtenBy;
//     data['Est. reading time'] = this.estReadingTime;
//     return data;
//   }
// }
//
// class Schema {
//   String? context;
//   List<Graph>? graph;
//
//   Schema({this.context, this.graph});
//
//   Schema.fromJson(Map<String, dynamic> json) {
//     context = json['@context'];
//     if (json['@graph'] != null) {
//       graph = <Graph>[];
//       json['@graph'].forEach((v) {
//         graph!.add(new Graph.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['@context'] = this.context;
//     if (this.graph != null) {
//       data['@graph'] = this.graph!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Graph {
//   String? type;
//   String? id;
//   String? name;
//   String? url;
//   List<Null>? sameAs;
//   Logo? logo;
//   Image? image;
//   String? description;
//   Publisher? publisher;
//   List<PotentialAction>? potentialAction;
//   String? inLanguage;
//   String? contentUrl;
//   int? width;
//   int? height;
//   Publisher? isPartOf;
//   Publisher? primaryImageOfPage;
//   String? datePublished;
//   String? dateModified;
//   Publisher? breadcrumb;
//   List<ItemListElement>? itemListElement;
//   Publisher? author;
//   String? headline;
//   Publisher? mainEntityOfPage;
//   int? wordCount;
//   int? commentCount;
//   String? thumbnailUrl;
//   List<String>? keywords;
//   List<String>? articleSection;
//
//   Graph(
//       {this.type,
//         this.id,
//         this.name,
//         this.url,
//         this.sameAs,
//         this.logo,
//         this.image,
//         this.description,
//         this.publisher,
//         this.potentialAction,
//         this.inLanguage,
//         this.contentUrl,
//         this.width,
//         this.height,
//         this.isPartOf,
//         this.primaryImageOfPage,
//         this.datePublished,
//         this.dateModified,
//         this.breadcrumb,
//         this.itemListElement,
//         this.author,
//         this.headline,
//         this.mainEntityOfPage,
//         this.wordCount,
//         this.commentCount,
//         this.thumbnailUrl,
//         this.keywords,
//         this.articleSection});
//
//   Graph.fromJson(Map<String, dynamic> json) {
//     type = json['@type'];
//     id = json['@id'];
//     name = json['name'];
//     url = json['url'];
//
//     logo = json['logo'] != null ? new Logo.fromJson(json['logo']) : null;
//     image = json['image'] != null ? new Image.fromJson(json['image']) : null;
//     description = json['description'];
//     publisher = json['publisher'] != null
//         ? new Publisher.fromJson(json['publisher'])
//         : null;
//     if (json['potentialAction'] != null) {
//       potentialAction = <PotentialAction>[];
//       json['potentialAction'].forEach((v) {
//         potentialAction!.add(new PotentialAction.fromJson(v));
//       });
//     }
//     inLanguage = json['inLanguage'];
//     contentUrl = json['contentUrl'];
//     width = json['width'];
//     height = json['height'];
//     isPartOf = json['isPartOf'] != null
//         ? new Publisher.fromJson(json['isPartOf'])
//         : null;
//     primaryImageOfPage = json['primaryImageOfPage'] != null
//         ? new Publisher.fromJson(json['primaryImageOfPage'])
//         : null;
//     datePublished = json['datePublished'];
//     dateModified = json['dateModified'];
//     breadcrumb = json['breadcrumb'] != null
//         ? new Publisher.fromJson(json['breadcrumb'])
//         : null;
//     if (json['itemListElement'] != null) {
//       itemListElement = <ItemListElement>[];
//       json['itemListElement'].forEach((v) {
//         itemListElement!.add(new ItemListElement.fromJson(v));
//       });
//     }
//     author =
//     json['author'] != null ? new Publisher.fromJson(json['author']) : null;
//     headline = json['headline'];
//     mainEntityOfPage = json['mainEntityOfPage'] != null
//         ? new Publisher.fromJson(json['mainEntityOfPage'])
//         : null;
//     wordCount = json['wordCount'];
//     commentCount = json['commentCount'];
//     thumbnailUrl = json['thumbnailUrl'];
//     keywords = json['keywords'].cast<String>();
//     articleSection = json['articleSection'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['@type'] = this.type;
//     data['@id'] = this.id;
//     data['name'] = this.name;
//     data['url'] = this.url;
//
//     if (this.logo != null) {
//       data['logo'] = this.logo!.toJson();
//     }
//     if (this.image != null) {
//       data['image'] = this.image!.toJson();
//     }
//     data['description'] = this.description;
//     if (this.publisher != null) {
//       data['publisher'] = this.publisher!.toJson();
//     }
//     if (this.potentialAction != null) {
//       data['potentialAction'] =
//           this.potentialAction!.map((v) => v.toJson()).toList();
//     }
//     data['inLanguage'] = this.inLanguage;
//     data['contentUrl'] = this.contentUrl;
//     data['width'] = this.width;
//     data['height'] = this.height;
//     if (this.isPartOf != null) {
//       data['isPartOf'] = this.isPartOf!.toJson();
//     }
//     if (this.primaryImageOfPage != null) {
//       data['primaryImageOfPage'] = this.primaryImageOfPage!.toJson();
//     }
//     data['datePublished'] = this.datePublished;
//     data['dateModified'] = this.dateModified;
//     if (this.breadcrumb != null) {
//       data['breadcrumb'] = this.breadcrumb!.toJson();
//     }
//     if (this.itemListElement != null) {
//       data['itemListElement'] =
//           this.itemListElement!.map((v) => v.toJson()).toList();
//     }
//     if (this.author != null) {
//       data['author'] = this.author!.toJson();
//     }
//     data['headline'] = this.headline;
//     if (this.mainEntityOfPage != null) {
//       data['mainEntityOfPage'] = this.mainEntityOfPage!.toJson();
//     }
//     data['wordCount'] = this.wordCount;
//     data['commentCount'] = this.commentCount;
//     data['thumbnailUrl'] = this.thumbnailUrl;
//     data['keywords'] = this.keywords;
//     data['articleSection'] = this.articleSection;
//     return data;
//   }
// }
//
// class Logo {
//   String? type;
//   String? id;
//   String? inLanguage;
//   String? url;
//   String? contentUrl;
//   int? width;
//   int? height;
//   String? caption;
//
//   Logo(
//       {this.type,
//         this.id,
//         this.inLanguage,
//         this.url,
//         this.contentUrl,
//         this.width,
//         this.height,
//         this.caption});
//
//   Logo.fromJson(Map<String, dynamic> json) {
//     type = json['@type'];
//     id = json['@id'];
//     inLanguage = json['inLanguage'];
//     url = json['url'];
//     contentUrl = json['contentUrl'];
//     width = json['width'];
//     height = json['height'];
//     caption = json['caption'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['@type'] = this.type;
//     data['@id'] = this.id;
//     data['inLanguage'] = this.inLanguage;
//     data['url'] = this.url;
//     data['contentUrl'] = this.contentUrl;
//     data['width'] = this.width;
//     data['height'] = this.height;
//     data['caption'] = this.caption;
//     return data;
//   }
// }
//
// class Image {
//   String? id;
//   String? type;
//   String? inLanguage;
//   String? url;
//   String? contentUrl;
//   String? caption;
//
//   Image(
//       {this.id,
//         this.type,
//         this.inLanguage,
//         this.url,
//         this.contentUrl,
//         this.caption});
//
//   Image.fromJson(Map<String, dynamic> json) {
//     id = json['@id'];
//     type = json['@type'];
//     inLanguage = json['inLanguage'];
//     url = json['url'];
//     contentUrl = json['contentUrl'];
//     caption = json['caption'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['@id'] = this.id;
//     data['@type'] = this.type;
//     data['inLanguage'] = this.inLanguage;
//     data['url'] = this.url;
//     data['contentUrl'] = this.contentUrl;
//     data['caption'] = this.caption;
//     return data;
//   }
// }
//
// class Publisher {
//   String? id;
//
//   Publisher({this.id});
//
//   Publisher.fromJson(Map<String, dynamic> json) {
//     id = json['@id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['@id'] = this.id;
//     return data;
//   }
// }
//
// class PotentialAction {
//   String? type;
//   Target? target;
//   String? queryInput;
//   String? name;
//
//   PotentialAction({this.type, this.target, this.queryInput, this.name});
//
//   PotentialAction.fromJson(Map<String, dynamic> json) {
//     type = json['@type'];
//     target =
//     json['target'] != null ? new Target.fromJson(json['target']) : null;
//     queryInput = json['query-input'];
//     name = json['name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['@type'] = this.type;
//     if (this.target != null) {
//       data['target'] = this.target!.toJson();
//     }
//     data['query-input'] = this.queryInput;
//     data['name'] = this.name;
//     return data;
//   }
// }
//
// class Target {
//   String? type;
//   String? urlTemplate;
//
//   Target({this.type, this.urlTemplate});
//
//   Target.fromJson(Map<String, dynamic> json) {
//     type = json['@type'];
//     urlTemplate = json['urlTemplate'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['@type'] = this.type;
//     data['urlTemplate'] = this.urlTemplate;
//     return data;
//   }
// }
//
// class ItemListElement {
//   String? type;
//   int? position;
//   String? name;
//   String? item;
//
//   ItemListElement({this.type, this.position, this.name, this.item});
//
//   ItemListElement.fromJson(Map<String, dynamic> json) {
//     type = json['@type'];
//     position = json['position'];
//     name = json['name'];
//     item = json['item'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['@type'] = this.type;
//     data['position'] = this.position;
//     data['name'] = this.name;
//     data['item'] = this.item;
//     return data;
//   }
// }
//
// class XMetadata {
//   String? sPowerkitReadingTime;
//   String? sThumbnailId;
//   String? sYoastWpseoContentScore;
//   String? sYoastWpseoEstimatedReadingTimeMinutes;
//   String? sAbrReviewSettings;
//   String? sYoastWpseoPrimaryCategory;
//   String? powerkitShareButtonsTransientFacebook;
//   String? powerkitShareButtonsTransientPinterest;
//
//   XMetadata(
//       {this.sPowerkitReadingTime,
//         this.sThumbnailId,
//         this.sYoastWpseoContentScore,
//         this.sYoastWpseoEstimatedReadingTimeMinutes,
//         this.sAbrReviewSettings,
//         this.sYoastWpseoPrimaryCategory,
//         this.powerkitShareButtonsTransientFacebook,
//         this.powerkitShareButtonsTransientPinterest});
//
//   XMetadata.fromJson(Map<String, dynamic> json) {
//     sPowerkitReadingTime = json['_powerkit_reading_time'];
//     sThumbnailId = json['_thumbnail_id'];
//     sYoastWpseoContentScore = json['_yoast_wpseo_content_score'];
//     sYoastWpseoEstimatedReadingTimeMinutes =
//     json['_yoast_wpseo_estimated_reading_time_minutes'];
//     sAbrReviewSettings = json['_abr_review_settings'];
//     sYoastWpseoPrimaryCategory = json['_yoast_wpseo_primary_category'];
//     powerkitShareButtonsTransientFacebook =
//     json['powerkit_share_buttons_transient_facebook'];
//     powerkitShareButtonsTransientPinterest =
//     json['powerkit_share_buttons_transient_pinterest'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_powerkit_reading_time'] = this.sPowerkitReadingTime;
//     data['_thumbnail_id'] = this.sThumbnailId;
//     data['_yoast_wpseo_content_score'] = this.sYoastWpseoContentScore;
//     data['_yoast_wpseo_estimated_reading_time_minutes'] =
//         this.sYoastWpseoEstimatedReadingTimeMinutes;
//     data['_abr_review_settings'] = this.sAbrReviewSettings;
//     data['_yoast_wpseo_primary_category'] = this.sYoastWpseoPrimaryCategory;
//     data['powerkit_share_buttons_transient_facebook'] =
//         this.powerkitShareButtonsTransientFacebook;
//     data['powerkit_share_buttons_transient_pinterest'] =
//         this.powerkitShareButtonsTransientPinterest;
//     return data;
//   }
// }
//
// class Links {
//   List<Self>? self;
//   List<Author>? author;
//   List<VersionHistory>? versionHistory;
//   List<PredecessorVersion>? predecessorVersion;
//
//   List<WpTerm>? wpTerm;
//   List<Curies>? curies;
//
//   Links(
//       {this.self,
//
//         this.author,
//         this.versionHistory,
//         this.predecessorVersion,
//
//         this.wpTerm,
//         this.curies});
//
//   Links.fromJson(Map<String, dynamic> json) {
//     if (json['self'] != null) {
//       self = <Self>[];
//       json['self'].forEach((v) {
//         self!.add(new Self.fromJson(v));
//       });
//     }
//
//     if (json['version-history'] != null) {
//       versionHistory = <VersionHistory>[];
//       json['version-history'].forEach((v) {
//         versionHistory!.add(new VersionHistory.fromJson(v));
//       });
//     }
//     if (json['predecessor-version'] != null) {
//       predecessorVersion = <PredecessorVersion>[];
//       json['predecessor-version'].forEach((v) {
//         predecessorVersion!.add(new PredecessorVersion.fromJson(v));
//       });
//     }
//
//     if (json['wp:term'] != null) {
//       wpTerm = <WpTerm>[];
//       json['wp:term'].forEach((v) {
//         wpTerm!.add(new WpTerm.fromJson(v));
//       });
//     }
//     if (json['curies'] != null) {
//       curies = <Curies>[];
//       json['curies'].forEach((v) {
//         curies!.add(new Curies.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.self != null) {
//       data['self'] = this.self!.map((v) => v.toJson()).toList();
//     }
//
//     if (this.versionHistory != null) {
//       data['version-history'] =
//           this.versionHistory!.map((v) => v.toJson()).toList();
//     }
//     if (this.predecessorVersion != null) {
//       data['predecessor-version'] =
//           this.predecessorVersion!.map((v) => v.toJson()).toList();
//     }
//     if (this.wpTerm != null) {
//       data['wp:term'] = this.wpTerm!.map((v) => v.toJson()).toList();
//     }
//     if (this.curies != null) {
//       data['curies'] = this.curies!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Self {
//   String? href;
//
//   Self({this.href});
//
//   Self.fromJson(Map<String, dynamic> json) {
//     href = json['href'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['href'] = this.href;
//     return data;
//   }
// }
//
// class Author {
//   bool? embeddable;
//   String? href;
//
//   Author({this.embeddable, this.href});
//
//   Author.fromJson(Map<String, dynamic> json) {
//     embeddable = json['embeddable'];
//     href = json['href'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['embeddable'] = this.embeddable;
//     data['href'] = this.href;
//     return data;
//   }
// }
//
// class VersionHistory {
//   int? count;
//   String? href;
//
//   VersionHistory({this.count, this.href});
//
//   VersionHistory.fromJson(Map<String, dynamic> json) {
//     count = json['count'];
//     href = json['href'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['count'] = this.count;
//     data['href'] = this.href;
//     return data;
//   }
// }
//
// class PredecessorVersion {
//   int? id;
//   String? href;
//
//   PredecessorVersion({this.id, this.href});
//
//   PredecessorVersion.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     href = json['href'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['href'] = this.href;
//     return data;
//   }
// }
//
// class WpTerm {
//   String? taxonomy;
//   bool? embeddable;
//   String? href;
//
//   WpTerm({this.taxonomy, this.embeddable, this.href});
//
//   WpTerm.fromJson(Map<String, dynamic> json) {
//     taxonomy = json['taxonomy'];
//     embeddable = json['embeddable'];
//     href = json['href'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['taxonomy'] = this.taxonomy;
//     data['embeddable'] = this.embeddable;
//     data['href'] = this.href;
//     return data;
//   }
// }
//
// class Curies {
//   String? name;
//   String? href;
//   bool? templated;
//
//   Curies({this.name, this.href, this.templated});
//
//   Curies.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     href = json['href'];
//     templated = json['templated'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['href'] = this.href;
//     data['templated'] = this.templated;
//     return data;
//   }
// }
