# Authentication

The authentication with the API is done via [GitLab Access Token](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html).
You must set the header `X-Gitlab-Token` for your requests.

Examples:

- Python `requests`

  ```python
  import requests

  requests.get(
      "https://sharinghub.example.com/api/stac/collections/ai-model/items",
      headers={"X-Gitlab-Token": "xxxxxxxx"},
  )
  ```

- STAC client `pystac-client`

  ```python
  from pystac_client import Client

  catalog = Client.open('https://sharinghub.example.com/api/stac', headers={"X-Gitlab-Token": "xxxxxxxx"})
  ```
