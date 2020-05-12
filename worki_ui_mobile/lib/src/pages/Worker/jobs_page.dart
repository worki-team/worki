import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/utils/shimmers/company_shimmer_widget.dart';
import 'package:worki_ui/src/utils/shimmers/job_card_shimmer_widget.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:worki_ui/src/widgets/job_card_widget.dart';
import 'package:worki_ui/src/widgets/filter_card_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class JobsPage extends StatefulWidget {
  //final String userId;
  final Worker worker;

  const JobsPage({@required this.worker});

  @override
  _JobsPageState createState() => _JobsPageState(worker: this.worker);
}

class _JobsPageState extends State<JobsPage> {
  Worker worker;
  _JobsPageState({this.worker});
  final jobProvider = new JobsProvider();
  PanelController _panelController = new PanelController();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    print('ON LOADING');
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      maxHeight: 600,
      minHeight: 5,
      backdropEnabled: true,
      //slideDirection: SlideDirection.DOWN,
      controller: _panelController,
      panelBuilder: (ScrollController sc) =>
          _slidingPanel(sc, _panelController),
      borderRadius: BorderRadius.circular(20),
      isDraggable: false,
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropMaterialHeader(backgroundColor: AppColors.workiColor),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 30.0),
            _title(),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Empresas',
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SizedBox(height: 20.0),
            _createCompanies(),
            _builderCompanies(),
            SizedBox(height: 20.0),
            _topJobsContent(),
            _builderJobs()
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        'Búsqueda',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, fontFamily: 'Lato'),
      ),
    );
  }

  Widget _builderCompanies() {
    return Container(
      height: 0,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
    );
  }

  Widget _builderJobs() {
    return FutureBuilder(
        future: jobProvider.getJobs(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          var jobs = snapshot.data;
          if (snapshot.hasData) {
            if(snapshot.data.length == 0){
              return Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset('assets/task_undraw.png', fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                      child: Text(
                      'Estamos trabajando para traerte nuevos trabajos',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    if (index == (jobs.length - 1)) {
                      return Column(
                        children: <Widget>[
                          JobCardWidget(job: jobs[index], user: worker),
                          SizedBox(
                            height: 100,
                          )
                        ],
                      );
                    }
                    return JobCardWidget(job: jobs[index], user: worker);
                  }),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                 
                  for (int i = 0; i < 5; i++) JobCardShimmer(),
                ],
              ),
            );
          }
        });
  }

  Widget _topJobsContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Trabajos',
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                _panelController.open();
              })
        ],
      ),
    );
  }

  Widget _createCompanies() {
    final companyProvider = new CompanyProvider();

    return FutureBuilder(
      future: companyProvider.getCompanies(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _createCompaniesPageView(snapshot.data);
        } else {
          return Container(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                for (int i = 0; i < 6; i++) CompanyShimmer(),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _createCompaniesPageView(List<Company> companies) {
    return SizedBox(
      height: 110.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: PageController(viewportFraction: 0.3, initialPage: 0),
        itemCount: companies.length,
        itemBuilder: (context, i) => _companyCard(companies[i]),
      ),
    );
  }

  Widget _companyCard(Company company) {
    return GestureDetector(
      onTap: () {
        //Navigator.pushNamed(context, 'companyDetails', arguments: company);
        Navigator.pushNamed(context, 'companyDetails',
            arguments: {'company': company, 'user': worker});
      },
      child: Container(
        width: 90,
        child: Column(
          children: <Widget>[
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.workiColor),
                borderRadius: BorderRadius.circular(100),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: FadeInImage(
                  image: company.profilePic != null
                      ? NetworkImage(company.profilePic)
                      : AssetImage('assets/no-image.png'),
                  placeholder: NetworkImage(
                      'https://pecb.com/conferences/wp-content/uploads/2017/10/no-profile-picture.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              company.name,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
        margin: EdgeInsets.only(left: 8.0),
      ),
    );
  }

  Widget _slidingPanel(ScrollController sc, PanelController _panelController) {
    return FilterCardWidget(
        panelController: _panelController, sc: sc, user: worker, push: true);
  }
}
