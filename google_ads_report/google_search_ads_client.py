import json

from google.protobuf import json_format
from google.ads.googleads.client import GoogleAdsClient  # type: ignore
from .base_client import BaseClient


class GoogleSearchAdsApiClient(BaseClient):
    # TODO: Add support for SearchAds360 (client library is not available on pypi as of 2023-08-04,
    #  can be installed from source).
    # https://developers.google.com/search-ads/reporting/client-libraries/client-libraries
    pass
