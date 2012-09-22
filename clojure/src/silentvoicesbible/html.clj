(ns silentvoicesbible.html
  (:require clojure.string)
  (:use silentvoicesbible.books))

(def output-directory "_site")

(defn- filename [book]
  (clojure.string/replace (.toLowerCase (:name book))
                           #"[^\d\w-_]"
                           "-"))
(defn- path [book]
  (str output-directory "/" (filename book) ".html"))

(defn- write-to [path lines]
  (.mkdir (java.io.File. output-directory))
  (with-open [writer (clojure.java.io/writer path)]
    (doseq [line lines] (.write writer line))))

(defn- index []
  (write-to
    (str output-directory "/index.html")
    (concat ["<h1>Silent Voices Tanakh</h1>"]
            ["<ul>"]
            (map #(str "<li><a href=" (filename %1) ".html>"
                       (:name %1)
                       "</a></li>")
                 tanakh)
            ["<ul>"])))

(defn- book-html [book]
  (concat ["<h2>" (:name book) "</h1>"]
       (map #(str (.html %) " ") (.verses book))))

(defn generate [args]
  (index)
  (doseq [b tanakh] (write-to (path b) (book-html b))))
