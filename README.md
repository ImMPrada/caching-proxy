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
