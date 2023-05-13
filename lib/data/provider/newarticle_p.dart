import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/domain/backend/get_request.dart';
import 'package:wallet_apps/data/models/market/news_m.dart';

class ArticleProvider with ChangeNotifier {

  Map<String, dynamic>? articleQueried;

  List<NewsModel>? tenArticleQueried;

  Future<Map<String, dynamic>?> requestArticle(){
    
    articleQueried = {};

    tenArticleQueried = [];

    return getNewsArticle().then((value) async {

      if (value.statusCode == 200 && json.decode(value.body).isNotEmpty){

        articleQueried = await json.decode(value.body);

        notifyListeners();

        for (var element in List.from(articleQueried!['Data'])) {
          tenArticleQueried!.add(NewsModel.fromJson(element));
        }}

      else {
        articleQueried = {};
      }

      return articleQueried;
      
    });
    
  }
  

  @override
  notifyListeners();
}

