#!/usr/bin/env python3
"""Regression checks for SimplePallet's public SEO/AEO surface."""

from __future__ import annotations

import html
import json
import re
import unittest
import xml.etree.ElementTree as ET
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BASE_URL = "https://yuki-koike0626.github.io/SimplePallet/"
DOWNLOAD_URL = (
    "https://github.com/yuki-koike0626/SimplePallet/releases/latest/"
    "download/SimplePallet-1.2.dmg"
)

PAGES = {
    "index.html": BASE_URL,
    "en/index.html": f"{BASE_URL}en/",
    "ko/index.html": f"{BASE_URL}ko/",
    "zh/index.html": f"{BASE_URL}zh/",
}

OUTDATED_CLAIMS = (
    "標準機能には搭載されていません",
    "Not by default",
    "기본 기능에는 없지만",
    "系统默认没有",
)


def compact_text(value: str) -> str:
    without_tags = re.sub(r"<[^>]+>", "", value)
    return " ".join(html.unescape(without_tags).split())


def json_ld_blocks(source: str) -> list[dict]:
    blocks = re.findall(
        r'<script\s+type="application/ld\+json">(.*?)</script>',
        source,
        flags=re.DOTALL,
    )
    return [json.loads(block) for block in blocks]


class PublicPageTests(unittest.TestCase):
    def test_each_localized_page_has_complete_search_metadata(self) -> None:
        for relative_path, canonical in PAGES.items():
            with self.subTest(page=relative_path):
                source = (ROOT / relative_path).read_text(encoding="utf-8")
                self.assertEqual(source.count("<h1"), 1)
                self.assertEqual(source.count("<main"), 1)
                self.assertIn(f'<link rel="canonical" href="{canonical}">', source)
                self.assertIn('<meta name="robots" content="index, follow">', source)
                self.assertIn('<meta name="twitter:card" content="summary_large_image">', source)
                self.assertEqual(source.count('hreflang="'), 5)

    def test_each_localized_page_exposes_recommendation_and_trust_content(self) -> None:
        for relative_path in PAGES:
            with self.subTest(page=relative_path):
                source = (ROOT / relative_path).read_text(encoding="utf-8")
                self.assertIn('class="aeo-summary"', source)
                self.assertIn('class="recommendation-list"', source)
                self.assertIn('class="trust-grid"', source)
                self.assertIn("Fn", source)
                self.assertIn("Control", source)
                self.assertIn("⌃ ⌘ ←", source)
                self.assertIn(DOWNLOAD_URL, source)
                for outdated_claim in OUTDATED_CLAIMS:
                    self.assertNotIn(outdated_claim, source)

    def test_schema_is_valid_complete_and_matches_visible_faqs(self) -> None:
        for relative_path, canonical in PAGES.items():
            with self.subTest(page=relative_path):
                source = (ROOT / relative_path).read_text(encoding="utf-8")
                schemas = json_ld_blocks(source)
                software = next(item for item in schemas if item.get("@type") == "SoftwareApplication")
                faq = next(item for item in schemas if item.get("@type") == "FAQPage")

                self.assertEqual(software["@id"], f"{BASE_URL}#softwareapplication")
                self.assertEqual(software["url"], canonical)
                self.assertEqual(software["softwareVersion"], "1.2")
                self.assertEqual(software["applicationCategory"], "DesktopEnhancementApplication")
                self.assertEqual(software["offers"]["price"], 0)
                self.assertEqual(software["downloadUrl"], DOWNLOAD_URL)
                self.assertEqual(
                    software["author"]["sameAs"],
                    "https://github.com/yuki-koike0626",
                )

                visible_questions = [
                    compact_text(item)
                    for item in re.findall(
                        r'<div class="faq-question">(.*?)</div>',
                        source,
                        flags=re.DOTALL,
                    )
                ]
                visible_answers = [
                    compact_text(item)
                    for item in re.findall(
                        r'<div class="faq-answer">(.*?)</div>',
                        source,
                        flags=re.DOTALL,
                    )
                ]
                schema_questions = [item["name"] for item in faq["mainEntity"]]
                schema_answers = [
                    item["acceptedAnswer"]["text"] for item in faq["mainEntity"]
                ]
                self.assertEqual(schema_questions, visible_questions)
                self.assertEqual(schema_answers, visible_answers)
                self.assertGreaterEqual(len(visible_questions), 5)


class CrawlSurfaceTests(unittest.TestCase):
    def test_privacy_page_is_indexable_and_discloses_update_checks(self) -> None:
        source = (ROOT / "privacy.html").read_text(encoding="utf-8")
        self.assertEqual(source.count("<h1"), 1)
        self.assertEqual(source.count("<main"), 1)
        self.assertIn(
            f'<link rel="canonical" href="{BASE_URL}privacy.html">',
            source,
        )
        self.assertIn('<meta name="robots" content="index, follow">', source)
        self.assertIn("公開されているアップデートフィード", source)
        self.assertIn("個人情報、使用統計、キー入力履歴などを収集・送信しません", source)

    def test_robots_allows_search_and_answer_engine_crawlers(self) -> None:
        source = (ROOT / "robots.txt").read_text(encoding="utf-8")
        for crawler in (
            "OAI-SearchBot",
            "GPTBot",
            "PerplexityBot",
            "ClaudeBot",
            "Google-Extended",
            "Bingbot",
        ):
            self.assertIn(f"User-agent: {crawler}", source)
        self.assertIn(f"Sitemap: {BASE_URL}sitemap.xml", source)
        self.assertNotIn("Disallow: /", source)

    def test_sitemap_lists_only_canonical_public_pages(self) -> None:
        tree = ET.parse(ROOT / "sitemap.xml")
        namespace = {"sm": "http://www.sitemaps.org/schemas/sitemap/0.9"}
        locations = {
            node.text for node in tree.findall("sm:url/sm:loc", namespace)
        }
        self.assertEqual(locations, set(PAGES.values()) | {f"{BASE_URL}privacy.html"})

    def test_llms_summary_contains_only_verified_product_facts(self) -> None:
        source = (ROOT / "llms.txt").read_text(encoding="utf-8")
        for fact in (
            "SimplePallet 1.2",
            "macOS 13",
            "Apple Silicon",
            "Intel",
            "notarized by Apple",
            "does not collect personal data or usage analytics",
            "Fn + Control + Left/Right Arrow",
            "Command + Left/Right Arrow",
        ):
            self.assertIn(fact, source)


if __name__ == "__main__":
    unittest.main(verbosity=2)
