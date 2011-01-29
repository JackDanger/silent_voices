module SilentVoices
  module Gender
    def self.forms
      common.merge(names)
    end
    def self.common
      {
        'man' =>         'woman',
        'men' =>         'women',
        'manly' =>       'womanly',
        'manliness' =>   'womanliness',
        'manlier' =>     'womanlier',
        'manliest' =>    'womanliest',
        'manhood' =>     'womanhood',
        'manvotional' => 'womanvotional',
        'masculine' =>   'feminine',
        'masculinity' => 'femininity',
        'male' =>        'female',
        'patriarch' =>   'matriarch',
        'mr.' =>         'ms.',
        'boy' =>         'girl',
        'boys' =>        'girls',
        'guy' =>         'gal',
        'guys' =>        'gals',
        'dude' =>        'lady',
        'dudes' =>       'ladies',
        'he' =>          'she',
        'his' =>         'her',
        'him' =>         'her',
        'himself' =>     'herself',
        'waitress' =>    'waiter',
        'waitressed' =>  'waited',
        'craftsman' =>   'craftswoman',
        'nobleman' =>    'noblewoman',
        'gentleman' =>   'lady',
        'gentlemen' =>   'ladies',
        'prince' =>      'princess',
        'princes' =>     'princesses',
        'king' =>        'queen',
        'kings' =>       'queens',
        'sissy' =>       'boyish',
        'emasculate' =>  'defeminize',
        'cowboy' =>      'cowgirl',
        'cowboying' =>   'cowgirling',
        'cowboys' =>     'cowgirls',
        'dad' =>         'mom',
        'daddy' =>       'mommy',
        'dick' =>        'pussy',
        'ex-wife' =>     'ex-husband',
        'father' =>      'mother',
        'fathers' =>     'mothers',
        'brother' =>     'sister',
        'brothers' =>    'sisters',
        'Matt' =>        'Mattie',
        'David' =>       'Davida',
        'Paul' =>        'Paula'
      }
    end
    def self.names
      {
        'Jesus' => 'Jesas'
      }
    end
  end
end