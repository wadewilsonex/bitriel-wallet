import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/discover/body_discover.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({ Key? key }) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}



class _DiscoverPageState extends State<DiscoverPage> with SingleTickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
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
      tabController: _tabController,
    );
  }
}