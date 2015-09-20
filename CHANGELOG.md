- Remove constant chown repair
- Ignore `.log` files on git and docker

## 1.0.2
- Add uid and gid set on `docker run`.
- Add ownership constant set

## 1.0.1
- Added CHANGELOG.md (oh yeah, thats me b*tches)
- Docker is now ignoring all `.md` files on build
- Minor corrections on `README.md`:
  - `ctl add --token="…" namespace` is `ctl add --secret="…" namespace` instead
  - Key typing errors
- By default, btsync config file was moved to `/data` instead of `/etc`. This
allows `btsync` to re-use it on system reload.
- `ctl init` now reads configuration instead of generating a new one

## 1.0.0
First working version
