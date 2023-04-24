import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/get_request.dart';

class ArticleProvider with ChangeNotifier {

  Map<String, dynamic>? articleQueried;

  Future<Map<String, dynamic>?> requestArticle(){
    
    articleQueried = {};

    return getNewsArticle().then((value) async {

      print("run requestArticle");

      if (value.statusCode == 200 && json.decode(value.body).isNotEmpty){

        articleQueried = await json.decode(value.body);

        print("requestArticle $articleQueried");

        notifyListeners();

      } else {
        articleQueried = {};
      }

      print("return requestArticle");

      return articleQueried;
      
    });
    
  }
  

  @override
  notifyListeners();
}

