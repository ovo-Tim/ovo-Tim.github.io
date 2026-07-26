#import "/typ/templates/blog.typ": *
#show: main.with(
  title: "Hello, Typst Blog",
  desc: [A sample post showing the Material Design Typst blog.],
  date: "2025-07-26",
  tags: (
    blog-tags.misc,
  ),
)

= Welcome

This is a static blog built with Typst, Astro and Material Design.

- No backend is required.
- Comments are powered by Giscus (GitHub Discussions).
- Search works entirely in the browser using a static search index.

= Code example

```typ
#let hello(name) = [Hello, #name!]
#hello("World")
```

Enjoy writing!
