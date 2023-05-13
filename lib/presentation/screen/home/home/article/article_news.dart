import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/presentation/components/article_news_c.dart';
import 'package:wallet_apps/data/models/market/news_m.dart';
import 'package:wallet_apps/presentation/screen/home/webview/marketplace_webview.dart';

// class ArticleNews extends StatelessWidget {

//   final Map<String, dynamic>? articleQueried;

//   const ArticleNews({Key? key, this.articleQueried}) : super(key: key);

  

// }
Widget articleNews(BuildContext context, List<NewsModel> articleQueried) {

  return ListView(
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: paddingSize),
    shrinkWrap: true,
    children: articleQueried.getRange(0, 10).map((e) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("index ${articleQueried.indexOf(e)}"),
          articleNewsList(context, e, articleQueried.indexOf(e))
        ],
      );
    }).toList(),
    // itemCount: articleQueried.length,
    // itemBuilder: (context, index){
      
    //   return Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Text("index $index")
    //       // articleNewsList(context, articleQueried!, index)
    //     ],
    //   );
    // }
  );
}


Widget articleNewsList(
  BuildContext context,
  NewsModel articleQueried,
  int index
) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context, 
        Transition(
          child: MarketPlaceWebView(url: articleQueried.url!, title: articleQueried.title!,),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT
        )
      );
    },
    child: Container(
      width: MediaQuery.of(context).size.width - 40,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              
              Expanded(
                child: Column(
                  children: [
                    
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          margin: const EdgeInsets.symmetric(horizontal: paddingSize),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(100),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(articleQueried.source_info!["img"],),
                            ),
                          ),
                        ),

                        MyText(
                          pTop: 10,
                          pBottom: 10,
                          pRight: paddingSize,
                          text: articleQueried.source_info!["name"],
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 20,
                        ),
                      ],
                    ),

                    MyText(
                      pTop: 10,
                      pBottom: 10,
                      pLeft: paddingSize,
                      pRight: paddingSize,
                      text: articleQueried.title,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLine: 4,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: 15,
              ),

              Container(
                width: 125,
                height: 125,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(articleQueried.imageurl!,),
                  ),
                ),
              ),
              // Expanded(
              //   child: Padding(
              //     padding: const EdgeInsets.only(right: 10),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         MyText(
              //           pTop: 5,
              //           text: articleQueried["Data"][index]["title"],
              //           textAlign: TextAlign.start,
              //           overflow: TextOverflow.ellipsis,
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold,
              //         ),

              //         MyText(
              //           pTop: 10,
              //           text: articleQueried["Data"][index]["body"],
              //           overflow: TextOverflow.ellipsis,
              //           textAlign: TextAlign.start,
              //           maxLine: 3,
                        
              //         ),
                        
              //       ],
              //     ),
              //   ),
              // )
              
            ],
          ),

          MyText(
            pTop: 10,
            pBottom: 10,
            pLeft: paddingSize,
            pRight: paddingSize,
            text: articleQueried.body,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            maxLine: 3,
            
          ),

          MyText(
            pTop: 10,
            pBottom: 10,
            pLeft: paddingSize,
            pRight: paddingSize,
            text: AppUtils.timeStampToDate(articleQueried.published_on!),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    ),
  );
}