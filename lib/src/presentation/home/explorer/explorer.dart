import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/discover_m.dart';
import 'package:wallet_apps/src/presentation/home/explorer/body_explorer.dart';

class ExplorerPage extends StatefulWidget {
  final HomePageModel? homePageModel;
  const ExplorerPage({
    Key? key,
    this.homePageModel,
  }) : super(key: key);

  @override
  State<ExplorerPage> createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> with SingleTickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    DiscoverContent.initContext(context: context);
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    AppServices.noInternetConnection(context: context);
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