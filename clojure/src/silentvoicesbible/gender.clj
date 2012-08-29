(ns silentvoicesbible.gender
  (:use feminizer.core :only [feminize])
  (:use feminizer.forms))

(def tanakh-forms
  (filter
    #(< 0 (count %))
    (clojure.string/split (slurp tanakh-form-file) #"[\n ]+")))

(defn setup []
  (learn-from "resources/default.forms")
  (learn-from "resources/tanakh.forms"))
