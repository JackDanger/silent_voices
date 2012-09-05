(ns silentvoicesbible.html
  (:require clojure.string)
  (:use silentvoicesbible.books))

(def output-directory "_site")
(defn- filename [book]
  (str output-directory "/"
       (clojure.string/replace (:name book) #"[^\d\w-_]" "-")
       ".html"))

(defn- write [book lines]
  (with-open [writer (clojure.java.io/writer (filename book))]
    (doseq [line lines] (.write writer line))))

(defn- home [])

(defn- book-html [book]
  (concat ["<h2>" (:name book) "</h1>"]
       (map #(str (.html %) " ") (.verses book))))

(defn generate [args]
  (home)
  (doseq [b tanakh] (write b (book-html b))))
