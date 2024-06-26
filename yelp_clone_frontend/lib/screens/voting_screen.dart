
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VotingScreen extends StatefulWidget {
  @override
  _VotingScreenState createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  List<Map<String, dynamic>> _competitors = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchCompetitors();
  }

  Future<void> _fetchCompetitors() async {
    final response = await http.get(Uri.parse('http://your-backend-url/api/competitors/'));
    if (response.statusCode == 200) {
      setState(() {
        _competitors = List<Map<String, dynamic>>.from(json.decode(response.body));
        _loading = false;
      });
    } else {
      throw Exception('Failed to load competitors');
    }
  }

  void _vote(int businessId) async {
    final response = await http.post(
      Uri.parse('http://your-backend-url/api/vote/'),
      body: json.encode({'business_id': businessId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vote submitted!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit vote')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voting'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _competitors.length,
              itemBuilder: (context, index) {
                final competitor = _competitors[index];
                return ListTile(
                  title: Text(competitor['name']),
                  subtitle: Text('Rating: ${competitor['rating']}'),
                  trailing: ElevatedButton(
                    onPressed: () => _vote(competitor['id']),
                    child: Text('Vote'),
                  ),
                );
              },
            ),
    );
  }
}
