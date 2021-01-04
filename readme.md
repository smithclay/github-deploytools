### github-deploytools

Docker image for creating GitHub deployments and managing deployment statuses.

```sh
    # usage
    $ docker run  --rm \
        -e GITHUB_REPO=smithclay/hipster-shop \
        -e GITHUB_TOKEN=foo \
        github-deploytools
    
    # create a deploy
    $ docker run  --rm \
        -e LS_SERVICE_NAME=hipster-shop
        -e GITHUB_REPO=smithclay/hipster-shop \
        -e GITHUB_REF=master \
        -e SERVICE_ENV=production \
        -e GITHUB_TOKEN=foo \
        github-deploytools create

    # update a deployment status < id, status >
    $ docker run  --rm \
        -e GITHUB_REPO=smithclay/hipster-shop \
        -e GITHUB_TOKEN=foo \
        github-deploytools update-status 308437643 success
```
