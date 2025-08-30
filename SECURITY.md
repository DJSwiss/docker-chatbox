# Security Policy

## Supported Versions

We actively maintain and provide security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| latest  | :white_check_mark: |
| main    | :white_check_mark: |
| develop | :warning: (dev only) |

## Security Features

### Container Security

This project implements several security measures:

#### 1. Non-Root Execution
- Container runs as user `chatboxai` (UID 1001)
- No root privileges inside container
- Follows principle of least privilege

#### 2. Capability Restrictions
```bash
--cap-drop=ALL
--cap-add=SETUID
--cap-add=SETGID
```
- Drops all capabilities by default
- Only adds necessary capabilities for operation

#### 3. Security Options
```bash
--security-opt no-new-privileges:true
```
- Prevents privilege escalation
- Blocks setuid/setgid binaries

#### 4. Resource Isolation
- Uses dedicated network namespace
- Volume mounts are read-only where possible
- Wayland socket mounted securely

### Image Security

#### 1. Base Image
- Uses official Ubuntu 22.04 LTS
- Regular security updates via CI/CD
- Minimal attack surface

#### 2. Dependencies
- Only essential packages installed
- Regular dependency updates
- Vulnerability scanning in CI/CD

#### 3. Multi-Architecture Support
- Consistent security across ARM64 and x86_64
- Architecture-specific optimizations

## Reporting Security Vulnerabilities

### What to Report

Please report any security vulnerabilities in:
- Container escape possibilities
- Privilege escalation vectors
- Wayland socket security issues
- Dependency vulnerabilities
- Build process security flaws
- CI/CD pipeline vulnerabilities

### How to Report

**Please do NOT report security vulnerabilities through public GitHub issues.**

Instead, please report security vulnerabilities to:

1. **Email**: Send details to [security@yourproject.com](mailto:security@yourproject.com)
2. **GitHub Security**: Use GitHub's private vulnerability reporting feature
3. **PGP**: Use our PGP key for sensitive reports (key ID: YOUR_PGP_KEY)

### What to Include

When reporting a security vulnerability, please include:

1. **Description**: Clear description of the vulnerability
2. **Impact**: Potential impact and attack scenarios
3. **Reproduction**: Step-by-step reproduction instructions
4. **Environment**: System information and versions
5. **Mitigation**: Any temporary mitigation strategies

### Example Report

```
Subject: [SECURITY] Container Privilege Escalation in ChatBoxAI Docker

Description:
Found a potential privilege escalation vulnerability in the container...

Impact:
An attacker could potentially escape the container and gain host access...

Reproduction Steps:
1. Start container with: docker run...
2. Execute: docker exec...
3. Observe: privilege escalation occurs...

Environment:
- Docker version: 24.0.0
- Host OS: Ubuntu 22.04
- Architecture: x86_64

Suggested Fix:
Add additional security constraints...
```

## Response Process

### Timeline

We aim to respond to security reports according to the following timeline:

- **Initial Response**: Within 48 hours
- **Confirmation**: Within 5 business days
- **Fix Development**: Based on severity (1-30 days)
- **Release**: Coordinated disclosure after fix

### Severity Classification

| Severity | Description | Response Time |
|----------|-------------|---------------|
| Critical | Container escape, host compromise | 1-3 days |
| High | Privilege escalation, data exposure | 3-7 days |
| Medium | DoS, information disclosure | 7-14 days |
| Low | Minor security improvements | 14-30 days |

### Disclosure Process

1. **Private**: Work with reporter to understand and reproduce
2. **Development**: Develop and test fix privately
3. **Testing**: Verify fix across all supported platforms
4. **Release**: Coordinate public release with security advisory
5. **Credit**: Acknowledge reporter (unless they prefer anonymity)

## Security Best Practices

### For Users

#### 1. Host Security
```bash
# Keep Docker updated
sudo apt update && sudo apt upgrade docker.io

# Use proper user permissions
sudo usermod -aG docker $USER

# Secure Wayland socket permissions
chmod 700 /run/user/$(id -u)/
```

#### 2. Container Deployment
```bash
# Use specific tags, avoid 'latest' in production
docker run chatboxai-multi:v1.0.0

# Limit resources
docker run --memory=512m --cpus=1.0

# Use read-only filesystem where possible
docker run --read-only --tmpfs /tmp
```

#### 3. Network Security
```bash
# Use custom networks
docker network create --driver bridge chatboxai-net

# Restrict container networking if not needed
docker run --network none
```

### For Contributors

#### 1. Code Security
- Never commit secrets or API keys
- Use `.gitignore` for sensitive files
- Scan dependencies for vulnerabilities
- Follow secure coding practices

#### 2. Docker Security
- Use multi-stage builds
- Minimize attack surface
- Keep base images updated
- Use security scanners

#### 3. CI/CD Security
- Secure GitHub tokens
- Use minimal permissions
- Scan container images
- Verify signatures

## Security Testing

### Automated Testing

Our CI/CD pipeline includes:
- Container vulnerability scanning
- Dependency security checks
- Static code analysis
- Security configuration validation

### Manual Testing

Regular security assessments include:
- Penetration testing
- Container escape testing
- Privilege escalation testing
- Network security validation

## Security Updates

### Notification

Security updates are communicated through:
- GitHub Security Advisories
- Release notes
- Commit messages with `[SECURITY]` prefix

### Application

To apply security updates:

```bash
# Pull latest secure image
docker pull chatboxai-multi:latest

# Stop current container
docker stop chatboxai

# Remove old container
docker rm chatboxai

# Start with updated image
./run.sh
```

## Compliance

This project aims to comply with:
- CIS Docker Benchmark
- NIST Container Security Guidelines
- OWASP Container Security Top 10

## Contact

For security-related questions:
- Security Team: security@yourproject.com
- PGP Key: [Link to public key]
- Response Time: 48 hours maximum

## Acknowledgments

We thank the security community and researchers who help improve the security of this project through responsible disclosure.

---

**Last Updated**: 2024-01-01  
**Next Review**: 2024-07-01