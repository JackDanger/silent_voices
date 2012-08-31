(ns feminizer.core
  (:use [clojure.string :only [split join]])
  (:use clojure.test)
  (:gen-class
    :name com.feminizer
    :methods [
      #^{:static true} [learn    [String String] void]
      #^{:static true} [forget   [String String] void]
      #^{:static true} [feminize [String] String]
    ]))

(def _replace clojure.string/replace) ; how to do this with :use without warnings?

(def word-boundary "[ ,.;'\"(){}]")
(def loose-regex (ref #""))
(def tight-regex (ref #""))
(def forms (ref {}))

(defn- set-regexes []
  (ref-set loose-regex
           (re-pattern (join "|"
                             (map #(str word-boundary % word-boundary)
                                  (keys @forms)))))
  (ref-set tight-regex
           (re-pattern (join "|"
                             (map #(str "(" % ")")
                                  (keys @forms))))))

(defn learn [form replacement]
  (dosync
    (alter forms assoc form replacement)
    (set-regexes)))

(defn forget [& all]
  (dosync
    (map #(alter forms dissoc %) all)
    (set-regexes)))

(defn feminize [text]
  (_replace
    (_replace (str " " text " ") ; normalize string initial/final terms
              @loose-regex
              (fn [match]
                (_replace match
                          @tight-regex
                          (fn [[exact-match & _]]
                            (@forms exact-match)))))
    #" (.*) "
    (fn [[_ s]] s))) ; strip normalized whitespace


(deftest t
  (testing "learn"
    (is (=           "she's got testes, not ovaries"
           (feminize "he's got testes, not ovaries")))
    (learn "testes" "ovaries")
    (is (=           "she's got ovaries, not ovaries"
           (feminize "he's got testes, not ovaries")))
    (learn "ovaries" "testes")
    (is (=           "she's got ovaries, not testes"
           (feminize "he's got testes, not ovaries")))
    (is (= "she's got ovaries, not testes" (feminize (feminize "she's got ovaries, not testes")))))

  (testing "forget"
    (is (=           "this lady is crazy for that gentleman"
           (feminize "this gentleman is crazy for that lady")))
    (forget "lady" "gentleman")
    (is (=           "this lady is crazy for that gentleman"
           (feminize "this lady is crazy for that gentleman")))))

