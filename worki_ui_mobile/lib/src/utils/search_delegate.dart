import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/providers/user_provider.dart';
import 'package:worki_ui/src/values/colors.dart';

class DataSearch extends SearchDelegate {
  final jobs = [];
  String selected = '';
  FirebaseProvider firebaseProvider = new FirebaseProvider();
  UserProvider userProvider = new UserProvider();
  final oCcy = new NumberFormat("#,##0", "en_US");

  final jobsProvider = new JobsProvider();
  final companyProvider = new CompanyProvider();
  Company company;

  User user;

  DataSearch(this.user) {
    user = this.user;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    if (query.isEmpty) return Container();

    return FutureBuilder(
      future: jobsProvider.searchJob(query),
      builder: (BuildContext context, AsyncSnapshot<List<Job>> snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          return ListView(
              children: jobs.map((job) {
            return ListTile(
              leading: FadeInImage(
                image: NetworkImage(job.jobPic),
                placeholder: AssetImage('assets/no-image.png'),
                width: 50.0,
                fit: BoxFit.contain,
              ),
              title: Text(job.name),
              subtitle: Text(job.salary.toString()),
              onTap: () {
                close(context, null);
                //job.uniqueId = '';
                Navigator.of(context).pushNamed('jobDetails',
                    arguments: {'job': job, 'user': user});
              },
            );
          }).toList());
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias
    if (query.isEmpty) return Container();

    return FutureBuilder(
      future: jobsProvider.searchJob(query),
      builder: (BuildContext context, AsyncSnapshot<List<Job>> snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          return ListView(
              children: jobs.map((job) {
            return ListTile(
              leading: FadeInImage(
                image: NetworkImage(job.jobPic),
                placeholder: AssetImage('assets/no-image.png'),
                width: 50.0,
                fit: BoxFit.contain,
              ),
              title: Text(job.name),
              subtitle: Text('\$' + oCcy.format(double.parse(job.salary.toString())) + ' COP'),
              onTap: () {
                close(context, null);
                //job.uniqueId = '';
                Navigator.of(context).pushNamed('jobDetails',
                    arguments: {'job': job, 'user': user});
              },
            );
          }).toList());
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
