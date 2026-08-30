---
title: Glide, BumpTech, and the Path to Google Photos
date: 2026-08-30
read_time: 5
tags: [Android, Glide, BumpTech, Google Photos, Image Loading, Open Source, Acquisitions]
---

# Glide, BumpTech, and the Path to Google Photos

I learned about the BumpTech acquisition from an episode of Fragmented. One of those podcasts where they dive into Android development stuff and just talk through how things actually work. They were discussing Glide and someone brought up that Google had actually bought the team behind it.

That got me curious. I'd been using Glide for years without knowing the story.

## The Early Days

Before Glide, loading images on Android was a mess. You'd get OOMErrors in production. Lists would stutter. People were doing the same caching dance in every project. Download images, resize them, store them in memory, manage eviction when RAM got tight. It was tedious and error-prone.

Square had Picasso, which was good. But in 2013, BumpTech released Glide. It was cleaner. It automatically sized images to your view dimensions instead of keeping full-resolution bitmaps in memory. It had lifecycle awareness. Pause requests when you're off-screen, resume when you come back. It just felt right.

The API was stupid simple: `Glide.with(context).load(url).into(imageView)`. That's it.

## Why Everyone Started Using It

By 2014, 2015, Glide was everywhere. Not just in startups. Google's own apps were using it. Square had Picasso, but Glide was faster and smarter with memory. If you were shipping an Android app and dealing with images, you were probably using Glide.

The thing that made it stick wasn't just performance. It was that the library felt like it understood what phones actually needed. It didn't pretend you had unlimited memory. It didn't make weird assumptions about network speed. It just solved the problem.

## Then Google Bought Them

In 2014, Google acquired Bump Technologies. The Bump app itself wasn't Google's priority. But the team was solid, and they had built Glide.

What Google was really buying was stewardship over the image loading pattern that had become standard across Android. That matters more than it sounds. If your library is in millions of apps and you want to influence how image loading works, you either buy the team or you build something better. Google bought the team.

After the acquisition, Glide stayed open source. Still on GitHub. People still contribute to it. But now it has Google's resources behind it.

## Google Photos

Google Photos launched in May 2015, about a year after the BumpTech acquisition. It needed to scroll through thousands of high-resolution photos without crashing, without burning through memory, without destroying battery life. Work on low-end devices and flagships.

Glide had already solved most of this. Memory-aware sizing. Smart caching. Lifecycle integration. Google didn't have to invent image loading from scratch for Photos. They could use and refine what BumpTech had already figured out.

That's not a coincidence. You don't acquire a team and then ignore their flagship library when you're building something that needs exactly what that library does.

## What Actually Matters

The interesting part of this story isn't that Google acquired BumpTech. Companies buy teams all the time. The interesting part is that Glide didn't die. It didn't get closed-sourced or abandoned. It kept getting better.

Google could have made Glide proprietary. Instead, they kept it open. People kept using it. People kept contributing. Google got a public library the community helped maintain, plus they got to use optimized internal versions for Google Photos.

That's the deal when a big company buys open source right. The library doesn't disappear. It gets better.

---

If you're loading images on Android, Glide is still the right call. Check the [docs](https://bumptech.github.io/glide/) and the [repo](https://github.com/bumptech/glide).

<details>
<summary>Watch Colt McAnlis from Google talk about image loading at scale</summary>

https://youtu.be/CcnwFJqEnxU

</details>
