(defproject silentvoicesbible "0.0.1"
  :description "Clojure port of the silentvoicesbible.com compiler"
  :dependencies [
                 [org.clojure/clojure "1.5.0-alpha4"]
                 [enlive "1.0.0"]
                ]
  :aot :all
  :main silentvoicesbible.core)
