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
        'craftsman' =>   'craftswoman',
        'nobleman' =>    'noblewoman',
        'gentleman' =>   'lady',
        'gentlemen' =>   'ladies',
        'prince' =>      'princess',
        'princes' =>     'princesses',
        'king' =>        'queen',
        'kings' =>       'queens',
        'sissy' =>       'boyish',
        'father' =>      'mother',
        'fathers' =>     'mothers',
        'brother' =>     'sister',
        'brothers' =>    'sisters',
      }
    end
    def self.names
      {
        'Matt' =>        'Matta',
        'David' =>       'Davia',
        'Paul' =>        'Paula',
        'Jesus' =>       'Jesas'
      }
    end
  end
end