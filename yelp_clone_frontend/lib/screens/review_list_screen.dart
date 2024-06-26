
import 'package:flutter/material.dart';
import '../models/review.dart';
import '../services/api_service.dart';
import '../widgets/review_card.dart';

class ReviewListScreen extends StatefulWidget {
  @override
  _ReviewListScreenState createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  List<Review> reviews = [];

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  fetchReviews() async {
    // Fetch reviews from API
    // Assuming you have a method to fetch reviews in your ApiService
    // reviews = await ApiService().getReviews();
    setState(() {
      reviews = [
        Review(id: 1, userId: 1, businessId: 1, comment: 'Great place!', createdAt: DateTime.now(), updatedAt: DateTime.now(), upvotes: 10, downvotes: 2),
        // Add more mock reviews or fetch from API
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return ReviewCard(review: reviews[index]);
        },
      ),
    );
  }
}
