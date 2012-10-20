(ns silentvoicesbible.books-spec
  (:use [speclj.core]
        [silentvoicesbible.books]))

(feminizer.core/learn "man" "woman")

(describe "tanakh"
  (it "starts with Genesis"
    (should= "Genesis" (:name (first tanakh))))
  (it "ends with Ezra"
    (should= "Ezra / Nehemiah" (:name (last tanakh)))))

(let [job          (nth tanakh 26)
      genesis      (nth tanakh 0)
      ecclesiastes (nth tanakh 30)]
  (describe "verse"
    (it ""
      (should= "In the beginning God created the heaven and the earth."
             (:source (first (.verses genesis))))
      (should= "There was a man in the land of Uz, whose name was Job; and that man was whole-hearted and upright, and one that feared God, and shunned evil."
             (:source (first (.verses job))))))
  (describe "feminized verse"
    (it ""
      (should= "There was a woman in the land of Uz, whose name was Job; and that woman was whole-hearted and upright, and one that feared God, and shunned evil."
             (.text (.verse job ["1" "1"])))))
  (describe ".text"
    (it ""
      (should= "   A time to love,   and a time to hate;\n   a time for war,   and a time for peace.\n"
             (.text (.verse ecclesiastes ["3" "8"])))))
  (describe ".html"
    (it ""
      (should= " &nbsp; A time to love, &nbsp; and a time to hate;<br /> &nbsp; a time for war, &nbsp; and a time for peace.<br />"
             (.html (.verse ecclesiastes ["3" "8"]))))))
