class ChatbotResponse {
  String? answer;
  List<String>? recommendation;

  ChatbotResponse({this.answer, this.recommendation});

  ChatbotResponse.fromJson(Map<String, dynamic> json) {
    answer = json['answer'];
    recommendation = json['recommendation'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer'] = this.answer;
    data['recommendation'] = this.recommendation;
    return data;
  }
}