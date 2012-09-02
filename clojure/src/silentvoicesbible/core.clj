(ns silentvoicesbible.core
  (:gen-class)
  (:require silentvoicesbible.html)
  (:require silentvoicesbible.gender)
  (:require feminizer.core)
  (:require silentvoicesbible.jps)
  (:use silentvoicesbible.books))

(defn- gets [prompt]
  (print prompt)
  (let [reader (java.io.BufferedReader. (java.io.InputStreamReader. (System/in)))]
    (loop [_ nil]
      (if (.ready reader)
          (.readLine reader)
          (recur (Thread/sleep 1))))))

(defn- browse []
  (gets "click any key to start reading the Silent Voices Tanakh")
  (doseq [verse (:verses (first tanakh))]
    (println (.text verse))
    (gets)))

(defn -main [ & args ]
  (silentvoicesbible.gender/setup)

  (let [ecc (nth tanakh 30)]
    (let [source (:source (.verse ecc [3 8]))]
      (println source)
      (println "after source")
      (println (silentvoicesbible.jps/jps-text source))
      (println "after jps")
      (println (feminizer.core/feminize (silentvoicesbible.jps/jps-text source))))
      (println "after feminize")
    (println (.text (.verse ecc [3 8]))))

  (if (= "browse" (first args))
    (browse))
  (if (= "generate" (first args))
    (silentvoicesbible.html/generate (rest args))))
