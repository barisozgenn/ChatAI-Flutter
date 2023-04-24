class AIAnswerModel {
  List<String> aiAnswers = const [
    'Let me think for you.',
    'Let me research that for you.',
    'I\'ll look into it and get back to you.',
    'Let me double-check and confirm that information.',
    'Give me a moment to gather my thoughts.',
    'Let me consult my notes/resources and see if I can help.',
    'Let me see if I can find a solution for you.',
    'Let\'s review the facts and see if we can determine the answer.',
    'I\'ll do my best to assist you.',
    'Let\'s collaborate and see if we can come up with a solution together.',
  ];
  String getQuickAnswer() {
    return (aiAnswers.toList()..shuffle()).first;
  }
}
