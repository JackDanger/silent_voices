module SilentVoices
  module Gender
    extend self

    def feminize_text string
      string = Feminizer.feminize_text string
      string = cleanup_her string
      string = fix_singletons string
      string
    end

    def forms
      common.merge names
    end

    def common
      {
        'man' =>          'woman',
        'men' =>          'women',
        'manhood' =>      'womanhood',
        'male' =>         'female',
        'males' =>        'females',
        'bride' =>        'bridegroom',
        'bridesmaids' =>  'groomsmen',
        'bondservant' =>  'bondmaid',
        'bondservants' => 'bondmaids',
        'houseboy' =>     'handmaid',
        'houseboys' =>    'handmaids',
        'butlers' =>      'maids',
        'manservant' =>   'maiden',
        'manservants' =>  'maidens',
        'menservant' =>   'maidservant',
        'menservants' =>  'maidservants',
        'patriarch' =>    'matriarch',
        'patrimony' =>    'matrimony',
        'boy' =>          'girl',
        'boys' =>         'girls',
        'son' =>          'daughter',
        'sons' =>         'daughters',
        'he' =>           'she',
        'his' =>          'hers',
        'him' =>          'her',
        'himself' =>      'herself',
        'foreskin' =>     'vulva',
        'adulteress' =>   'adulterer',
        'adulteresses' => 'adulterers',
        'prostitute' =>   'philanderer',
        'prostitutes' =>  'philanderers',
        'craftsman' =>    'craftswoman',
        'watchman' =>     'watchwoman',
        'watchmen' =>     'watchwomen',
        'prophet' =>      'prophetess',
        'priest' =>       'priestess',
        'husband' =>      'wife',
        'husbands' =>     'wives',
        'fishermen' =>    'fisherwomen',
        'kinsman' =>      'kinswoman',
        'nobleman' =>     'noblewoman',
        'lord' =>         'domina',
        'lords' =>        'dominas',
        'gentleman' =>    'lady',
        'gentlemen' =>    'ladies',
        'prince' =>       'princess',
        'princes' =>      'princesses',
        'king' =>         'queen',
        'kings' =>        'queens',
        'father' =>       'mother',
        'fathers' =>      'mothers',
        'brother' =>      'sister',
        'brothers' =>     'sisters',
      }
    end

    def names
      {
        'Adam' =>         'Ada',
        'Eve' =>          'Evan',
        'Noah' =>         'Noa',
        'Saul' =>         'Saula',
        'David' =>        'Davina',
        'Samuel' =>       'Samantha',
        'Herod'  =>       'Heroda',
        'Simon' =>        'Simona',
        'Peter' =>        'Petra',
        'Joseph' =>       'Josephine',
        'Abram' =>        'Abra',
        'Abraham' =>      'Abrahai',
        'Isaac' =>        'Isaaca',
        'Jacob' =>        'Jacoba',
        'Solomon' =>      'Solomin',
        'Isaiah' =>       'Isaia',
        'Jeremiah' =>     'Jeremia',
        'Abraham' =>      'Abrahai',
        'Daniel' =>       'Danielle',
        'James' =>        'Jamie',
        'Matthew' =>      'Matthia',
        'Levi' =>         'Levia',
        'Luke' =>         'Luca',
        'Mark' =>         'Margaret',
        'Anna' =>         'Andrew',
        'Judas' =>        'Judasie',
        'John' =>         'Johanna',
        'Paul' =>         'Paula'
      }
    end

    def fix_singletons string
      string = string.gsub 'an philanderer', 'a philanderer'
      string = string.gsub 'touches his will', 'touches him will'
      string
    end

    def cleanup_her string
      # The fact that 'her' is the opposite of both 'his' and 'him' is problematic.
      # Cleanup misswaps here
      string.
        sub(/^(\w)/, ' \1').
        gsub(/ in hers/, ' in her').
        gsub(/ of hers/, ' of her').
        gsub(/ ((H|h)im) (#{words_that_only_follow_possesive_pronoun})/i, ' \2is \3'). # 'him' becomes 'his'
        gsub(/ ((H|h)er)s (#{words_that_only_follow_possesive_pronoun})/i, ' \2er \3'). # 'hers' becomes 'her'
        sub(/^ (\w)/, '\1')
    end

    def words_that_only_follow_possesive_pronoun
      %w{(bond|man)?servants? (un)?circumcision abomination abominations accuser acquaintance act adulteries adversaries adversary afflicted affliction age allowance altar ambassador angel anger animal ankle annoyance anointed anointing answer apparel appearing appointed arm armie armor armory army arrogance arrow ascent assemblies attire authority axe back baggage baker bald band banished baptism barn bars battering beard beautiful beauty bed bedstead beginning behalf behavior belly beloved benefit beware birth birthday birthright blasphemy blessing blood boasting bodily body bond bone border bosom bough bound boundless bow bowel bowl branch branche branches bread breast breath brother bucket bull bulwark burden burning burnt cake calamity calf camel captain captive captivity cargo case cause caves celebration censer chamber charge chariot cheek chest chick child childbearing children chosen christ circuit citadel citie cities citizen city cleansing cloak clod close clothes clothing cloud coat cold coming command commandment companion company compassion complaint conception concubine conscience consolation conspiracy contempt continual converts cord corner corpse cosmetics cot counsel counselor country courage course court covenant covert creek cros crown cry cub cubs cup cupbearer cursing custom daughter day days dead death decree deed defense delicacie delight delivery den deputies descendant desert desire desolations destroying destruction device discharge disciple discomfort disease disobedience district divine division doing dominion domina donkey dragnet dread dream dung dust dwelling ear earrings ears eating eggs elder eldest eleven end enemie enemies enemy engraved equal error eternal eunuchs everlasting evil excellency excellent excessive exhorting expectation extraordinary eye eyelids eyes face facial faith fame familiar family farthest fat fatal father fatnes fault favor fear feasts feather feathers feet fellow female field fierce fifteen fifty fig fill finger first firstborn fist flaming flesh flock flower foal fodder fold folly food foolishnes foot force forehead foreign forest form fortress(es)? foundations fountain four fragrance freedom friends? from frontiers fruit fugitive full fullnes furnace gain game garden garment gates? gaze generation gentlemen gift girl gloriou glory god going good governors grace grain grave gray great green grief ground guard guest guests guidance guilt guy guys habitation hail hair handmaids? hands? hard harm harness harvest haunt head healing heart heaven heavenly heavy hedge heel height help helpers? heritage hidden hiding high hire hired holines holy home homeland honorable hope horde horn horse horsemen hour house household humiliation hunger hunting hurt husband idol idols image impurity indignation inhabitants inheritance iniquities iniquity innermost instruments integrity inward jaw jealousy jewelry jewels journey joy judgement judgment justice kindnes king kingly kinswoman knee knees knowledge labor lamp land language lap last latter law leave lee left leg leprosy lewdness life light lightning limb linen lionesse lip lips little livelihood liver livestock living lodging loftines lofty lord lot love lovers loving luxury maid maiden maidens majestic majesty maker male manager manner mantle marital marvelou master mat mate maw meal meat member merchandise mercie mercy messenger midst might mighty mind minister ministry misdeed miseries misery mistress molten money month mother mountain mourner mouth mule multitude nail nails naked nakednes nakedness name native natural neck need neighbor nest net new noble nose nostril number nurse oath occasion offering office offspring old one only ordinance ornaments other outer outstretched own ox oxen pain pains palace palaces pangs parable parched parent part pasture path paths patience pavilion peace people period persecutors petition picked pillar pitcher place plagues pleasant pleasure pledge plowshare policy portion portions position possession posterity poverty power praise prayer precept precious presence prey price pride priest priesthood priests princesse princesses prison privy promise property prophet prophets prostitution protection provision purification purifying purpose quarter queen queendom questions? quiver realm rebuke recompense redeemer refuge reign relative relatives reproach request rest resurrection return revenue reward riches rider right righteousness ring robe rod room roots? rough round royal ruin rust sabbath sack sackcloth sacrifice saint sake salvation sanctuary sash saying scent scorching sea seal seat second secret seed separation servant service seven seventy sexual shade shadow shame share shearer sheave sheep sheepshearer shield shoe shoulder sickbed sickle sicknes side sight sign signet silver sins? sister skin skirts skull slain slaughter sleep sling smoke soldier solemn son sorcerie sore soul span spear speech spirit spittle splendor spoil spots staff star statute step steward stomach stone stones storehouses streets strength strong stronghold substance sucking sun supplication sword table tail talk target taste taxation teacher teaching tears teeth temple ten tent terror testimonies testimony theft thick thicket thigh thorn thought thousands thrashing three threshing throne thumb time tomb tongue tooth top torment towers train trained transgressions? translation travail treacherous treason treasure trespass(es)? tribe tribes tribute trouble trust truth twelve two uncle uncleanness understanding unripe unspeakable unusual upper utterly vapor vault veil venison vessel vines? vineyards? virginity virgins? voice vomit vow wage wages waist walls? war water ways? wheat wealth weapon week weeping whole wicked wickedness widow widowhood wife wilderness will wind window wine wings? wisdom wise witchcraft with within witness woman womb women wonder wonderful wondrous words? work worshipper wounds? wrath writing year yoke young younger youngest youth}.join('|')
    end
  end
end