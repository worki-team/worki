//import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/faces_compare_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/pages/Administrator/facial_comparing_page.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/providers/worker_provider.dart';
import 'package:worki_ui/src/utils/shimmers/job_card_shimmer_widget.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:worki_ui/src/widgets/job_card_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:worki_ui/src/widgets/worker_card_widget.dart';
import 'package:worki_ui/src/widgets/worker_filter_card_widget.dart';

class WorkersPage extends StatefulWidget {
  //final String userId;
  final Administrator admin;

  const WorkersPage({@required this.admin});

  @override
  _WorkersPageState createState() => _WorkersPageState(admin: this.admin);
}

class _WorkersPageState extends State<WorkersPage> {
  Administrator admin;
  _WorkersPageState({this.admin});
  final jobProvider = new JobsProvider();
  PanelController _panelController = new PanelController();
  WorkerProvider workerProvider = new WorkerProvider();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Map<String, dynamic> _arguments;
  Map<String, dynamic> _attributes;
  List<String> criteria = [];

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
    _arguments = ModalRoute.of(context).settings.arguments;
    criteria = [];
    if (_arguments['arguments'] != null) {
      _attributes = _arguments['arguments'];

      if (_attributes['name'] != '') {
        criteria.add('Nombre: ' + _attributes['name']);
      }
      if (_attributes['startAge'] != '18') {
        criteria.add('Edad desde: ' + _attributes['startAge']);
      }
      if (_attributes['endAge'] != '70') {
        criteria.add('Edad hasta: ' + _attributes['endAge']);
      }
      if (_attributes['city'] != '') {
        criteria.add('Ciudad: ' + _attributes['city']);
      }
      if (_attributes['gender'] != 'Todos') {
        criteria.add('Género: ' + _attributes['gender']);
      }
      if (_attributes['language'] != '') {
        criteria.add('Idioma: ' + _attributes['language']);
      }
      if (_attributes['aptitude'] != '') {
        criteria.add('Habilidad: ' + _attributes['aptitude']);
      }
      if (_attributes['contexture'] != '') {
        criteria.add('Contextura: ' + _attributes['contexture']);
      }
      if (_attributes['eyeColor'] != '') {
        criteria.add('Color de Ojos: ' + _attributes['eyeColor']);
      }
      if (_attributes['hairType'] != '') {
        criteria.add('Tipo de Pelo: ' + _attributes['hairType']);
      }
      if (_attributes['hairColor'] != '') {
        criteria.add('Color de Pelo: ' + _attributes['hairColor']);
      }
      if (_attributes['skinColor'] != '') {
        criteria.add('Color de Piel: ' + _attributes['skinColor']);
      }
      if (_attributes['height'] != '') {
        criteria.add('Estatura: ' + _attributes['height']);
      }
      if (_attributes['weight'] != '') {
        criteria.add('Peso: ' + _attributes['weight']);
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _arguments['arguments'] != null
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              iconTheme: IconThemeData(color: AppColors.workiColor),
            )
          : null,
      body: SlidingUpPanel(
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
          header:
              WaterDropMaterialHeader(backgroundColor: AppColors.workiColor),
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
              _attributes == null ? _title() : _searchBy(),
              SizedBox(height: 20.0),
              _topWorkersContent(),
              _builderWorkers()
            ],
          ),
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

  Widget _builderWorkers() {
    return FutureBuilder(
        future: _attributes == null
            ? workerProvider.getWorkers()
            : workerProvider.getFilteredWorkers(_attributes),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            List<Worker> workers = snapshot.data;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: workers.length,
                  itemBuilder: (context, index) {
                    if (index == (workers.length - 1)) {
                      return Column(
                        children: <Widget>[
                          WorkerCardWidget(worker: workers[index], user: admin),
                          SizedBox(
                            height: 100,
                          )
                        ],
                      );
                    }
                    return WorkerCardWidget(
                        worker: workers[index], user: admin);
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

  Widget _topWorkersContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Trabajadores',
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          IconButton(
            icon: Icon(
              Icons.face,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('face_comparing');
            },
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

  Widget _searchBy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20),
          child: Text('Búsqueda por:',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 5,
              children: <Widget>[
                for (int i = 0; i < criteria.length; i++)
                  Chip(
                      label: Text(criteria[i],
                          style: TextStyle(color: Colors.black)),
                      backgroundColor: Colors.black12),
              ],
            )),
      ],
    );
  }

  Widget _slidingPanel(ScrollController sc, PanelController _panelController) {
    return FilterWorkerCardWidget(
        panelController: _panelController,
        sc: sc,
        user: admin,
        push: _attributes == null ? true : false);
  }
}
