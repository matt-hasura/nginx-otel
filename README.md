# nginx_otel

This project provides support for OpenTelemetry distributed tracing in NGINX, offering:

- Lightweight and high-performance incoming HTTP request tracing
- [W3C trace context](https://www.w3.org/TR/trace-context/) propagation
- OTLP/gRPC trace export
- Fully dynamic variable-based sampling

## Building
```bash
$ docker buildx build --progress plain --platform linux/amd64,linux/arm64 --file Dockerfile \
    --build-arg VERSION=<nginx_version> --tag <repository:tag> --push .
```
**Example:**
```bash
$ docker buildx build --progress plain --platform linux/amd64,linux/arm64 --file Dockerfile \
    --build-arg VERSION=1.25.2 --tag igraphql/nginx:1.25.2 --push .
```

## Documentation

See documentation for [ngx\_otel\_module](https://nginx.org/en/docs/ngx_otel_module.html).
