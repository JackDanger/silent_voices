(ns silentvoicesbible.jps-spec
  (:use [speclj.core]
        [silentvoicesbible.jps]))

(describe "jps-text"
  (it "decodes JPS symbols into whitespace"
    (should=    "   After space,\nafter newline\n\nafter paragraph   after space before new line.\n"
      (jps-text "{S} After space, {N}after newline {P} after paragraph {S} after space before new line. {N}"))))
(describe "jps-html"
  (it "decodes JPS symbols into html"
    (should=    " &nbsp; After space,<br />after newline<br /><br />after paragraph &nbsp; after space before new line.<br />"
      (jps-html "{S} After space, {N}after newline {P} after paragraph {S} after space before new line. {N}"))))
