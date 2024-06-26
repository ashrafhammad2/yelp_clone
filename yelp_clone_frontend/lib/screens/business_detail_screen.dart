
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BusinessDetailScreen extends StatefulWidget {
  final int businessId;

  BusinessDetailScreen({required this.businessId});

  @override
  _BusinessDetailScreenState createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen> {
  Map<String, dynamic>? _businessDetails;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchBusinessDetails();
  }

  Future<void> _fetchBusinessDetails() async {
    final response = await http.get(Uri.parse('http://your-backend-url/api/businesses/${widget.businessId}/'));
    if (response.statusCode == 200) {
      setState(() {
        _businessDetails = json.decode(response.body);
        _loading = false;
      });
    } else {
      throw Exception('Failed to load business details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Details'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_businessDetails!['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(_businessDetails!['description']),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Implement ordering functionality
                    },
                    child: Text('Order Now'),
                  ),
                ],
              ),
            ),
    );
  }
}
