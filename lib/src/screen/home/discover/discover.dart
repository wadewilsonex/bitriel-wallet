import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/discover_m.dart';
import 'package:wallet_apps/src/models/market/marketplace_list_m.dart';
import 'package:wallet_apps/src/screen/home/discover/body_discover.dart';

class DiscoverPage extends StatefulWidget {
  final HomePageModel? homePageModel;
  const DiscoverPage({
    Key? key,
    this.homePageModel,
  }) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> with SingleTickerProviderStateMixin{

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    DiscoverContent.initContext(context: context);
    super.initState();
    AppServices.noInternetConnection(context: context);

    initDefiList();
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return DiscoverPageBody(
      homePageModel: widget.homePageModel,
      searchController: _searchController
    );
  }
}