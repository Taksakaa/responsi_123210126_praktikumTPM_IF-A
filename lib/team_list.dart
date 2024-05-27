import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:responsi_123210126/team_detail.dart';

class TeamListPage extends StatefulWidget {
  final int leagueId;

  TeamListPage({required this.leagueId});

  @override
  _TeamListPageState createState() => _TeamListPageState();
}

class _TeamListPageState extends State<TeamListPage> {
  List<dynamic> _teams = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTeams();
  }

  Future<void> _fetchTeams() async {
    final response = await http.get(Uri.parse(
        'https://go-football-api-v44dfgjgyq-et.a.run.app/${widget.leagueId}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _teams = data['Data'];
        _isLoading = false;
      });
    } else {
      // Handle error (e.g., show error message)
      print('Error fetching teams: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'List Tim',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(12.0), // Add padding to the Container
          child: GridView.builder(
            itemCount: _teams.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio:
                  1.0, // Set the child aspect ratio to 1.0 to make the cells square
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 20.0,
            ),
            itemBuilder: (context, index) {
              final team = _teams[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeamDetailPage(
                        leagueId: widget.leagueId,
                        teamId: team['IdClub'],
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(6.0), // Add margin to the Card
                  child: Padding(
                    padding:
                        const EdgeInsets.all(14.0), // Add padding to the Card
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Center the team name, logo, and stadium
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Tampilkan logo tim (jika tersedia)
                              if (team['LogoClubUrl'] != null)
                                Image.network(team['LogoClubUrl'], height: 55),
                              SizedBox(height: 15),
                              Text(team['NameClub'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text(team['StadiumName'],
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
