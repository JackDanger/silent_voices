(ns feminizer.core
  (:use [clojure.string :only [split join replace]]))

(defn pairs [file]
  (map #(split % #",") (split (slurp file) #"\n")))

(def default-forms (pairs "src/feminizer/default.forms"))
(def default-form-map
  (reduce (fn [map pair]
            (assoc map (first pair) (last  pair)
                       (last  pair) (first pair))) {} default-forms))

(println (default-form-map "man"))

(def form-map default-form-map)

(def feminize-regexp
  (re-pattern (join "|" (keys form-map))))


(defn feminize [text]
  (replace text feminize-regexp form-map))

(println (feminize "a man, (king) is not a woman or a queen"))
