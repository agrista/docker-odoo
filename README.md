# Docker Odoo

Image that installs all dependencies required by Odoo

### GitHub Container Registry:

Follow [these](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry)
to create a token for your gitHub user.


```bash
echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin
```