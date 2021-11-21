// import 'package:flutter/material.dart';

// import '../../../../index.dart';

// class AssetInfoBody extends StatelessWidget {
//   final String id;
//   final String assetLogo;
//   final String balance;
//   final String assetSymbol;
//   final String tokenSymbol;
//   final String marketPrice;
//   final String priceChange24h;
//   final String org;

//   const AssetInfoBody(
//     this.id,
//     this.assetLogo,
//     this.balance,
//     this.assetSymbol,
//     this.tokenSymbol,
//     this.marketPrice,
//     this.priceChange24h,
//     this.org
//   );
//   @override
//   Widget build(BuildContext context) {
//     final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
//     return BodyScaffold(
//       isSafeArea: true,
//       bottom: 0,
//       height: MediaQuery.of(context).size.height,
//       child: NestedScrollView(
//         headerSliverBuilder: (BuildContext context, bool innerBox) {
//           return [
//             SliverAppBar(
//               pinned: true,
//               expandedHeight: 77,
//               forceElevated: innerBox,
//               automaticallyImplyLeading: false,
//               leading: Container(),
//               backgroundColor: isDarkTheme
//                   ? hexaCodeToColor(AppColors.darkCard)
//                   : Colors.white,
//               flexibleSpace: Column(children: [
//                 Expanded(
//                     child: Padding(
//                         padding: const EdgeInsets.only(left: 20, right: 20),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             GestureDetector(
//                                 onTap: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Container(
//                                     alignment: Alignment.centerLeft,
//                                     padding: const EdgeInsets.only(
//                                         right: 15, left: 10),
//                                     child: Icon(
//                                         Platform.isAndroid
//                                             ? Icons.arrow_back
//                                             : Icons.arrow_back_ios,
//                                         color: isDarkTheme
//                                             ? Colors.white
//                                             : Colors.black,
//                                         size: 28))),

//                             Container(
//                               alignment: Alignment.centerLeft,
//                               margin: const EdgeInsets.only(right: 8),
//                               width: 40,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Image.asset(
//                                 assetLogo,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                             MyText(
//                               fontSize: 18.0,
//                               color: isDarkTheme
//                                   ? AppColors.whiteHexaColor
//                                   : AppColors.blackColor,
//                               text: id == null
//                                   ? tokenSymbol
//                                   : id.toUpperCase(),
//                             ),

//                             Expanded(child: Container()),

//                             // Right Text
//                             Align(
//                                 alignment: Alignment.centerRight,
//                                 child: MyText(
//                                   fontSize: 16.0,
//                                   text:
//                                       org == 'BEP-20' ? 'BEP-20' : '',
//                                   color: isDarkTheme
//                                       ? AppColors.whiteHexaColor
//                                       : AppColors.darkCard,
//                                 )),
//                           ],
//                         ))),
//               ]),
//             ),

//             // Under Line of AppBar
//             SliverList(
//                 delegate: SliverChildListDelegate([
//               Divider(
//                   height: 3,
//                   color: isDarkTheme
//                       ? hexaCodeToColor(AppColors.darkCard)
//                       : Colors.grey.shade400)
//             ])),

//             // Body
//             SliverList(
//               delegate: SliverChildListDelegate(
//                 <Widget>[
//                   Container(
//                     color: isDarkTheme
//                         ? hexaCodeToColor(AppColors.darkBgd)
//                         : hexaCodeToColor(AppColors.whiteHexaColor),
//                     child: Column(
//                       children: [
//                         // if (widget.tokenSymbol == "ATD")
//                         //   Align(
//                         //     alignment: Alignment.topRight,
//                         //     child: Consumer<ContractProvider>(
//                         //       builder: (context, value, child) {
//                         //         return MyText(
//                         //           textAlign: TextAlign.right,
//                         //           text: value.atd.status
//                         //               ? 'Status: Check-In'
//                         //               : 'Status: Check-out',
//                         //           fontSize: 16.0,
//                         //           right: 16.0,
//                         //           color: isDarkTheme
//                         //               ? AppColors.whiteColorHexa
//                         //               : AppColors.textColor,
//                         //         );
//                         //       },
//                         //     ),
//                         //   )
//                         // else
//                         //   Container(),
//                         SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.05,
//                         ),
//                         MyText(
//                           text:
//                               '${widget.balance}${' ${widget.tokenSymbol}'}',
//                           //AppColors.secondarytext,
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           overflow: TextOverflow.ellipsis,
//                           color: isDarkTheme
//                               ? AppColors.whiteColorHexa
//                               : AppColors.textColor,
//                         ),
//                         MyText(
//                           top: 8.0,
//                           text: widget.balance != AppString.loadingPattern &&
//                                   widget.marketPrice != null
//                               ? '≈ \$$totalUsd'
//                               : '≈ \$0.00',

