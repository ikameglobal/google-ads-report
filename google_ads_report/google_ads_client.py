import json

from typing import Iterator
from google.protobuf import json_format
from google.ads.googleads.client import GoogleAdsClient  # type: ignore
from .base_client import BaseClient


class GoogleAdsApiClient(BaseClient):
    def __init__(self, credentials: dict = None, credentials_path: str = None, version: str = "v14"):
        """
        Args:
            credentials: A dictionary of credentials for the Google Ads API.
            credentials_path: The path to a JSON file containing credentials for the Google Ads API.
            version: The version of the Google Ads API to use.

        Returns:
            An instance of the GoogleAdsApiClient class.

        Author:
            minhpc@ikameglobal.com
        """
        super().__init__(version)

        if not credentials_path and not credentials:
            raise ValueError("Either credentials or credentials_path must be provided.")

        if not credentials:
            with open(credentials_path, 'r') as f:
                credentials = json.load(f)

        self.client = GoogleAdsClient.load_from_dict(credentials, version)
        self.ads_service = self.client.get_service("GoogleAdsService")
        self.version = version

    def get_response_batch(self, customer_id: str, query: str) -> Iterator[dict]:
        """
        Returns a generator of batches of results from the Google Ads API.

        Args:
            customer_id: The Google Ads customer ID.
            query: The query to run against the Google Ads API.

        Returns:
            A generator of batches of results from the Google Ads API.
        """
        stream = self.ads_service.search_stream(customer_id=customer_id,
                                                query=query)
        for batch in stream:
            batch_result = []
            for row in batch.results:
                row = json_format.MessageToDict(row)
                batch_result.append(row)
            yield batch_result

    def get_response(self, customer_id: str, query: str) -> list:
        """
        Returns a list of results from the Google Ads API.

        Args:
            customer_id: The Google Ads customer ID.
            query: The query to run against the Google Ads API.

        Returns:
            A list of results from the Google Ads API.
        """
        stream = self.ads_service.search_stream(customer_id=customer_id,
                                                query=query)
        result = []
        for batch in stream:
            for row in batch.results:
                row = json_format.MessageToDict(row)
                result.append(row)
        return result
