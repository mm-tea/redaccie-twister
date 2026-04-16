#let one-line-height = state("one-line-height", 1pt)
#let line-height-difference = 13pt
#let lines-per-page = 38

#let header-footer-space = -30pt
#let page-width = 330pt
#let inside-margin = 20pt
#let outside-margin(page-width) = 148mm - inside-margin - page-width

#let bleed-state = state("bleed-state", 0mm)
#let in-outline = state("in-outline", false)
#let placed-float = state("placed-float", [])

#let second-page() = context placed-float.get()

#let styled-block(raised: false, text-style, body) = context {
	let text-style = text-style.with(
		font: "Minion 3",
		size: 10pt,
		// stretch: 100%,
	)
	let new-leading = line-height-difference - measure(text-style[a]).height
	let average-leading = (par.leading + new-leading)/2
	set block(
		inset: if raised {(top: -line-height-difference/2, bottom: line-height-difference/2)} else {(y: line-height-difference/2)},
		above: if raised {par.leading + line-height-difference} else {par.leading},
		below: new-leading,
		width: if block.width == auto {100%} else {block.width},
	)
	set par(leading: new-leading)
	block(text-style(body))
}

#let subtitle = it => context {
	let subtitle-style = text.with(
		font: "Fira Sans",
		size: 9pt,
	)
	let space-difference = measure([a]).height - measure(subtitle-style[a]).height
	subtitle-style(it)
	v(space-difference)
}

#let one-column(body) = context {
	// pagebreak(weak: true)
	// set page(
	// 	margin: (
	// 		outside: outside-margin(page-width*4/5) + bleed-state.get(),
	// 	),
	// 	columns: 1,
	// )
	body
}

#let two-column(body) = context {
	pagebreak(weak: true)
	set page(
		margin: (
			outside: outside-margin(page-width) + bleed-state.get()
		),
		columns: 2,
	)
	body
}

#let twister-style(bleed: 0mm, body) = {
	let em-equiv(length) = 100%*(length/1em*10pt/2.27pt)
	set par(
		justification-limits: (
			spacing: (min: em-equiv(1em/5), max: em-equiv(1em/3)),
			tracking: (min: -0.2pt, max: 0.1pt),
		)
	)
	set text(
		size: 10pt,
		font: ("Minion 3", "FreeSerif", "FreeSans"),
		// number-type: "old-style",
		number-width: "proportional",
	)
	set columns(
		gutter: 13.2pt
	)
	show figure.caption: set text(size: 8.5pt, font: "Minion 3")
	show figure.caption: set align(left)
	show figure.caption: it => context {
		let line-height-caption = 11pt
		set par(leading: line-height-caption - measure([a]).height)
		it
		v(-0.05em)
	}
	set figure(numbering: none)
	show figure: set place(clearance: 7pt)
	show raw: set text(font: "Fira Mono")
	show raw: box
	show: it => context {
		let leading-body = line-height-difference - measure([a]).height
		set par(
			leading: leading-body,
			spacing: leading-body,
			// first-line-indent: 2em,
			first-line-indent: 1.5em,
		)
		set page(
			numbering: "1",
			footer: context {
				set text(
					font: "Fira Sans",
					size: 7.5pt,
				)
				let (num,) = counter(page).get()
				if calc.even(num) {
					set align(left)
					h(header-footer-space)
					h(100% - page-width)
					context if page.numbering != none {numbering(page.numbering, num)} else {none}
					// h(page-width - header-footer-space)
				} else {
					set align(right)
					context if page.numbering != none {numbering(page.numbering, num)} else {none}
					h(header-footer-space)
					h(100% - page-width)
				}
			},
			paper: "a5",
			width: 148mm + bleed,
			height: 210mm + 2*bleed,
			margin: (
				outside: outside-margin(page-width) + bleed,
				inside: inside-margin,
				y: (210mm + 2*bleed - (lines-per-page - 1)*line-height-difference - measure([a]).height)/2,
			),
			footer-descent: 20pt,
			header-ascent: 20pt,
		)
		it
	}
	show heading: set par(justify: false)
	show heading: set text(hyphenate: false)
	show heading.where(level: 1): it => context {
		let heading-style = text.with(
			font: "Fira Sans",
			size: 26pt,
			stretch: 50%,
			weight: "extrabold",
		)
		let leading-title = 2*line-height-difference - measure(heading-style[a]).height
		set par(
			leading: leading-title,
			spacing: leading-title,
		)
		let space-fix = one-line-height.get() + line-height-difference - measure(heading-style[a]).height
		set block(
			above: 0pt,
			below: space-fix + line-height-difference/2,
		)
		heading-style(it)
	}
	// show heading.where(level: 2): set text(size: 20pt)
	show heading.where(level: 2): it => {
		set align(center)
		let text-style = text.with(weight: "bold")
		styled-block(raised: true, text-style, it.body)
	}
	set par(justify: true)
	// set footnote(numbering: "1")
	set footnote.entry(clearance: 0.5em, separator: none, indent: 1em, gap: 0.65em)
	show footnote.entry: set text(size: 8.5pt, font: "Minion 3")
	show footnote.entry: it => context {
		let line-height-footnote = 11pt
		set par(leading: line-height-footnote - measure([a]).height)

		box(width: 1.5em, numbering(footnote.numbering, ..counter(footnote).at(it.note.location())))
		it.note.body
		v(-0.05em)
	}

	set quote(quotes: true)
	// show quote: set text(hyphenate: false)
	// show quote: set par(justify: false)
	show quote.where(block: true, quotes: true): it => context quote(
		block: true,
		quotes: false,
		attribution: it.attribution,
		{
			set text(font: "Minion 3", size: 10pt, style: "italic")
			let vertical-offset = -1.5pt
			let opposite-offset = 1.5pt
			let horizontal-offset = 1em
			place(
				top + left,
				dx: -horizontal-offset,
				dy: vertical-offset + opposite-offset,
				text(
					size: 8em,
					fill: luma(85%),
					style: "normal",
					// top-edge: "bounds",
					// bottom-edge: "bounds",
				)[“],
			)
			place(
				top + right,
				dx: horizontal-offset,
				dy: vertical-offset + 100% - one-line-height.get() - if it.attribution == none {0pt} else {line-height-difference} - opposite-offset,
				text(
					size: 8em,
					fill: luma(85%),
					style: "normal",
					// top-edge: "bounds",
					// bottom-edge: "bounds",
				)[”],
			)
		} +
		it.body,
	)
	let style-quote-block = it => context {
		let text-style = text.with(style: "italic")
		let inset = 0.5em
		set block(inset: (x: inset))
		styled-block(
			text-style,
			{
				it.body
				if it.attribution != none {
					// footnote(it.attribution)
					linebreak()
					h(1fr)
					[--- #it.attribution]
					h(-inset)
				}
			},
		)
	}
	show quote.where(block: true, quotes: auto): style-quote-block
	show quote.where(block: true, quotes: false): style-quote-block

	set bibliography(style: "unified-style-sheet-for-linguistics.csl", full: true)
	show bibliography: set par(
		justify: false,
		first-line-indent: 0pt,
		hanging-indent: 3em,
	)

	body
}

