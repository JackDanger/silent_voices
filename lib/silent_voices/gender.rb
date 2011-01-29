module SilentVoices
  module Gender

    def self.feminize_text string
      string = Feminizer.feminize_text string
      string = cleanup_her string
      string
    end

    def self.forms
      common.merge names
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
        'his' =>         'hers',
        'him' =>         'her',
        'himself' =>     'herself',
        'craftsman' =>   'craftswoman',
        'husband' =>     'wife',
        'husbands' =>    'wives',
        'kinsman' =>     'kinswoman',
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
    def self.cleanup_her string
      # The fact that 'her' is the opposite of both 'his' and 'him' is problematic.
      # Cleanup misswaps here
      string.
        gsub(/him wife/, 'his wife').
        gsub(/of hers /, 'of her ')
    end
  end
end