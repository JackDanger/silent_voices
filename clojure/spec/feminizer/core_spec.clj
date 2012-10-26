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
    (should= "ovaries, not testes" (feminize (feminize "ovaries, not testes"))))

  (it "translates forms even when they're adjacent"
    (learn "king" "queen")
    (learn "son"  "daughter")
    (should=           "queen daughter"
             (feminize "king son")))

  (it "doesn't replace word-fragments"
    (learn "male" "female")
    (should=           "Tamale for the female, please."
             (feminize "Tamale for the male, please.")))

  (it "works for hyphenated forms"
    (learn "man-child" "woman-child")
    (should=           "Wherein it was said: 'A woman-child is brought forth.'"
             (feminize "Wherein it was said: 'A man-child is brought forth.'"))))

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
    (should=        "   3 spaces precede and two newlines follow\n\n"
          (feminize "   3 spaces precede and two newlines follow\n\n"))))


