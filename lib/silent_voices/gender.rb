module SilentVoices
  module Gender
    def self.forms
      common.merge(names)
    end
    def self.common
      {
        'man' =>         'woman',
        'men' =>         'women',
        'manhood' =>     'womanhood',
        'male' =>        'female',
        'patriarch' =>   'matriarch',
        'patrimony' =>   'matrimony',
        'boy' =>         'girl',
        'boys' =>        'girls',
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