(ns silentvoicesbible.core
  (:gen-class)
  (:require silentvoicesbible.html)
  (:require feminizer.forms)
  (:require silentvoicesbible.jps)
  (:use silentvoicesbible.books))

(defn- -gets [prompt]
  (let [reader (java.io.BufferedReader. (java.io.InputStreamReader. (System/in)))]
    (loop [_ nil]
      (print ".")
      (if (.ready reader)
          (.readLine reader)
          (recur (Thread/sleep 10))))))

(defn -main [ & args ]
  (feminizer.forms/learn-from "resources/default.forms")
  (feminizer.forms/learn-from "resources/tanakh.forms")

  (case (first args)
        "generate" (silentvoicesbible.html/generate (rest args))
        (println "USAGE: lein run [browse|generate]")))
