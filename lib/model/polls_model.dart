class PollsQuestionModel {
  int? id;
  int? pollId;
  String? title;
  String? poll;
  int? totalVoteCount;
  int? isVote;

  List<PollQuestionOption>? pollQuestionOption;

  PollsQuestionModel(
      {this.id,
        this.pollId,
        this.title,
        this.poll,
        this.totalVoteCount,
        this.isVote,
        this.pollQuestionOption});

  PollsQuestionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pollId = json['poll_id'];
    title = json['title'];
    poll = json['poll'];
    totalVoteCount = json['total_vote_count'];
    isVote = json['is_vote'];

    if (json['pollQuestionOption'] != null) {
      pollQuestionOption = <PollQuestionOption>[];
      json['pollQuestionOption'].forEach((v) {
        pollQuestionOption!.add(PollQuestionOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['poll_id'] = pollId;
    data['title'] = title;
    data['poll'] = poll;
    data['total_vote_count'] = totalVoteCount;
    data['is_vote'] = isVote;

    if (pollQuestionOption != null) {
      data['pollQuestionOption'] = pollQuestionOption!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PollQuestionOption {
  int? id;
  int? questionId;
  String? title;
  int? totalOptionVoteCount;


  PollQuestionOption({
        this.id,
        this.questionId,
        this.title,
        this.totalOptionVoteCount
      });

  PollQuestionOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionId = json['question_id'];
    title = json['title'];
    totalOptionVoteCount = json['total_option_vote_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['question_id'] = questionId;
    data['title'] = title;
    data['total_option_vote_count'] = totalOptionVoteCount;
    return data;
  }
}