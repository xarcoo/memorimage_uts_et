class Question {
  String option_a;
  String option_b;
  String option_c;
  String option_d;
  String answer;

  Question(
      this.option_a, this.option_b, this.option_c, this.option_d, this.answer);
}

var questions = <Question>[
  Question(
    'https://loremflickr.com/320/240/cake?lock=1',
    'https://loremflickr.com/320/240/cake?lock=2',
    'https://loremflickr.com/320/240/cake?lock=3',
    'https://loremflickr.com/320/240/cake?lock=4',
    'https://loremflickr.com/320/240/cake?lock=1',
  ),
  Question(
    'https://loremflickr.com/320/240/cat?lock=4',
    'https://loremflickr.com/320/240/cat?lock=3',
    'https://loremflickr.com/320/240/cat?lock=1',
    'https://loremflickr.com/320/240/cat?lock=2',
    'https://loremflickr.com/320/240/cat?lock=2',
  ),
  Question(
    'https://loremflickr.com/320/240/dog?lock=3',
    'https://loremflickr.com/320/240/dog?lock=4',
    'https://loremflickr.com/320/240/dog?lock=1',
    'https://loremflickr.com/320/240/dog?lock=2',
    'https://loremflickr.com/320/240/dog?lock=3',
  ),
  Question(
    'https://loremflickr.com/320/240/car?lock=1',
    'https://loremflickr.com/320/240/car?lock=2',
    'https://loremflickr.com/320/240/car?lock=3',
    'https://loremflickr.com/320/240/car?lock=4',
    'https://loremflickr.com/320/240/car?lock=4',
  ),
  Question(
    'https://loremflickr.com/320/240/building?lock=2',
    'https://loremflickr.com/320/240/building?lock=3',
    'https://loremflickr.com/320/240/building?lock=4',
    'https://loremflickr.com/320/240/building?lock=5',
    'https://loremflickr.com/320/240/building?lock=5',
  ),
];
