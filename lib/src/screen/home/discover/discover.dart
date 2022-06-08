import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/discover_m.dart';
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

  late TabController _tabController;

  @override
  void initState() {
    DiscoverContent.initContext(context: context);
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return DiscoverPageBody(
      homePageModel: widget.homePageModel,
      tabController: _tabController,
    );
  }
}