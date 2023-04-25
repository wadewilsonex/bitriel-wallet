import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/webview/marketplace_webview.dart';

class ArticleNewsList extends StatefulWidget {

  final Map<String, dynamic>? articleQueried;
  final int? index;

  const ArticleNewsList({Key? key,
    @required this.articleQueried,
    @required this.index,
  }) : super(key: key);

  @override
  State<ArticleNewsList> createState() => _ArticleNewsListState();
}

class _ArticleNewsListState extends State<ArticleNewsList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, 
          Transition(
            child: MarketPlaceWebView(url: widget.articleQueried!["Data"][widget.index]["url"], title: widget.articleQueried!["Data"][widget.index]["title"],),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20),
                ),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(widget.articleQueried!["Data"][widget.index]["imageurl"],),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyText(
                      pTop: 5,
                      text: widget.articleQueried!["Data"][widget.index]["title"],
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),

                    MyText(
                      pTop: 10,
                      text: widget.articleQueried!["Data"][widget.index]["body"],
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      maxLine: 3,
                      
                    ),
                      
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}