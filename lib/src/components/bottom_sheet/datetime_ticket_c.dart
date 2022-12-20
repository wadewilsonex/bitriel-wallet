
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/mdw_ticketing/ticket_m.dart';

Future dateTimeTicket({BuildContext? context, List<ListMonthYear>? data}){
  
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
              itemCount: data!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return ExpansionTile(
                  /// Month - Year
                  title: MyText(
                    text: data[index].session!.mmYY,
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
                    
                    SizedBox(
                      height: 150,
                      child: SingleChildScrollView(
                      child: Column(
                        children: [
                            
                          for(int i = 0; i < data[index].session!.lstDateAndSessions!.length; i++)
                            ListTile(
                              onTap: (){

                                /// Assign Index To Month - Year
                                /// 
                                // Provider.of<TicketProvider>(context, listen: false).indexMonthYear = i;

                                /// Return Index Of Month - Year In List
                                Navigator.pop(
                                  context, 
                                  i
                                );
                              },
                              title: MyText(
                                text: AppUtils.stringDateToDateTime(data[index].session!.lstDateAndSessions![i].date!),
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