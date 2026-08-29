---
title: Auto-deploying My Portfolio
date: 2026-08-30
read_time: 2
tags: [Flutter, GitHub Actions, GitHub Pages, WebAssembly, Dart, gh-pages, CI/CD, WASM, Automation, Portfolio]
---

# Auto-deploying My Portfolio

I finally removed the manual deployment step from this portfolio.

The site is a Flutter web app hosted on GitHub Pages. I previously used [Peanut](https://pub.dev/packages/peanut) to build the site locally and update the `gh-pages` branch. It worked, but it still meant remembering to run the deployment command after every change.

Now GitHub Actions handles it on every push to `main`.

The deployment workflow does four things:

1. Checks out the latest code.
2. Sets up Flutter from the `master` channel.
3. Runs `flutter pub get` and builds the site with `flutter build web --wasm`.
4. Publishes `build/web` to the `gh-pages` branch.

Using `--wasm` means the web build can use Flutter's WebAssembly renderer where the browser supports it. The build output still lives in the normal `build/web` directory, so GitHub Pages only needs to serve that folder.

The workflow uses GitHub's built-in `GITHUB_TOKEN`, with permission to write repository contents. There is no personal access token to copy into repository secrets. GitHub creates the token for the workflow run and the deployment action uses it to update `gh-pages`.

The custom domain, `tirth.today`, is part of the deployment configuration too, so it stays attached whenever the branch is republished.

Now a blog post, gallery fix, or design tweak follows the same path: push to `main`, wait for the build, and the live site catches up.
