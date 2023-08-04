import json

from google.protobuf import json_format
from google.ads.googleads.client import GoogleAdsClient  # type: ignore
from .base_client import BaseClient


class GoogleAdsApiClient(BaseClient):
    def __init__(self, credentials_path: str = None, version: str = "v14"):
        super().__init__(version)

        if not credentials_path:
            raise ValueError("Specify the path to your googleads_credentials.json file")

        with open(credentials_path, 'r') as f:
            credentials = json.load(f)

        self.client = GoogleAdsClient.load_from_dict(credentials, version)
        self.ads_service = self.client.get_service("GoogleAdsService")
        self.version = version

    def get_response_batch(self, customer_id, query):
        stream = self.ads_service.search_stream(customer_id=customer_id,
                                                query=query)
        for batch in stream:
            batch_result = []
            for row in batch.results:
                row = json_format.MessageToDict(row)
                batch_result.append(row)
            yield batch_result
