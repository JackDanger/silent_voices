(ns silentvoicesbible.books
  (:use clojure.test)
  (:use silentvoicesbible.jps)
  (:require [net.cgrand.enlive-html :as html])
  (:require feminizer.core))

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
  "et35" "Ezra / Nehemiah"
))

(defprotocol JPSFormatted
  (html [this])
  (text [this]))
(defprotocol Chaptered
  (verse [this idx])
  (verses [this]))

(defrecord Book [name chapters]
  Chaptered
  (verse [this idx]
    "Lookup a passage in a book by chapter/verse"
    (if (= 2 (count idx))
      (.verse this [nil (first idx) (second idx)]) ; 'volume' is an optional argument
      (let [[volume chapter number] idx]
        (some
          #(if (= [  volume       chapter       number]
                  [(:volume %1) (:chapter %1) (:number %1)])
               %1)
          (.verses this)))))
  (verses [this]
    (flatten (map :verses (:chapters this)))))

(defrecord Chapter [number verses])
(defrecord Verse [volume chapter number source]
  JPSFormatted
  (html [this] (feminizer.core/feminize (jps-html (:source this))))
  (text [this] (feminizer.core/feminize (jps-text (:source this)))))

(defn- book-text [filename]
  (html/text
    (first
      (html/select
        (html/html-resource (java.io.File. (str "../et/" filename ".htm")))
        [:body]))))

(defn- lines [filename]
  (rest
    (filter
      #(< 0 (count %))
      (clojure.string/split (book-text filename) #"\n"))))

(defn- parse-verse [line]
  (try
    (let [parts (drop 2 (re-find #"^(([12EN]).)?(\d+),(\d+) (.*)$" line))]
      (let [source (last parts)       ; we want hapter/verse to be integers
            index  (take 3 parts)]
        (apply ->Verse (concat index [source]))))
    (catch Exception e (prn (str line "\n" e)))))

(defn- chapter [verses]
  (->Chapter (:chapter (first verses)) verses))

(defn- book [[filename name]]
  (->Book name (map chapter (partition-by :chapter (map parse-verse (lines filename))))))


; this defines the entire lazily-loaded bible object
(def tanakh (map book (seq booklist)))

