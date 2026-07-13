---
title: Tag Filtering Is Live
date: 2026-07-14
read_time: 2
tags: [Flutter, Gaming, Portfolio]
---

# Tag Filtering Is Live

Tag filtering is now live on this portfolio blog.

Clicking a tag on a post now opens the blog list filtered by that tag.

Examples:
- `Flutter` -> shows Flutter posts
- `Gaming` -> shows gaming posts
- `Portfolio` -> shows portfolio posts

This uses a shareable route like `/blog?tag=Flutter`.

Why this is useful:

As more posts get added, a single long feed becomes harder to scan quickly. Tags make navigation feel intentional. Instead of scrolling through everything, you can jump into a focused view and only see posts related to one topic. That keeps discovery simple and helps readers stay in context.

For example, if you are mostly interested in engineering updates, selecting Flutter immediately narrows the list to technical posts. If you want a broader overview of site changes or project updates, selecting Portfolio gives a cleaner path. If you are reading about game-related ideas or experiments, Gaming gets you there in one click.

The filtering route is also bookmark-friendly. You can open a filtered page directly, share it, and come back later without repeating the same navigation steps. This is useful for both testing and day-to-day browsing.

Quick test:
1. Open this post.
2. Click a tag chip.
3. Confirm the filtered list appears.
4. Click `Clear` to return to all posts.

Expected behavior:
1. The selected tag appears as an active filter label.
2. Only posts containing that tag remain visible.
3. Clearing the filter returns the full blog list.

Small change, better navigation.
