(ns silentvoicesbible.html
  (:use silentvoicesbible.books))

(def output-directory "site")

(defn- home [])

(defn- book [book]
  (println (:name book))
  (let [verse (first (.verses book))]
    (println (:volume verse) (:chapter verse) (:number verse))
    (println (.text (first (.verses book))))))

(defn generate [args]
  (home)
  (doseq [b tanakh] (book b)))
