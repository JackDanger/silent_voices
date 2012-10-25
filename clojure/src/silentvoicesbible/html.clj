(ns silentvoicesbible.html
  (:require clojure.string)
  (:use silentvoicesbible.books)
  (:use clostache.parser))

(def output-directory "_site")

(defn- filename [book]
  (clojure.string/replace (.toLowerCase (:name book))
                           #"[^\d\w-_]"
                           "-"))

(defn- write-to [path lines]
  (print ".")
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

(defn- book-html [book args]
  (let [translation (str (or (nfirst (mapcat #(re-seq #"--translation=([\w]+)" %) args))
                              "feminized"))]
    (concat ["<h2>" (:name book) "</h1>"]
         (map #(str (.html % translation) " ") (.verses book)))))

(defn generate [args]
  (index)
  (doseq [book tanakh]
    (write-to (str output-directory "/" (filename book) ".html")
              (book-html book args))))

;(println (render-resource "templates/index.mustache" {:title "Tanakh"}))
