(ns feminizer.core
  (:use [clojure.string :only [split join replace]])
  (:use clojure.test))

(defn pairs [file]
  (map #(split % #",") (split (slurp file) #"\n")))

(def default-forms (pairs "src/feminizer/default.forms"))
(def default-form-map
  (reduce (fn [map pair]
            (assoc map (first pair) (last  pair)
                       (last  pair) (first pair)))
          {}
          default-forms))

(def form-map default-form-map)

(def feminize-regexp
  (re-pattern (join "|" (keys form-map))))


(defn feminize [text]
  (replace text feminize-regexp form-map))

(testing "feminize"
  (testing "with default forms"
    (is (= (feminize "a man, (king) is not a woman or a queen")
                     "a woman, (queen) is not a man or a king"))))

