(ns silentvoicesbible.jps
  (:use clojure.test))

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


(deftest test-jps
  (testing "jps-text"
     (is (= "   After space,\nafter newline\n\nafter paragraph   after space before new line.\n"
            (jps-text "{S} After space, {N}after newline {P} after paragraph {S} after space before new line. {N}"))))
  (testing "jps-html"
     (is (= " &nbsp; After space,<br />after newline<br /><br />after paragraph &nbsp; after space before new line.<br />"
            (jps-html "{S} After space, {N}after newline {P} after paragraph {S} after space before new line. {N}"))))
)
