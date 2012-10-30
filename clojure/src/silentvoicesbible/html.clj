(ns silentvoicesbible.html
  (:require clojure.string
            [silentvoicesbible.books :refer :all]
            [clostache.parser :refer :all]))

(def output-directory "_site")

(defn- filename [book]
  (str (clojure.string/replace (.toLowerCase (:name book))
                               #"[^\d\w-_]"
                               "-") ".html"))

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
            (map #(str "<li><a href=" (filename %1) ">"
                       (:name %1)
                       "</a></li>")
                 tanakh)
            ["<ul>"])))

(defn- book-str [book translation medium]
  (render-resource "templates/index.mustache"
                   {:title (:name book)
                    :cs [{:verses [{:html "<>"}]}]
                    :columns
                      (let [vs (for [v (.verses book)] (assoc v :html (.html v translation)))]
                        (for [cols (partition (/ (count vs) 2) vs)] {:verses cols }))
                    :current-page (filename book)}))

(defn generate [args]
  (time
    (let [translation (str (or (nfirst (mapcat #(re-seq #"--translation=([\w]+)" %) args))
                                "feminized"))]
      (.exec (Runtime/getRuntime) "ln -fs ../resources/assets _site/assets")
      (index)
      (doseq [book tanakh]
        (write-to (str output-directory "/" (filename book))
                  [(book-str book translation "html")])))))
