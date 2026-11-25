# BoxBox on Railway

[BoxBox](https://github.com/jR4dh3y/BoxBox) (MIT): a self-hosted web file manager with large resumable uploads, previews, a code editor, search and expiring share links. Deploy it on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/yPw-5l)

## What this template runs
- **boxbox**: `ghcr.io/onepush-dev/boxbox:v0.3.2`, the `ghcr.io/jr4dh3y/boxbox:v0.3.2` image (application unmodified). Web UI on port 8080. One volume at `/data` holds your files (`/data/files`, shown as the `files` drive) and BoxBox's own state.

On every boot a wrapper step writes `config.yaml` with an `admin` user (bcrypt hash of `BOXBOX_ADMIN_PASSWORD`) and the JWT secret from `BOXBOX_JWT_SECRET`, so the file manager is never open to the public.

## After deploy
Open the Railway URL and sign in as `admin` with the `BOXBOX_ADMIN_PASSWORD` variable. Upload files into the `files` drive. Share links use your Railway domain.

Not affiliated with BoxBox.
