### LEECH

**The most insecure appliction ever made**

The purpose of this application is to offer a disk for leeching over HTTP.
There are minimal safty checks *(read: none at all)* and you should never use
this.

That being said

```
$ npm install
$ ROOT=/data/ bin/leech
```

### Env Vars

`ROOT` controls where the data is served from.

`PREFIX` is added to the beginning of the URLs