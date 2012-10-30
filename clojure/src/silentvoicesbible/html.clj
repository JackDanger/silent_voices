(ns silentvoicesbible.html
  (:require clojure.string
            [silentvoicesbible.books :refer :all]
            [clostache.parser :refer :all]))

(def output-directory "_site")

(defn- filename [book chapter-num]
  (str (clojure.string/replace (.toLowerCase (:name book))
                               #"[^\d\w-_]"
                               "-") "-" chapter-num ".html"))

(defn- write-to [path s]
  (print ".")
  (.mkdir (java.io.File. output-directory))
  (with-open [writer (clojure.java.io/writer path)] (.write writer s)))

(defn- index []
  (write-to
    (str output-directory "/index.html")
      (render-resource "templates/index.mustache"
                       {:books (map #(assoc % :filename (filename % 1)) tanakh)})))

(defn- page [book chapter translation]
  (render-resource "templates/chapter.mustache"
                   {:book book
                    :chapter (:number chapter)
                    :chapters (map (fn [c] {:filename (filename book c) :number (:number c)}) (:chapters book))
                    :columns
                      (let [vs (for [v (.verses chapter)] (assoc v :html (.html v translation)))]
                        (for [cols (partition (int (/ (count vs) 2)) vs)] {:verses cols}))
                    :current-page (filename book (:number chapter))}))

(defn generate [args]
  (time
    (let [translation (str (or (nfirst (mapcat #(re-seq #"--translation=([\w]+)" %) args))
                                "feminized"))]
      (.exec (Runtime/getRuntime) "mkdir -p _site;ln -fs ../resources/assets _site/assets")
      (index)
      (let [book (first tanakh)]
      (doseq [chapter (:chapters book)]
        (write-to (str output-directory "/" (filename book (:number chapter)))
                  (page book chapter translation)))))))
