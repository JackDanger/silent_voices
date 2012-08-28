(ns feminizer.core
  (:use [clojure.string :only [split join]])
  (:use clojure.test)
  (:require feminizer.default_forms)
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

(defn- each-pair [fn pairs]
  (dosync (loop [[male female & more] pairs]
            (alter forms fn male female female male)
            (if more
              (recur more)))
          (set-regexes)))

(defn learn [& pairs]
  (each-pair assoc pairs))

(defn forget [& pairs]
  (each-pair dissoc pairs))

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

; add default forms at load 
(apply learn (feminizer.default_forms/forms))

; export these to Java
(defn -learn    [& args] (apply learn    args))
(defn -forget   [& args] (apply forget   args))
(defn -feminize [& args] (apply feminize args))


(deftest t
  (testing "feminize"
    (testing "with default forms"
      (is (= (feminize "man, (king) is not a woman or a queen.")
                       "woman, (queen) is not a man or a king."))))
  (testing "learn"
    (is (=           "she's got ovaries"
           (feminize "he's got ovaries")))
    (learn "ovaries" "testes")
    (is (=           "she's got ovaries"
           (feminize "he's got testes")))
    (is (= "she's got ovaries" (feminize (feminize "she's got ovaries")))))

  (testing "forget"
    (is (=           "this lady is crazy for that gentleman"
           (feminize "this gentleman is crazy for that lady")))
    (forget "lady" "gentleman")
    (is (=           "this lady is crazy for that gentleman"
           (feminize "this lady is crazy for that gentleman")))))

