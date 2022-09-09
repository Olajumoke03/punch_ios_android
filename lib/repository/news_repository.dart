import 'dart:convert';
import 'package:punch_ios_android/about_us/about_model.dart';
import 'package:punch_ios_android/category_list/model.dart';
import 'package:punch_ios_android/category_list/responses.dart';
import 'package:punch_ios_android/featured_news/featured_news_response.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/home_news/home_response.dart';
import 'package:punch_ios_android/model/responses/net_core_response.dart';
import 'package:punch_ios_android/news_by_category/response.dart';
import 'package:punch_ios_android/news_tag/news_tag_response.dart';
import 'package:punch_ios_android/repository/api_client.dart';
import 'package:punch_ios_android/search_result/search_model.dart';
import 'package:punch_ios_android/search_result/search_response.dart';
import 'package:punch_ios_android/utility/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Repository   {
  final ApiClient _apiClient = ApiClient();
  SharedPreferences? prefs ;
  Repository() {
    openCache();
  }

  void openCache() async {
    prefs = await SharedPreferences.getInstance();
  }

  /*
   * caches any string and key
   */
  void saveAnyStringToCache(String value,String key) async {
    // check if the key even exists
    prefs!.setString(key,value);
  }


  // checks shared preferences and fetches the  data saved there
  Future<String> getAnyStringValueFromCache(String key) async {
     openCache();
    String? value = prefs!.getString(key);
    return value!;
  }


  Future<HomeNewsResponse>fetchSingleNews(String slug) async {
    final response = await _apiClient.get(Constants.SINGLE_NEWS+slug);
    print('single fetch :' + response);
    var data = json.decode(response);
    return  HomeNewsResponse.fromJson(data);
  }

  Future<List<HomeNewsModel>>fetchFeaturedNews() async {
    final response = await _apiClient.get(Constants.FEATURED_NEWS+"34");
    var data = json.decode(response);
    print("featured news  response " + response);

    FeaturedNewsResponse featuredNews = FeaturedNewsResponse.fromJson(data);
    saveAnyStringToCache(response, Constants.Constants.featuredNewsCacheKey);

    return featuredNews.featuredNewss;
  }


  Future<List<HomeNewsModel>>fetchHomeNews() async {
    final response = await _apiClient.get(Constants.LATEST_NEWS);
    var data = json.decode(response);
    print("home news  response " + response);
    // try{
    HomeNewsResponse  homeNewsResponse = HomeNewsResponse.fromJson(data);

    // pick just 10 out of the news
    List<HomeNewsModel> newsToCache = homeNewsResponse.homeNewss;
    // cache latest  news to shared preferences
    saveAnyStringToCache(jsonEncode(newsToCache), Constants.Constants.latestNewsCacheKey);

    return homeNewsResponse.homeNewss;
  }

  Future<List<HomeNewsModel>>fetchMoreHomeNews(int page) async {
    final response = await _apiClient.get(Constants.MORE_LATEST_NEWS+page.toString());
    var data = json.decode(response);
    HomeNewsResponse  homeNewsResponse = HomeNewsResponse.fromJson(data);
    return homeNewsResponse.homeNewss;
  }

  Future <List<CategoryListModel>>fetchCategoryList() async {
    final response = await _apiClient.get(Constants.CATEGORY_LIST);
    final data = json.decode(response);
    print("this is category list  response  " + response.toString());
    CategoryListResponse  categoryListResponse = CategoryListResponse.fromJson(data);
    return categoryListResponse.categoryLists;
  }

  Future<NetCoreResponse> subscribeToNewsLetter(String email) async{
    var body =  {
      'data':"{\"EMAIL\":\""+email+"\"}",
    };
    final response = await _apiClient.post(Constants.netCoreUrl, body);
    final json = jsonDecode(response);
    return NetCoreResponse.fromJson(json);

  }

  Future<List<HomeNewsModel>>fetchNewsByCategory(String id) async {
    final response = await _apiClient.get(Constants.NEWS_BY_CATEGORY+id);
    var data = json.decode(response);
    print("news by category  response " + response);
    NewsByCategoryResponse newsByCategory = NewsByCategoryResponse.fromJson(data);
    return newsByCategory.newsByCategorys;
  }

  Future<List<HomeNewsModel>>fetchMoreNewsByCategory(int page, String id) async {
    final response = await _apiClient.get(Constants.MORE_NEWS_BY_CATEGORY+id+"&page="+page.toString());
    var data = json.decode(response);
    print("more home news  response " + response);
    NewsByCategoryResponse  newsByCategoryResponse = NewsByCategoryResponse.fromJson(data);
    return newsByCategoryResponse.newsByCategorys;
  }

  Future<List<SearchResultModel>>searchNews(String searchQuery) async {
    final response = await _apiClient.get(Constants.SEARCH_RESULT+searchQuery);
    var data = json.decode(response);
    SearchResultResponse  searchResultResponse = SearchResultResponse.fromJson(data);
    print("search result response " + searchResultResponse.toString());
    return searchResultResponse.searchResults;
  }

  Future<List<HomeNewsModel>>fetchNewsTag(String id) async {
    final response = await _apiClient.get(Constants.NEWS_TAG+id);
    print("NewsTag " + response);
    var data = json.decode(response);
    NewsTagResponse newsTag = NewsTagResponse.fromJson(data);
    return newsTag.newsTags;
  }

  Future<AboutUsModel> fetchAboutUs() async {
    final response = await _apiClient.get ( Constants.ABOUT_US );
    final data = json.decode ( response );
    return  AboutUsModel.fromJson ( json.decode ( response ) );
  }

}
