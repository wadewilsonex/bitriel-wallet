import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/get_request.dart';

class ArticleProvider with ChangeNotifier {

  Map<String, dynamic>? articleQueried;

  Future<Map<String, dynamic>?> requestArticle(){
    
    articleQueried = {};

    return getNewsArticle().then((value) async {

      if (value.statusCode == 200 && json.decode(value.body).isNotEmpty){

        articleQueried = await json.decode(value.body);

        notifyListeners();

      } else {
        articleQueried = {};
      }

      return articleQueried;
      
    });
    
  }
  

  @override
  notifyListeners();
}

