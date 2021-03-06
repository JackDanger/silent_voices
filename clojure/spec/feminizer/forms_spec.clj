(ns feminizer.forms-spec
  (:use [speclj.core]
        [feminizer.forms]))


(describe "associations"
  (it "conforms to directionality"
    (should= {"bi" "directional", "directional" "bi", "single" "direction"}
             (associations "
                  # comment
                  too many words
                  single    -> direction
                  bi  directional
                  ")))
  (it "handles case sanely"
    (should= {"Adam" "Ada" "Ada" "Adam"}
             (associations "Adam Ada")))
  (it "allows hyphenated forms"
    (should= {"man-child" "woman-child"}
             (associations "
                  man-child -> woman-child"))))
