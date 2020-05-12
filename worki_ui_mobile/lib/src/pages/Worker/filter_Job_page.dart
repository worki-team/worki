import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/utils/shimmers/job_card_shimmer_widget.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:worki_ui/src/widgets/filter_card_widget.dart';
import 'package:worki_ui/src/widgets/job_card_widget.dart';


class FilterJobPage extends StatefulWidget {
  FilterJobPage({Key key}) : super(key: key);

  @override
  _FilterJobPageState createState() => _FilterJobPageState();
}

class _FilterJobPageState extends State<FilterJobPage> {
  PanelController _panelController = new PanelController();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  var user;
  JobsProvider jobsProvider = new JobsProvider();
  Map<String, dynamic> _arguments;
  Map<String, dynamic> _attributes;
  

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {

    });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    print('ON LOADING');
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    
    setState(() {

    });
    _refreshController.loadComplete();
  }



  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;
    user = _arguments['user'];
    _attributes = _arguments['arguments'];
    List<String> criteria = [];
    if(_attributes['name'] != ''){
      criteria.add('Nombre: '+_attributes['name']);
    }
    if(_attributes['startSalary'] != '20000'){
       criteria.add('Salario desde: '+_attributes['startSalary']);
    }
    if(_attributes['endSalary'] != '999999'){
       criteria.add('Salario hasta: '+_attributes['endSalary']);
    }
    if(_attributes['initialDate'] != ''){
       criteria.add('Fecha inicial: '+_attributes['initialDate']);
    }
    if(_attributes['finalDate'] != ''){
       criteria.add('Fecha final: '+_attributes['finalDate']);
    }
    if(_attributes['duration'] != ''){
       criteria.add('Duración: '+_attributes['duration']);
    }
    if(_attributes['city'] != ''){
       criteria.add('Ciudad: '+_attributes['city']);
    }
    if(_attributes['company'] != ''){
       criteria.add('Empresa: '+_attributes['company']);
    }
    if(_attributes['functions'] != ''){
       criteria.add('Funciones: '+_attributes['functions']);
    }

    print('CRITERIOS: '+criteria.toString());
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Trabajos a tu medida',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        elevation: 0.0,
        iconTheme:  IconThemeData(color: AppColors.workiColor),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list, color: AppColors.workiColor),
            onPressed: (){
              _panelController.open();
            },
          )
        ],

      ),
      body: SlidingUpPanel(
        maxHeight: 500,
        minHeight: 0,
        backdropEnabled: true,
        controller: _panelController,
        panelBuilder: (ScrollController sc) => _slidingPanel(sc, _panelController),
        borderRadius: BorderRadius.circular(20),
        isDraggable: false,
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropMaterialHeader(backgroundColor: AppColors.workiColor),
          footer: CustomFooter(
            builder: (BuildContext context,LoadStatus mode){
              Widget body ;
              if(mode==LoadStatus.idle){
                body =  Text("pull up load");
              }
              else if(mode==LoadStatus.loading){
                body =  CupertinoActivityIndicator();
              }
              else if(mode == LoadStatus.failed){
                body = Text("Load Failed!Click retry!");
              }
              else if(mode == LoadStatus.canLoading){
                  body = Text("release to load more");
              }
              else{
                body = Text("No more Data");
              }
              return Container(
                height: 55.0,
                child: Center(child:body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Text('Búsqueda por:', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                width: MediaQuery.of(context).size.width,
                child: Wrap (
                  direction: Axis.horizontal,
                  spacing: 5,
                  children: <Widget>[
                    for(int i = 0 ; i<criteria.length; i++)
                      Chip(
                        label: Text(criteria[i], style: TextStyle(color: Colors.black)),
                        backgroundColor: Colors.black12
                      ),
                  ],
                )
              ),
              FutureBuilder(
                future: jobsProvider.getFilteredJobs(_attributes),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.hasData){
                    List<Job> jobs = snapshot.data;
                    return ListView.builder(
                      itemCount: jobs.length,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, i){
                        return JobCardWidget(job: jobs[i],user: user,);
                      },
                    );

                  }else{
                    return ListView(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                        for(int i =0; i<4; i++)
                          JobCardShimmer(),
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: 100,),


          ],
        ),
      ),
      )
    );
  }
 

  Widget _slidingPanel(ScrollController sc, PanelController _panelController){
    return FilterCardWidget(panelController: _panelController,sc: sc,user: user,push: false);
  }
}

