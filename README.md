# Alpine-based sshd server

This Docker image consists of a lightweight OpenSSH server running on [Alpine Linux 3.6](https://hub.docker.com/_/alpine/).

## Usage

Host keys are generated on startup - use a volume to preserve them or create a new image based off
this one that bakes them in.

Root access is disabled. Users can be created via environment variables as follows:

`USER_xxx=yyy` creates a user called `xxx` and adds the public key(s) `yyy` to their
`authorized_keys` file.

`PWD_xxx=password` add `password` to user `xxx`

`USER_xxx=https://zzz` creates a user called `xxx` and retrieves their public key(s) via the
URL `https://zzz`. This allows for keys to be pulled from locations like
Github and GitLab.

## Example

```
$ docker run --name alpine-sshd-foo --restart=always -d -e USER_foo=https://github.com/foo.keys -e PWD_foo=bar -p 8022:22 mrbits/alpine-sshd
Creating user foo...
Server listening on 0.0.0.0 port 22.
Server listening on :: port 22.

$ ssh foo@localhost -p 8022
```

With a volume:
```
$ docker run --name alpine-sshd-foo --restart=always -d -e USER_foo=https://github.com/foo.keys -e PWD_foo=bar -p 8022:22 -v /host/path:/home/xxx mrbits/alpine-sshd

# SSH host keys written to /host/path
```

## Changelog

**2017-07-07** Initial version.
**2018-05-23** Fork and allow SSH with password
