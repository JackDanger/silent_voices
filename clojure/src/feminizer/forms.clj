(ns feminizer.forms
  (:use [clojure.string :only [split split-lines join trim]])
  (:use clojure.test)
  (:use feminizer.core))

(defn- association-map [line]
  (let [[_ primary direction secondary] (re-matches
                                           #"^([-\w]+) *(->)? *([-\w]+)$"
                                           (trim line))]
    (if (and primary secondary)
      (if direction
        {primary secondary}
        {primary secondary, secondary primary})
      {})))

(defn associations [text]
  (reduce conj (map association-map (split-lines text))))

(defn learn-from [file]
  (dorun
    (for [[primary secondary] (associations (slurp file))]
      (learn primary secondary))))
