
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/business.dart';
import '../models/order.dart';
import '../models/poll.dart';
import '../models/review.dart';

class ApiService {
  final String baseUrl = 'http://yourbackendapi.com/api';

  Future<List<Business>> getBusinesses({String category = ''}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/businesses/?category=$category'),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((business) => Business.fromJson(business)).toList();
    } else {
      throw Exception('Failed to load businesses');
    }
  }

  Future<void> createOrder(Order order) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(order.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create order');
    }
  }

  Future<List<Poll>> getPolls() async {
    final response = await http.get(Uri.parse('$baseUrl/polls/'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((poll) => Poll.fromJson(poll)).toList();
    } else {
      throw Exception('Failed to load polls');
    }
  }

  Future<void> vote(int pollId, int optionId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/polls/$pollId/vote/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'option_id': optionId}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to cast vote');
    }
  }

  Future<void> postReview(Map<String, dynamic> reviewData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reviews/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(reviewData),
    );
    if (response.statusCode != 201) {
      final responseBody = jsonDecode(response.body);
      throw Exception(responseBody['error'] ?? 'Failed to post review');
    }
  }

  Future<void> voteReview(int reviewId, String voteType) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reviews/$reviewId/vote/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'vote_type': voteType}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to vote on review');
    }
  }
}
