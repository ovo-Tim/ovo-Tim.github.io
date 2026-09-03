# ovo-Tim Blog

A static, Material Design blog powered by [Typst](https://typst.app/), [Astro](https://astro.build/) and [Giscus](https://giscus.app/).

## Features

- **Typst-based posts** — write articles in `.typ` files under `content/article/`.
- **Material Design UI** — cards, chips, app bar, and a full color system for light/dark mode.
- **Static search engine** — client-side search and sorting on the `/article` page.
- **Giscus comments** — discussions powered by GitHub Discussions, no backend required.
- **Fully static** — builds to plain HTML/CSS/JS and deploys to GitHub Pages.

## Branches

- **`my-blogs`** — actual blog content and the deployed site. Push here to publish; the Pages workflow runs on this branch.
- **`main`** — framework only. Auto-deploy is disabled on this branch (manual `workflow_dispatch` only).
## Project structure

```text
content/article/       # Typst blog posts
content/other/         # Typst pages (e.g. about)
packages/tylant/       # Local Astro integration & components
src/                   # Astro pages and site config
src/styles/global.css  # Material Design tokens & styles
public/                # Static assets
typ/                   # Typst templates used by posts
.env                   # Public site configuration
.github/workflows/     # GitHub Pages CI
```

## Setup

```bash
pnpm install
pnpm dev        # http://localhost:4321
pnpm build      # output in dist/
pnpm preview    # preview the built site
```

## Writing posts

Create a new post:

```bash
pnpm create:post my-post-id
```

Or create a file manually in `content/article/`:

```typ
#import "/typ/templates/blog.typ": *
#show: main.with(
  title: "My Post",
  desc: [A short description.],
  date: "2025-07-26",
  tags: (
    blog-tags.misc,
  ),
)

= Heading

Your content here.
```

## Configuration

Edit `.env`:

```bash
SITE_TITLE="ovo-Tim Blog"
SITE="https://ovo-Tim.github.io"
URL_BASE=""                     # use "/repo/" for project sites
SITE_SOURCE_URL="https://github.com/ovo-Tim/ovo-Tim.github.io"

# Giscus (GitHub Discussions comments)
GISCUS_REPO="ovo-Tim/ovo-Tim.github.io"
GISCUS_REPO_ID="..."
GISCUS_CATEGORY="Announcements"
GISCUS_CATEGORY_ID="..."
```

To get your Giscus IDs, visit <https://giscus.app/> and follow the setup guide.

## Deploy to GitHub Pages

1. Push this repository to GitHub.
2. Go to **Settings → Pages** and set the source to **GitHub Actions**.
3. Allow the `my-blogs` branch to deploy: **Settings → Environments → github-pages → Deployment branches**.
4. The included `.github/workflows/gh-pages.yml` will build and deploy on every push to `my-blogs`.

## Credits

Based on the [tylant](https://github.com/Myriad-Dreamin/tylant) starter by Myriad-Dreamin.
