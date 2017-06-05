import markovify
import re

bible = "../8924.txt.utf8"
declaration = "../declaration_of_independence.txt"
dune = "dune.txt"
with open(dune) as f:
    text = f.read()

text = re.sub(r'\d{3}:\d{3} ', ' ', text)

text_model = markovify.Text(text)

for i in range(1000):
    print(text_model.make_short_sentence(140))
    print(text_model.make_short_sentence(60))
    print(text_model.make_short_sentence(30))
