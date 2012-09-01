(ns silentvoicesbible.core
  (:require silentvoicesbible.gender)
  (:use silentvoicesbible.books))

(defn -main [ & args ]
  (silentvoicesbible.gender/setup)

  (doall
    (for [verse (:verses (first tanakh))]
      (println (.translated verse))))
)
