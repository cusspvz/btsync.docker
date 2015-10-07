## Upcoming


## 2.0.1
- Unset debug

## 2.0.0
- Base Image changed to `cusspvz/node` which is based on Alpine and comes with
  Node.js pre-compiled.
- Applied S6 supervisor
- Code that initializes NFS Server was refactored
- Added a Features test suite image

## 1.2.0
- Remove constant chown repair
- Ignore `.log` files on git and docker
- Removed `docker` based commands from `package.json`
- Base Image is now `progrium/busybox`, which is based on `OpenWRT` distribution
- Added nfs server for data dir

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
