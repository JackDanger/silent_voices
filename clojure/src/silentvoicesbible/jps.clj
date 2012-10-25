(ns silentvoicesbible.jps)

(def pattern #"\s?\{([SPN])\}\s?")

(defn- text-replacement [[_ match]] ({"S" "   "
                                      "P" "\n\n"
                                      "N" "\n"
                                     } match))
(defn- html-replacement [[_ match]] ({"S" " &nbsp; "
                                      "P" "<br /><br />"
                                      "N" "<br />"
                                      } match))

(defn jps-text [source] (clojure.string/replace source pattern text-replacement))
(defn jps-html [source] (clojure.string/replace source pattern html-replacement))