#let article-preview(body) = twister-style({
	counter(page).update(2)
	[#metadata("Article preview")<title>]
	set page(binding: right)
	body
})

#let article(
	type: "Article",
	title: [],
	author: [],
	author-pronouns: none,
	lang: "en",
	hyphenate: true,
	alignment: left,
	justify: true,
	column-count: 2,
	stretch-column: true,
	body,
) = {
	show: article-preview

	pagebreak(weak: true)
	set text(lang: lang)

	import "@preview/hydra:0.6.2": hydra, selectors
	set page(
		header: context {
			set text(
				font: "Fira Sans",
				size: 7.5pt,
			)

			if calc.even(counter(page).at(here()).first()) {
				set align(left)
				set text(style: "italic")

				h(header-footer-space)
				h(100% - page-width)
				hydra(
					skip-starting: true,
					selectors.custom(<short-title>),
					display: (_, it) => it.value,
				)
			} else {
				set align(right)

				// smallcaps[Theme: ]

				upper(
					hydra(
						skip-starting: true,
						selectors.custom(<title>),
						display: (_, it) => it.value,
					)
				)
				h(header-footer-space)
				h(100% - page-width)
			}
		},
		columns: column-count,
	)
	show: if column-count == 1 {one-column} else {it => it}

	context {
		let heading-body = {
			[
				#metadata(title)<short-title>
				#metadata(author)<author>
			]
			set block(width: page-width)
			heading(
				level: 1,
				context if in-outline.get() {
					[#title #box[(#text(style: "italic", author))]]
				} else {
					place(
						top + left,
						dx: -0.5em,
						dy: -0.75em,
						box({
							text(
								size: 1.5em,
								fill: luma(85%),
								smallcaps[Article]
							)
						}),
					)
					title
				},
			)
			if author-pronouns != none {
				subtitle[#author (#author-pronouns)]
			} else {
				subtitle(author)
			}
		}
		let clearance-amount = 2*line-height-difference - calc.rem(measure(heading-body).height/1pt, line-height-difference/1pt)*1pt
		if stretch-column {
			place(
				top + left,
				scope: "parent",
				float: true,
				clearance: clearance-amount,
				heading-body,
			)
		} else {
			place(
				top + left,
				float: true,
				clearance: clearance-amount,
				heading-body,
			)
		}
	}

	set heading(offset: 1)
	set align(alignment)

	show cite: set text(number-type: "lining")

	body
}

#let page-image(
	body,
	bleed: 0mm,
	page-fill: none,
	crop-line: black,
	outline: none,
) = context {
	set page(
		header: none,
		footer: none,
		margin: (
			outside: bleed-state.get() - bleed,
			inside: -bleed,
			y: bleed-state.get() - bleed,
		),
		fill: page-fill,
		foreground: crop-marks(bleed-state.get(), paint: crop-line)
	)
	if outline != none {
		// e.g. outline: ("")
		show heading: none
		heading({
			let type = outline.at("type", default: none)
			let title = outline.at("title", default: none)
			let author = outline.at("author", default: none)

			if type != none and type != "Article" {smallcaps(type + ": ")}
			[#title #box[(#text(style: "italic", author))]]
		})
	}
	body
}
