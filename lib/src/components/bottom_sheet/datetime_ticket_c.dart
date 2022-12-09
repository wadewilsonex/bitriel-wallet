
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/ticket_m.dart';

Future dateTimeTicket({BuildContext? context, List<ListMonthYear>? data, required int? tkTypeIndex}){
  print("data.length, ${data!.length}");
  print("data ${data[tkTypeIndex!].lstSessionsByMonth!}}");
  data[tkTypeIndex].lstSessionsByMonth!.forEach(((element) {
    print(element.mmYY);
  }));
  return showModalBottomSheet(
    context: context!,
    isScrollControlled: true,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            decoration: BoxDecoration(
              color: isDarkMode
                ? hexaCodeToColor(AppColors.darkBgd)
                : hexaCodeToColor(AppColors.lowWhite),
            ),
            child: ListView.builder(
              itemCount: data[tkTypeIndex].lstSessionsByMonth!.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return ExpansionTile(
                  /// Month - Year
                  title: MyText(
                    text: data[tkTypeIndex].lstSessionsByMonth![index].mmYY,
                  ),
                  iconColor: Colors.black,
                  collapsedIconColor: Colors.black,
                  children: [

                    // GridView.builder(  
                    //   shrinkWrap: true,
                    //   itemCount: data[index]['value'].length,  
                    //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(  
                    //     maxCrossAxisExtent: 120,
                    //     childAspectRatio: 10,
                    //     crossAxisSpacing: 10,  
                    //     mainAxisSpacing: 10,
                    //   ),  
                    //   itemBuilder: (BuildContext context, int i){  
                    //     return MyText(
                    //       height: 20,
                    //       width: 50,
                    //       text: AppUtils.stringDateToDateTime(data[index]['value'][i]['date']),
                    //     );  
                    //   },  
                    // )
                    
                    Container(
                      height: 150,
                      child: SingleChildScrollView(
                      child: Column(
                          children: [
                            
                            for(int i = 0; i < data[tkTypeIndex].lstSessionsByMonth![index].lstDateAndSessions!.length; i++)
                            ListTile(
                              onTap: (){
                                Navigator.pop(
                                  context, 
                                  {
                                    'date': data[tkTypeIndex].lstSessionsByMonth![index].lstDateAndSessions![i].date, 
                                    /// Index of TicketType
                                    '1_tkType_index': tkTypeIndex,
                                    /// Index Of Date - Year 
                                    '2_ddyy_index': index,
                                    /// Session Index
                                    '3_date_index': i,
                                  }
                                );
                              },
                              title: MyText(
                                text: AppUtils.stringDateToDateTime(data[tkTypeIndex].lstSessionsByMonth![index].lstDateAndSessions![i].date!),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }
            ),
          ),
        ],
      );
    },
  );
}