(ns feminizer.core
  (:use [clojure.string :only [split split-lines join]])
  (:use clojure.test)
  (:gen-class
    :name com.feminizer
    :methods [
      #^{:static true} [learn    [String String] void]
      #^{:static true} [forget   [String String] void]
      #^{:static true} [feminize [String] String]
    ]))

(def _replace clojure.string/replace) ; how to do this with :use without warnings?

(def word-boundary "[^a-zA-Z-]")
(def loose-regex (ref #""))
(def tight-regex (ref #""))
(def forms (ref {}))

(defn- case-fix [found replaced]
  (if (re-find #"[A-Z]" (str (first found)))
    (str (.toUpperCase (str (first replaced))) (join (rest replaced)))
    replaced))

(def swap-form (fn [[case-sensitive-match & _]]
  (case-fix case-sensitive-match (@forms (.toLowerCase case-sensitive-match)))))

(defn- set-regexes []
  (ref-set loose-regex
           (re-pattern (str "(?i)"
                            (join "|"
                                  (map #(str word-boundary % word-boundary)
                                       (keys @forms))))))
  (ref-set tight-regex
           (re-pattern (str "(?i)"
                            (join "|"
                                  (map #(str "(" % ")")
                                       (keys @forms)))))))

(defn learn [form replacement]
  (dosync
    (alter forms assoc form replacement)
    (set-regexes)))

(defn forget [form]
  (dosync
    (alter forms dissoc form)
    (set-regexes)))

; define bootstrap forms (so the operations don't throw error)
(learn "_not_empty" "_not_empty")

(defn- feminize-line [text]
  (if (re-find #"^\s*$" text)
      text ; don't try to translate blank lines
      (join " " ; do the search & replace in anything between spaces.
        (map
          (fn [match]
            (_replace
              (_replace (str " " match " ") ; normalize string initial/final terms
                        @loose-regex
                        (fn [m]
                          (_replace m
                                    @tight-regex
                                    swap-form)))
              #" (.*) "
              (fn [[_ s]] s))) ; strip normalized whitespace
          (split text #" ")))))

(defn feminize [text]
  (join "\n" (map feminize-line (split text #"\n" -1))))

