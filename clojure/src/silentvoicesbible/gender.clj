(ns silentvoicesbible.gender
  (:require feminizer.core)
  (:use feminizer.forms))

(defn setup []
  (learn-from "resources/default.forms")
  (learn-from "resources/tanakh.forms"))
