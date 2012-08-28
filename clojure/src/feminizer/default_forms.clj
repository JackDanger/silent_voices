(ns feminizer.default_forms
  (:require clojure.string))

(def _forms
"man woman
men women
manhood womanhood
male female
males females
bride bridegroom
bridesmaids groomsmen
bondservant bondmaid
bondservants bondmaids
houseboy handmaid
houseboys handmaids
butlers maids
manservant maiden
manservants maidens
menservant maidservant
menservants maidservants
patriarch matriarch
patrimony matrimony
boy girl
boys girls
son daughter
sons daughters
he she
his hers
him her
himself herself
foreskin vulva
adulteress adulterer
adulteresses adulterers
widow widower
prostitute philanderer
prostitutes philanderers
craftsman craftswoman
watchman watchwoman
watchmen watchwomen
prophet prophetess
priest priestess
husband wife
husbands wives
fishermen fisherwomen
kinsman kinswoman
nobleman noblewoman
lord domina
lords dominas
gentleman lady
gentlemen ladies
prince princess
princes princesses
king queen
kings queens
father mother
fathers mothers
brother sister
brothers sisters"
)


(defn forms []
  (clojure.string/split _forms #"[\n ]+"))
