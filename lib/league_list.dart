import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'team_list.dart'; // Import team_list.dart

class LeagueListPage extends StatefulWidget {
  @override
  _LeagueListPageState createState() => _LeagueListPageState();
}

class _LeagueListPageState extends State<LeagueListPage> {
  List<dynamic> _leagues = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLeagues();
  }

  Future<void> _fetchLeagues() async {
    final response = await http
        .get(Uri.parse('https://go-football-api-v44dfgjgyq-et.a.run.app/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _leagues = data['Data'];
        _isLoading = false;
      });
    } else {
      // Handle error (e.g., show error message)
      print('Error fetching leagues: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text('Competiball',
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                          Container(
                            child: Text('A football application',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 2,
            color: Colors.grey[300],
          ),
          // ListView
          Expanded(
            child: ListView.builder(
              itemCount: _leagues.length,
              itemBuilder: (context, index) {
                final league = _leagues[index];
                return Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TeamListPage(leagueId: league['idLeague']),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Row(
                          children: [
                            // Kolom kiri untuk logo liga
                            Container(
                              height: 70,
                              width: 70,
                              child: league['logoLeagueUrl'] != null
                                  ? Image.network(league['logoLeagueUrl'])
                                  : Container(),
                            ),
                            // Kolom kanan untuk menampilkan nama liga, negara, dan posisi pemimpin standings
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 22.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(league['leagueName'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 5),
                                    Text(league['country'],
                                        style: TextStyle(fontSize: 16)),
                                    SizedBox(height: 5),
                                    Text(
                                        'Top Table: ${league['leaderStandings']}',
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
