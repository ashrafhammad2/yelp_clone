
import 'package:flutter/material.dart';
import '../models/review.dart';
import '../services/api_service.dart';

class ReviewCard extends StatefulWidget {
  final Review review;

  ReviewCard({required this.review});

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _isVoting = false;

  void _vote(String voteType) async {
    setState(() {
      _isVoting = true);
    });

    try {
      await ApiService().voteReview(widget.review.id, voteType);
      setState(() {
        if (voteType == 'upvote') {
          widget.review.upvotes += 1;
        } else if (voteType == 'downvote') {
          widget.review.downvotes += 1;
        }
      });
    } catch (e) {
      // Handle error
      print(e);
    } finally {
      setState(() {
        _isVoting = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.review.comment),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.thumb_up),
                onPressed: _isVoting ? null : () => _vote('upvote'),
              ),
              Text('${widget.review.upvotes}'),
              IconButton(
                icon: Icon(Icons.thumb_down),
                onPressed: _isVoting ? null : () => _vote('downvote'),
              ),
              Text('${widget.review.downvotes}'),
            ],
          ),
        ],
      ),
    );
  }
}
