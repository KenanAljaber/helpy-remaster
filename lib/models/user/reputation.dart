class Reputation {
  int positive;
  int negative;
  int total;

  Reputation(
      {required this.positive, required this.negative, required this.total});

  Reputation.empty()
      : positive = 0,
        negative = 0,
        total = 0;

  Reputation.fromJson(Map<String, dynamic> json) :
    positive = json['positive'],
    negative = json['negative'],
    total = json['total'];
  

  Map<String, dynamic> toJson() {
    return {
      'positive': positive,
      'negative': negative,
      'total': total,
    };
  }
}
