(ns silentvoicesbible.books
  (:use clojure.test)
  (:require [net.cgrand.enlive-html :as html])
  (:require silentvoicesbible.gender)
  (:require feminizer.core))

(defprotocol Translatable
  (translated [this]))

(defrecord Book [name, verses])
(defrecord Verse [chapter verse text]
  Translatable
  (translated [this] (feminizer.core/feminize (:text this))))

(def booklist (sorted-map
  "et01" "Genesis"
  "et02" "Exodus"
  "et03" "Leviticus"
  "et04" "Numbers"
  "et05" "Deuteronomy"
  "et06" "Joshua"
  "et07" "Judges"
  "et08" "Samuel"
  "et09" "Kings"
  "et10" "Isaiah"
  "et11" "Jeremiah"
  "et12" "Ezekiel"
  "et13" "Hosea"
  "et14" "Joel"
  "et15" "Amos"
  "et16" "Obadiah"
  "et17" "Jonah"
  "et18" "Micah"
  "et19" "Nahum"
  "et20" "Habakkuk"
  "et21" "Zephaniah"
  "et22" "Haggai"
  "et23" "Zechariah"
  "et24" "Malachi"
  "et25" "Chronicles"
  "et26" "Psalms"
  "et27" "Job"
  "et28" "Proverbs"
  "et29" "Ruth"
  "et30" "Song of Songs"
  "et31" "Ecclesiastes"
  "et32" "Lamentations"
  "et33" "Esther"
  "et34" "Daniel"
  "et36_ezra" "Ezra"
  "et37_nehemiah" "Nehemiah"
 ))


(defn- text [filename]
  (html/text
    (first
      (html/select
        (html/html-resource (java.io.File. (str "../et/" filename ".htm")))
        [:body]))))

(defn- lines [filename]
  (rest
    (filter
      #(< 0 (count %))
      (clojure.string/split (text filename) #"\n"))))

(defn- parse-verse [line]
  (apply ->Verse (rest (re-find #"^(\d+),(\d+) (.*)$" line))))

(defn- book [[filename name]]
  (->Book name (map parse-verse (lines filename))))

(def tanakh (map book (seq booklist)))


(deftest test-books
  (feminizer.core/learn "man" "woman")
  (testing "tanakh books"
    (is (= "Genesis" (:name (first tanakh))))
    (is (= "Nehemiah" (:name (last tanakh))))
  )
  (testing "tanakh verse"
    (let [text (:text (first (:verses (first tanakh))))]
      (is (= "In the beginning God created the heaven and the earth." text)))
    (let [text (:text (first (:verses (nth tanakh 26))))]
      (is (= "There was a man in the land of Uz, whose name was Job; and that man was whole-hearted and upright, and one that feared God, and shunned evil." text)))
  )
  (testing "tanakh translated verse"
    (let [text (.translated (first (:verses (nth tanakh 26))))]
      (is (= "There was a woman in the land of Uz, whose name was Job; and that woman was whole-hearted and upright, and one that feared God, and shunned evil." text)))
  )
)
