import argparse
import html
import json
import re
import xml.etree.ElementTree as ET
from pathlib import Path

SITE_URL = "https://tirth.today"
BLOG_DIRECTORY = Path("assets/blogs")
STATIC_PATHS = ("/", "/blog/", "/animals", "/flutter-job-board")
DATE_PATTERN = re.compile(r"^date:\s*['\"]?(\d{4}-\d{2}-\d{2})['\"]?\s*$", re.MULTILINE)
TITLE_PATTERN = re.compile(r"^title:\s*(.*?)\s*$", re.MULTILINE)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    output = parser.parse_args().output

    build_directory = output.parent
    url_set = ET.Element("urlset", xmlns="http://www.sitemaps.org/schemas/sitemap/0.9")
    for path in STATIC_PATHS:
        ET.SubElement(ET.SubElement(url_set, "url"), "loc").text = f"{SITE_URL}{path}"

    for markdown_path in sorted(BLOG_DIRECTORY.glob("*.md")):
        slug = markdown_path.stem
        markdown = markdown_path.read_text(encoding="utf-8")
        title_match = TITLE_PATTERN.search(markdown)
        if not title_match:
            raise ValueError(f"Missing title in {markdown_path}")
        title = title_match.group(1).strip("\"'")
        date_match = DATE_PATTERN.search(markdown)
        description = _description(markdown, title)
        canonical_url = f"{SITE_URL}/blog/{slug}/"

        url = ET.SubElement(url_set, "url")
        ET.SubElement(url, "loc").text = canonical_url
        if date_match:
            ET.SubElement(url, "lastmod").text = date_match.group(1)

        article_directory = build_directory / "blog" / slug
        article_directory.mkdir(parents=True, exist_ok=True)
        (article_directory / "index.html").write_text(
            _article_page(
                title=title,
                description=description,
                canonical_url=canonical_url,
                published_date=date_match.group(1) if date_match else None,
            ),
            encoding="utf-8",
        )

    ET.indent(url_set, space="  ")
    output.parent.mkdir(parents=True, exist_ok=True)
    ET.ElementTree(url_set).write(output, encoding="utf-8", xml_declaration=True)


def _description(markdown, title):
    content = re.split(r"^---\s*$", markdown, maxsplit=2, flags=re.MULTILINE)
    if len(content) == 3:
        content = content[2]
    else:
        content = markdown
    content = re.sub(r"^\s*#+\s+.*$", "", content, count=1, flags=re.MULTILINE)
    paragraph = next((line.strip() for line in content.splitlines() if line.strip()), "")
    paragraph = re.sub(r"!\[.*?\]\(.*?\)", "", paragraph)
    paragraph = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", paragraph)
    paragraph = re.sub(r"[`*_>#]", "", paragraph)
    paragraph = " ".join(paragraph.split())
    if not paragraph:
        paragraph = f"Read {title} by Tirth Patel."
    if len(paragraph) > 160:
        paragraph = f"{paragraph[:157].rsplit(' ', 1)[0]}..."
    return paragraph


def _article_page(title, description, canonical_url, published_date):
    safe_title = html.escape(title, quote=True)
    safe_description = html.escape(description, quote=True)
    article_data = {
        "@context": "https://schema.org",
        "@type": "BlogPosting",
        "headline": title,
        "description": description,
        "mainEntityOfPage": canonical_url,
        "author": {
            "@type": "Person",
            "name": "Tirth Patel",
            "url": f"{SITE_URL}/",
        },
        "publisher": {"@type": "Person", "name": "Tirth Patel"},
    }
    if published_date:
        article_data["datePublished"] = published_date
    structured_data = json.dumps(article_data, ensure_ascii=False).replace("<", "\\u003c")

    return f"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <base href="/">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="{safe_description}">
  <meta name="robots" content="index, follow">
  <link rel="canonical" href="{canonical_url}">
  <meta property="og:type" content="article">
  <meta property="og:site_name" content="Tirth Patel">
  <meta property="og:title" content="{safe_title} | Tirth Patel">
  <meta property="og:description" content="{safe_description}">
  <meta property="og:url" content="{canonical_url}">
  <meta property="og:image" content="{SITE_URL}/icon-512.png">
  <meta name="twitter:card" content="summary">
  <meta name="twitter:title" content="{safe_title} | Tirth Patel">
  <meta name="twitter:description" content="{safe_description}">
  <meta name="twitter:image" content="{SITE_URL}/icon-512.png">
  <title>{safe_title} | Tirth Patel</title>
  <link rel="manifest" href="/manifest.json">
  <script type="application/ld+json">{structured_data}</script>
</head>
<body>
  <noscript>
    <main>
      <article>
        <h1>{safe_title}</h1>
        <p>{safe_description}</p>
        <p><a href="/blog/">More writing by Tirth Patel</a></p>
      </article>
    </main>
  </noscript>
  <script src="/flutter_bootstrap.js" async></script>
</body>
</html>
"""


if __name__ == "__main__":
    main()
