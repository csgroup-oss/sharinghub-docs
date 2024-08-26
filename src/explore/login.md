# Login

Various login options are available on SharingHub.

## GitLab OAuth 2 session

SharingHub is based on GitLab version (>=)15.11, to which the data is connected. Connection to SharingHub is done via the OAuth2
protocol, which will send you back to GitLab. Once you are connected to GitLab, you will be redirected to SharingHub, connected.

## Personal Access Token

The private access token connection mode lets you connect to sharing via an active access token from GitLab.

!!! note Info
    The token may not have the right permissions. Check that the token is valid and has "api" scope. To see how it works [see more](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html).

## Default token

Your SharingHub may have a default token configured. In this case, you do not need to log in to view some projects, but some features will be limited.

!!! note Warning
    Depending on the platform configuration, this mode can be deactivated and you will be forced to login.
