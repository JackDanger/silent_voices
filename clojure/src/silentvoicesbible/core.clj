(ns silentvoicesbible.core
  (:gen-class)
  (:require silentvoicesbible.html)
  (:require feminizer.forms)
  (:require silentvoicesbible.jps)
  (:use silentvoicesbible.books))

(defn- -gets [prompt]
  (println "in -gets")
  (println prompt)
  (let [reader (java.io.BufferedReader. (java.io.InputStreamReader. (System/in)))]
    (println "in let")
    (loop [_ nil]
      (print ".")
      (if (.ready reader)
          (.readLine reader)
          (recur (Thread/sleep 10))))))

(defn- browse []
  (println "in browse")
  (-gets "click any key to start reading the Silent Voices Tanakh")
  (doseq [verse (:verses (first tanakh))]
    (print (-gets "") (.text verse))))

(defn -main [ & args ]
  (feminizer.forms/learn-from "resources/default.forms")
  (feminizer.forms/learn-from "resources/tanakh.forms")

  (if (= "browse" (first args))
    (browse))
  (if (= "generate" (first args))
    (silentvoicesbible.html/generate (rest args))))
