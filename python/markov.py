import markovify
import re

bible = "../8924.txt.utf8"
declaration = "../declaration_of_independence.txt"
with open(bible) as f:
    text = f.read()

text = re.sub(r'\d{3}:\d{3} ', ' ', text)

text_model = markovify.Text(text)

for i in range(55):
    print(text_model.make_short_sentence(140))
