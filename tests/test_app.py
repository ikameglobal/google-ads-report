#!/usr/bin/env python
"""Tests for `google_ads_report` package."""
# pylint: disable=redefined-outer-name

import os

import pytest

from google_ads_report import GoogleAdsApiClient


@pytest.fixture
def cred_path():
    cred_path = os.environ.get("CREDENTIALS_PATH", None)
    assert cred_path is not None
    return cred_path


def test_report(cred_path):
    api_client = GoogleAdsApiClient(credentials_path=cred_path)
    assert api_client is not None

    query = f"""
                SELECT
                asset.id,
                asset.name,
                asset.type,
                asset.text_asset.text,
                asset.youtube_video_asset.youtube_video_title,
                asset.youtube_video_asset.youtube_video_id,
                asset.image_asset.full_size.url
            FROM asset
            """
    result = []
    for batch in api_client.get_response_batch(customer_id='2865142845', query=query):
        result.extend(batch)

    assert len(result) > 0
