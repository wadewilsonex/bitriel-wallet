import 'package:bitriel_wallet/index.dart';

class SelectSwapToken extends StatelessWidget {

  final List<LetsExCoinByNetworkModel> itemLE;

  const SelectSwapToken({super.key, required this.itemLE});

  @override
  Widget build(BuildContext context) {

    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: appBar(context, title: "Select Token"),
      body: Column(
        children: [
      
          _searchBar(searchController, itemLE),

          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: itemLE.length,
                  itemBuilder: (context, index) {
                    return _listTokenItem(context, index);
                  },
                ),


              ],
            ),
          ),
      
          // ValueListenableBuilder(
          //   valueListenable: leRepoImpl.lstLECoin,
          //   builder: (context, value, wg) {
          //     return Expanded(
          //       child: ListView.builder(
          //         itemCount: value.length,
          //         itemBuilder: (context, index) {
          //           return _listTokenItem(index);
          //         },
          //       ),
          //     );
          //   }
          // ),
        ],
      ),
    );
  }

  Widget _searchBar(TextEditingController searchController, List<LetsExCoinByNetworkModel> itemLE) {
    return Padding(
      padding: const EdgeInsets.only(top: 15 / 2, left: 15, right: 15, bottom: 15 / 2),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: 'Search among ${itemLE.length} tokens by name',
          // Add a clear button to the search bar
          suffixIcon: IconButton(
            icon: const Icon(Iconsax.close_circle),
            onPressed: () => searchController.clear(),
          ),
          // Add a search icon or button to the search bar
          prefixIcon: IconButton(
            icon: const Icon(Iconsax.search_normal_1),
            onPressed: () {
              // Perform the search here
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
    );
  }

  Widget _buildImageItem(int index) {
    // if (itemLE[index].icon == null) {
      return const CircleAvatar();
    // }
    // else if (itemLE[index].icon!.endsWith('.svg')) {
    //   // Handle SVG images using flutter_svg
    //   return SvgPicture.network(
    //     itemLE[index].icon!.replaceAll("\\/", "/"),
    //     placeholderBuilder: (context) => const CircularProgressIndicator(),
    //     height: 100,
    //     width: 100,
    //   );
    // } 
    // else {
    //   // Handle PNG and JPEG images using cached_network_image
    //   return CachedNetworkImage(
    //     imageUrl: itemLE[index].icon!.replaceAll("\\/", "/"),
    //     placeholder: (context, url) => const CircularProgressIndicator(),
    //     errorWidget: (context, url, error) => const CircleAvatar(),
    //   );
    // }
  }

  Widget _listTokenItem(BuildContext context, int index) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      leading: SizedBox(
        height: 30, 
        width: 30, 
        child: _buildImageItem(index),
      ),
      title: MyTextConstant(
        text: itemLE[index].title ?? '',
        fontWeight: FontWeight.w600,
        textAlign: TextAlign.start,
      ),
      subtitle: MyTextConstant(
        text: itemLE[index].network,
        color2: hexaCodeToColor(AppColors.grey),
        fontSize: 12,
        textAlign: TextAlign.start,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const MyTextConstant(
            text: "0.00",
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
          ),

          MyTextConstant(
            text: "\$0.00",
            color2: hexaCodeToColor(AppColors.grey),
            fontSize: 12,
            textAlign: TextAlign.start,
          ),
        ],
      ),
      onTap: () {
        Navigator.pop(context, index);
      },
    );
  }
}