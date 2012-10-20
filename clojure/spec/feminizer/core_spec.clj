(ns feminizer.core-spec
  (:use [speclj.core]
        [feminizer.core]))

(describe "learn"
  (it "adds to the known forms"
    (should=           "testes, not ovaries"
             (feminize "testes, not ovaries"))
    (learn "testes" "ovaries")
    (should=           "ovaries, not ovaries"
             (feminize "testes, not ovaries"))
    (learn "ovaries" "testes")
    (should=           "ovaries, not testes"
             (feminize "testes, not ovaries"))
    ; check the round-trip
    (should= "ovaries, not testes" (feminize (feminize "ovaries, not testes")))))

(describe "forget"
  (it "removes from the known forms"
    (learn "lady" "gentleman")
    (learn "gentleman" "lady")
    (should=           "this lady and that lady are crazy for that gentleman"
             (feminize "this gentleman and that gentleman are crazy for that lady"))
    (forget "lady")
    (forget "gentleman")
    (should=           "this lady and that lady are crazy for that gentleman"
             (feminize "this lady and that lady are crazy for that gentleman"))))
(describe "whitespace"
  (it "is ignored"
    (should=        "   3 spaces preceed and two newlines follow\n\n"
          (feminize "   3 spaces preceed and two newlines follow\n\n"))))


