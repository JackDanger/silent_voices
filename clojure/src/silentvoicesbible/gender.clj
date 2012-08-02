(ns silentvoicesbible.gender
  (:require feminizer.core)
  (:use [clojure.string :only [split join]]))

(defn pairs [file]
  (map #(split % #"<->") (split (slurp file) #"\n")))

