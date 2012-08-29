(ns silentvoicesbible.core
  (:require silentvoicesbible.gender)
  (:use silentvoicesbible.books))

(defn -main [ & args ]
  (silentvoicesbible.gender/setup)

  (doall
    (for [book tanakh]
      (doall
        (for [verse (:verses book)]
          (println "\n" (.translated verse))))))
  ""
)
