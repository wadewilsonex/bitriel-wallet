import 'package:wallet_apps/index.dart';

class SeedsCompoent {

  double _seedHeight = 22.8;

  List<Widget> getColumn(BuildContext context, String seed, int pos, {double? moreSize = 0}) {
    
    _seedHeight = (_seedHeight+moreSize!).sp;
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
            padding: EdgeInsets.only(top: 8, bottom: 8),
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
            padding: EdgeInsets.only(top: 8, bottom: 8),
            alignment: Alignment.center,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
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
                    text: (i * 3 + pos + 1).toString() + '. ' + se[i * 3 + pos],
                    color: AppColors.whiteColorHexa,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  )

                  else MyText(
                    text: (i * 3 + pos + 1).toString() + '. ' + se[i * 3 + pos],
                    color: AppColors.whiteColorHexa,
                    fontSize: 15,
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
          color: Colors.white.withOpacity(0.06),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ), 
        // color: grey,
        child: MyText(
          text: txt,
          color2: Colors.white, fontSize: 15, fontWeight: FontWeight.bold
        ),
      )
    );
  }

}

class SeedContents extends StatelessWidget{

  final String? title;
  final String? subTitle;

  SeedContents({required this.title, required this.subTitle});

  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(height: 50),
        MyText(
          text: title,
          color: AppColors.whiteColorHexa,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),

        SizedBox(height: 5.5.h),
        MyText(
          text: subTitle,
          color: AppColors.lowWhite,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}