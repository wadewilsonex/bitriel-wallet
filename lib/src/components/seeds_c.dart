import 'package:wallet_apps/index.dart';

class SeedsCompoent {

  double _seedHeight = 22.8;

  List<Widget> getColumn(BuildContext context, String seed, int pos, {double? moreSize = 0}) {
    
    _seedHeight = (_seedHeight+moreSize!);
    var list = <Widget>[];
    var se = seed.split(' ');
    var colSize = se.length ~/ 3;

    for (var i = 0; i < colSize; i++) {
      
      if (se[i * 3 + pos] == ""){
        list.add(
          // Display Empty Text 
          Container(
            // Minus 34 Size OF Padding Left & Right
            width: MediaQuery.of(context).size.width / 3 - _seedHeight,
            height: 5.8.h,
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            alignment: Alignment.center,
            margin: const EdgeInsets.all(4),
            color: Colors.transparent,
          )
        );
      } else {

        list.add(
          Container(
            // Minus 34 Size OF Padding Left & Right
            width: MediaQuery.of(context).size.width / 3 - _seedHeight,
            height: 5.8.h,
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            alignment: Alignment.center,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white.withOpacity(0.06) : hexaCodeToColor(AppColors.whiteHexaColor),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            ),
            // color: grey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  if ( (i * 3 + pos + 1) < 10)
                  MyText(
                    text: '${i * 3 + pos + 1}. ${se[i * 3 + pos]}',
                    hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
                    fontSize: 17 * MediaQuery.of(context).textScaleFactor,
                    fontWeight: FontWeight.bold
                  )

                  else MyText(
                    text: '${i * 3 + pos + 1}. ${se[i * 3 + pos]}',
                    hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
                    fontSize: 17 * MediaQuery.of(context).textScaleFactor,
                    fontWeight: FontWeight.bold
                  ),
                ]
              ),
            ),
          )
        );
      }
      }
    return list;
  }


  Widget seedContainer(BuildContext context, String txt, int index, int rmIndex, Function? onTap){
    return GestureDetector(
      onTap: (){
        onTap!(index, rmIndex);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 3 - _seedHeight,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.white.withOpacity(0.06) : hexaCodeToColor(AppColors.whiteHexaColor),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ), 
        // color: grey,
        child: MyText(
          text: txt,
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor, fontSize: 17 * MediaQuery.of(context).textScaleFactor, fontWeight: FontWeight.bold
        ),
      )
    );
  }

}

class SeedContents extends StatelessWidget{

  final String? title;
  final String? subTitle;

  const SeedContents({Key? key, required this.title, required this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 25),
        MyText(
          text: title,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),

        const SizedBox(height: 2.2),
        MyText(
          text: subTitle,
          hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.darkGrey,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.start,
          fontSize: 18,
        ),
      ],
    );
  }
}