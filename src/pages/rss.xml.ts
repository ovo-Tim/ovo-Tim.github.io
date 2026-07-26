import rss, { type RSSFeedItem } from "@astrojs/rss";
import { getCollection } from "astro:content";
import type { APIContext } from "astro";
import { kUrlBase, kSiteTitle, kSiteDescription } from "$consts";

export async function GET(context: APIContext) {
  if (!context.site) {
    throw new Error("No site URL found");
  }

  const posts = await getCollection("blog");
  const items: RSSFeedItem[] = posts.map((post) => ({
    title: post.data.title,
    description: post.data.description,
    pubDate: post.data.date,
    categories: post.data.tags,
    link: `${kUrlBase}/article/${post.id}/`,
  }));

  return rss({
    title: kSiteTitle,
    description: kSiteDescription,
    site: context.site,
    items,
  });
}
