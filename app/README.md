# Termination Protection application

## Description

This app will serve as a Verification Admission Controller verifying if the object in question
is protected against deletion. It will look for the presence of `protected: "true"` label and
return crafted response denying the deletion request.

## Build milti-architecture image

```shell
docker buildx build \
  --push \
  --platform linux/amd64,linux/arm64 \
  --tag ac-termination-protection:v<version> .
```
