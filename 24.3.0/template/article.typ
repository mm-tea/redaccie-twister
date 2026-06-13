#import "@local/redaccie-twister:24.3.0": article
#show: article.with(
	title: [My article title],
	author: [Firstname Lastname],
	author-pronouns: [pro/nouns], // optional
	lang: "en", // or "nl" etc.
)

// write your article text here

#lorem(20)

#lorem(100)

= Heading inside article

#lorem(100)
