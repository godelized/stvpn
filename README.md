# Split tunneling with OpenVPN

This script builds a 10MB Docker image based on Alpine Linux that allows to run a containerized OpenVPN.
The configuration of the VPN can be set at runtime.

The container can receive traffic via `sockd` that is running in the container.
The configuration of `sockd` can be set at runtime.
A default [`sockd.conf`](./sockd.conf) is provided.

To use the VPN, applications should target the `sockd` server by redirecting their traffic to `localhost:1080` using the proper protocol.
With the default `sockd.conf` it would be `socks5://localhost:1080`.

# Usage

```bash
./stvpn.sh build # Once.
./stvpn.sh run
```
