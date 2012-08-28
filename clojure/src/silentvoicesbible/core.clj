(ns silentvoicesbible.core
  (:use silentvoicesbible.books))

(defn -main [ & args ]
  (println (:name (last tanakh)))
  (doall
    (for [verse (take 20 (:verses (last tanakh)))]
      (println "\n" (.text verse) "\n" (.translated verse))))
  ""
)
