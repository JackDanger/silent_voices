(defproject silentvoicesbible "0.0.1"
  :description "Clojure port of the silentvoicesbible.com compiler"
  :dependencies [
                 [org.clojure/clojure "1.4.0"]
                 [enlive "1.0.0"]
                 [de.ubercode.clostache/clostache "1.3.0"]
                 [speclj "2.1.2"]
                 [org.apache.opennlp/opennlp-tools "1.5.2-incubating"]
                ]
  :plugins [[speclj "2.1.2"]]
  :test-paths ["spec/"]
  :aot :all
  :main silentvoicesbible.core)
