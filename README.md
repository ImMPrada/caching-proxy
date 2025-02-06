# caching-proxy

A CLI tool that implements a caching proxy server to cache and serve responses from origin servers. This project is based on the [Caching Server Project](https://roadmap.sh/projects/caching-server) from roadmap.sh.

## Synopsis

This proxy server acts as an intermediary between clients and origin servers, caching responses to improve performance and reduce load on the origin servers. Key features include:

- Forward requests to specified origin servers
- Cache responses for subsequent identical requests
- Indicate cache status via X-Cache headers (HIT/MISS)
- CLI interface for server configuration
- Cache clearing functionality

## Local Deployment

To run the caching proxy server:

- you need bundle gem installed
- you need ruby 3.2.2
- you need to install the dependencies

```bash
bundle install
```

- create and install the database

```bash
bundle exec rakedb:create
bundle exec rakedb:migrate
```

- you need to run the origin server, for example to cache the Rick and Morty API

```bash
bin/caching-proxy start --port 3000 --origin https://rickandmortyapi.com
```

- you can clear the cache by running

```bash
bin/caching-proxy clear-cache
```

