import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/article_news_c.dart';

class ArticleNews extends StatelessWidget {

  final Map<String, dynamic>? articleQueried;

  const ArticleNews({Key? key, this.articleQueried}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: paddingSize),
      itemCount: articleQueried!["Data"].length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ArticleNewsList(articleQueried: articleQueried, index: index)
          ],
        );
      }
    );
  }

  
}