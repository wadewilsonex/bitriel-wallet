import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/appbar_c.dart';
import 'package:wallet_apps/src/components/search_c.dart';
import 'package:wallet_apps/src/provider/search_p.dart';

class SendBody extends StatelessWidget {

  final Function? query;

  const SendBody({ Key? key, @required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              SendAppBar(
                title: "SEND",
                trailing: IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.close, size: 30, color: Colors.white)
                ),
                margin: EdgeInsets.only(bottom: 30),
              ),
              
              MyText(
                textAlign: TextAlign.left,
                text: "What's to send?",
                bottom: 20, 
                color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.blackColor
              ),

              SearchComponent(query: query, setState: (){}),

              Expanded(
                child: Stack(
                  children: [
                    
                    // List Asset
                    Consumer<ContractProvider>(
                      builder: (context, provider, widget){
                        return SearchItemTrx(lsItem: provider.listContract);
                      }
                    ),

                    // Items Searched
                    Consumer<SearchProvider>(
                      builder: (context, provider, widget){
                        return provider.getSchLs.isNotEmpty ? SearchItemTrx(lsItem: provider.getSchLs) : Container();
                      }
                    ),
                  ],
                )
              )
            ],
          )
        )
      ),
    );
  }
}