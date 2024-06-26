
class Review {
  final int id;
  final int userId;
  final int businessId;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  int upvotes;
  int downvotes;

  Review({
    required this.id,
    required this.userId,
    required this.businessId,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.upvotes,
    required this.downvotes,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['user'],
      businessId: json['business'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      upvotes: json['upvotes'],
      downvotes: json['downvotes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'business': businessId,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'upvotes': upvotes,
      'downvotes': downvotes,
    };
  }
}
