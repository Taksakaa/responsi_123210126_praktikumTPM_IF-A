import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TeamDetailPage extends StatefulWidget {
  final int leagueId;
  final int teamId;

  TeamDetailPage({required this.leagueId, required this.teamId});

  @override
  _TeamDetailPageState createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  Map<String, dynamic> _team = {};
  bool _isLoading = true;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchTeam();
  }

  Future<void> _fetchTeam() async {
    final response = await http.get(Uri.parse(
        'https://go-football-api-v44dfgjgyq-et.a.run.app/${widget.leagueId}/${widget.teamId}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _team = data['Data'];
        _isLoading = false;
      });
    } else {
      // Handle error (e.g., show error message)
      print('Error fetching team: ${response.statusCode}');
    }
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite
            ? 'Berhasil menambahkan ke favorit'
            : 'Berhasil menghapus favorit'),
        backgroundColor: _isFavorite ? Colors.green : Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Detail Tim',
            style: TextStyle(color: Colors.white),
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_team['LogoClubUrl'] != null)
                Image.network(
                  _team['LogoClubUrl'],
                  height: 320,
                  width: 320,
                ),
              SizedBox(height: 16),
              Text(
                _team['NameClub'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Stadium: ${_team['StadiumName']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                'Captain Name: ${_team['CaptainName']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Head Coach: ${_team['HeadCoach']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Logo Club'),
                          content: Image.network(_team['LogoClubUrl']),
                        );
                      },
                    );
                  },
                  child: Text(
                    'Show Logo',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFavorite,
        backgroundColor: _isFavorite ? Colors.red : Colors.blue,
        child: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.white,
        ),
      ),
    );
  }
}
