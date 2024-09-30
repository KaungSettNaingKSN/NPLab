import 'model/test_model.dart';

List<Test> getTestData() {
  return [
    Test(
      year: 'TestOne',
      level: 'N5',
      questions: {
        'grammar': [
          Question(
            image: '2024N5-1.png',
            questionText: 'わたしは <u>先月</u> にほんにきました。',
            answers: ['せいげつ', 'せんげつ', 'せんがつ', 'せいがつ'],
            correctAnswerIndex: 1,
          ),
          Question(
            questionText: '<u>ゆうべ：パーティーにいきました。</u>',
            answers: [
              'きのうのひるパーティーにいきました。',
              'きのうのよるパーティーにいきました。',
              'おとといのひるパーティーにいきました。',
              'おとといのよるパーティーにいきました。'
            ],
            correctAnswerIndex: 1,
          ),
        ],
        'reading': [
          Question(
            questionText: 'わたしは <u>先月</u> にほんにきました。',
            answers: ['せいげつ', 'せんげつ', 'せんがつ', 'せいがつ'],
            correctAnswerIndex: 1,
          ),
          Question(
            questionText: '__ __ <u>_*_</u> __ 買います。',
            answers: ['せいげつ', 'せんげつ', 'せんがつ', 'せいがつ'],
            correctAnswerIndex: 1,
          ),
        ],
        'listening': [
          Question(
            image: '2024N5-1.png',
            questionText: '',
            answers: ['せいげつ', 'せんげつ', 'せんがつ', 'せいがつ'],
            correctAnswerIndex: 1,
          ),
          Question(
            questionText: 'わたしは <u>先月</u> にほんにきました。',
            answers: ['せいげつ', 'せんげつ', 'せんがつ', 'せいがつ'],
            correctAnswerIndex: 1,
          ),
          Question(
            questionText:
                'キンさんのんしょう わたしのりょうしんのしゅみはダンスです。ご人はじ学校でダンスを習っています。ご人のダンスのじゅぎょうは曜の朝7時から8時です。愛のしごとは朝9時からですから、ちち 父は、<u>24</u> しごとをします。<u>25</u> いっしょにれんしゅうして います。髪とはダンスが笑好きです。',
            answers: ['せいげつ', 'せんげつ', 'せんがつ', 'せいがつ'],
            correctAnswerIndex: 1,
          ),
          Question(
            image: 'spiderman.png',
            questionText: '',
            answers: ['せいげつ', 'せんげつ', 'せんがつ', 'せいがつ'],
            correctAnswerIndex: 1,
          ),
        ],
      },
    ),
  ];
}