//                           fontSize: 28,
//                           color: isDarkTheme
//                               ? AppColors.whiteColorHexa
//                               : AppColors.textColor,
//                           //fontWeight: FontWeight.bold,
//                         ),
//                         const SizedBox(height: 8.0),
//                         if (widget.marketPrice == null)
//                           Container()
//                         else
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               MyText(
//                                 text: '\$ ${widget.marketPrice}' ?? '',
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: isDarkTheme
//                                     ? AppColors.whiteColorHexa
//                                     : AppColors.textColor,
//                               ),
//                               const SizedBox(width: 6.0),
//                               MyText(
//                                 text: widget.priceChange24h.substring(0, 1) ==
//                                         '-'
//                                     ? '${widget.priceChange24h}%'
//                                     : '+${widget.priceChange24h}%',
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color:
//                                     widget.priceChange24h.substring(0, 1) ==
//                                             '-'
//                                         ? '#FF0000'
//                                         : isDarkTheme
//                                             ? '#00FF00'
//                                             : '#66CD00',
//                               ),
//                             ],
//                           ),
//                         Container(
//                           margin: const EdgeInsets.only(top: 40),
//                           padding: widget.tokenSymbol == 'ATD'
//                               ? const EdgeInsets.symmetric()
//                               : const EdgeInsets.symmetric(vertical: 16.0),
//                           child: widget.tokenSymbol == 'ATD'
//                               ? Container()
//                               : Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     SizedBox(
//                                       height: 50,
//                                       width: 150,
//                                       // ignore: deprecated_member_use
//                                       child: FlatButton(
//                                         onPressed: () async {
//                                           await MyBottomSheet().trxOptions(
//                                             context: context,
//                                           );
//                                         },
//                                         color: hexaCodeToColor(
//                                             AppColors.secondary),
//                                         disabledColor: Colors.grey[700],
//                                         focusColor: hexaCodeToColor(
//                                             AppColors.secondary),
//                                         child: const MyText(
//                                             text: 'Transfer',
//                                             color: AppColors.whiteColorHexa),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 16.0),
//                                     SizedBox(
//                                       height: 50,
//                                       width: 150,
//                                       // ignore: deprecated_member_use
//                                       child: FlatButton(
//                                         onPressed: () {
//                                           AssetInfoC().showRecieved(
//                                             context,
//                                             _method,
//                                             symbol: widget.tokenSymbol,
//                                             org: widget.org,
//                                           );
//                                         },
//                                         color: hexaCodeToColor(
//                                           AppColors.secondary,
//                                         ),
//                                         disabledColor: Colors.grey[700],
//                                         focusColor: hexaCodeToColor(
//                                           AppColors.secondary,
//                                         ),
//                                         child: const MyText(
//                                           text: 'Recieved',
//                                           color: AppColors.whiteColorHexa,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: 32.0,
//                     color: isDarkTheme
//                         ? hexaCodeToColor(AppColors.darkBgd)
//                         : hexaCodeToColor(AppColors.whiteHexaColor),
//                   ),
//                   Container(
//                     //padding: const EdgeInsets.only(top: 32.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               onTabChange(0);
//                             },
//                             child: Container(
//                               alignment: Alignment.center,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 color: isDarkTheme
//                                     ? hexaCodeToColor(AppColors.darkCard)
//                                     : hexaCodeToColor(
//                                         AppColors.whiteHexaColor),
//                                 border: Border(
//                                   bottom: BorderSide(
//                                     color: _tabIndex == 0
//                                         ? hexaCodeToColor(AppColors.secondary)
//                                         : Colors.transparent,
//                                     width: 1.5,
//                                   ),
//                                 ),
//                               ),
//                               child: MyText(
//                                 text: "Details",
//                                 color: _tabIndex == 0
//                                     ? AppColors.secondary
//                                     : isDarkTheme
//                                         ? AppColors.darkSecondaryText
//                                         : AppColors.textColor,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               onTabChange(1);
//                             },
//                             child: Container(
//                               alignment: Alignment.center,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 color: isDarkTheme
//                                     ? hexaCodeToColor(AppColors.darkCard)
//                                     : hexaCodeToColor(
//                                         AppColors.whiteHexaColor),
//                                 border: Border(
//                                   bottom: BorderSide(
//                                     color: _tabIndex == 1
//                                         ? hexaCodeToColor(AppColors.secondary)
//                                         : Colors.transparent,
//                                     width: 1.5,
//                                   ),
//                                 ),
//                               ),
//                               child: MyText(
//                                 text: "Activity",
//                                 color: _tabIndex == 1
//                                     ? AppColors.secondary
//                                     : isDarkTheme
//                                         ? AppColors.darkSecondaryText
//                                         : AppColors.textColor,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ), //
//                   ),
//                 ],
//               ),
//             ),
//           ];
//         },
//         body: PageView(
//           controller: controller,
//           onPageChanged: (index) {
//             onPageChange(index);
//           },
//           children: <Widget>[
//             if (widget.marketData != null)
//               Container(
//                 color: isDarkTheme
//                     ? hexaCodeToColor(AppColors.darkCard)
//                     : hexaCodeToColor(AppColors.whiteHexaColor),
//                 child: AssetDetail(widget.marketData),
//               )
//             else
//               Container(
//                 color: isDarkTheme
//                     ? hexaCodeToColor(AppColors.darkCard)
//                     : hexaCodeToColor(AppColors.whiteHexaColor),
//                 child: Center(
//                   child: SvgPicture.asset(
//                     'assets/icons/no_data.svg',
//                     width: 150,
//                     height: 150,
//                   ),
//                 ),
//               ),
//             Container(
//               color: isDarkTheme
//                   ? hexaCodeToColor(AppColors.darkCard)
//                   : hexaCodeToColor(AppColors.whiteHexaColor),
//               child: Center(
//                   child: SvgPicture.asset(
//                 'assets/icons/no_data.svg',
//                 width: 150,
//                 height: 150,
//               )),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
