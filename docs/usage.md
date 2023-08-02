For more information about the API (query syntax, available data), see
the [Google Ads API](https://developers.google.com/google-ads/api/docs/start).

# Reporting API

## Get report in batch

```python
from google_ads_report import GoogleAdsApiClient

client = GoogleAdsApiClient(credentials_path='<path-to-credentials>')

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
for batch in client.get_response_batch(customer_id='2865142845', query=query):
    result.extend(batch)
print(result)
```

## More examples
