import 'package:wallet_apps/index.dart';

class SeedsCompoent {

  List<Widget> getColumn(BuildContext context, String seed, int pos) {
    
    var list = <Widget>[];
    var se = seed.split(' ');
    var colSize = se.length ~/ 3;

    for (var i = 0; i < colSize; i++) {
      if (se[i * 3 + pos] == ""){
        list.add(
          // Display Empty Text 
          Container(
            // Minus 34 Size OF Padding Left & Right
            width: MediaQuery.of(context).size.width / 3 - 34,
            height: 45,
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
            width: MediaQuery.of(context).size.width / 3 - 34,
            height: 45,
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
                children: [

                  if ( (i * 3 + pos + 1) < 10)
                  Text(
                    (i * 3 + pos + 1).toString() + '. ' + se[i * 3 + pos],
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  )

                  else Text(
                    (i * 3 + pos + 1).toString() + '. ' + se[i * 3 + pos],
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
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
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),

        SizedBox(height: 25),
        MyText(
          text: subTitle,
          color: AppColors.bgdColor,
          fontSize: 18,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}