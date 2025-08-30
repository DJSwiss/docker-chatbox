# Contributing to ChatBoxAI Docker System

Thank you for your interest in contributing to the ChatBoxAI Docker System! This document provides guidelines for contributing to this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Reporting Issues](#reporting-issues)

## Code of Conduct

This project adheres to a Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

## Getting Started

### Prerequisites

- Docker (≥ 20.10)
- Docker Buildx Plugin
- Git
- Basic understanding of containerization and Wayland

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/yourusername/docker-chatbox.git
   cd docker-chatbox
   ```
3. Add the original repository as upstream:
   ```bash
   git remote add upstream https://github.com/originalowner/docker-chatbox.git
   ```

## Development Setup

1. **Test the existing setup:**
   ```bash
   # Build the image
   ./build.sh
   
   # Test container startup
   ./run.sh
   ```

2. **Set up development environment:**
   ```bash
   # Create development branch
   git checkout -b feature/your-feature-name
   ```

## Making Changes

### Branch Naming

Use descriptive branch names:
- `feature/add-new-architecture-support`
- `fix/wayland-socket-permissions`
- `docs/update-installation-guide`
- `refactor/dockerfile-optimization`

### Coding Standards

#### Dockerfile
- Use multi-stage builds where appropriate
- Minimize layer count
- Use specific version tags for base images
- Follow security best practices
- Add appropriate labels and metadata

#### Shell Scripts
- Use `#!/bin/bash` shebang
- Set `set -e` for error handling
- Add descriptive comments
- Use meaningful variable names
- Quote variables properly

#### Documentation
- Use clear, concise language
- Provide examples where helpful
- Keep README.md updated
- Document breaking changes

### Commit Messages

Follow conventional commit format:
```
type(scope): brief description

Detailed description if needed

- List specific changes
- Reference issues: Fixes #123
```

Types:
- `feat`: New features
- `fix`: Bug fixes
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `ci`: CI/CD changes

## Testing

### Local Testing

1. **Build Testing:**
   ```bash
   # Test multi-architecture build
   ./build.sh
   
   # Verify both architectures
   docker buildx imagetools inspect chatboxai-multi:latest
   ```

2. **Runtime Testing:**
   ```bash
   # Test container startup
   ./run.sh
   
   # Check logs
   docker logs chatboxai
   
   # Test health endpoint (if applicable)
   curl -f http://localhost:3000/health
   ```

3. **Security Testing:**
   ```bash
   # Check container security
   docker run --rm -it chatboxai-multi:latest /bin/bash
   whoami  # Should not be root
   
   # Verify capabilities
   docker inspect chatboxai | grep -A 10 "CapDrop"
   ```

### Architecture Testing

Test on both architectures when possible:
- x86_64 (AMD64)
- ARM64 (if available)

### Wayland Testing

If you have Wayland available:
```bash
# Check Wayland socket
ls -la /run/user/$(id -u)/wayland-0

# Test with Wayland display
echo $WAYLAND_DISPLAY
```

## Submitting Changes

### Pull Request Process

1. **Update your fork:**
   ```bash
   git fetch upstream
   git checkout main
   git merge upstream/main
   git push origin main
   ```

2. **Rebase your feature branch:**
   ```bash
   git checkout feature/your-feature-name
   git rebase main
   ```

3. **Push and create PR:**
   ```bash
   git push origin feature/your-feature-name
   ```

4. **Create Pull Request on GitHub**
   - Use the provided PR template
   - Fill out all relevant sections
   - Link related issues
   - Add screenshots if UI changes

### PR Requirements

- [ ] Tests pass
- [ ] Documentation updated
- [ ] Security considerations addressed
- [ ] Multi-architecture compatibility maintained
- [ ] Breaking changes documented

## Reporting Issues

### Before Reporting

1. Search existing issues
2. Check the documentation
3. Try the latest version
4. Gather system information

### Issue Information

When reporting issues, include:

- **Environment:**
  - OS and version
  - Docker version
  - Architecture (x86_64/ARM64)
  - Display server (Wayland/X11)

- **Steps to reproduce:**
  - Exact commands run
  - Expected vs actual behavior
  - Error messages/logs

- **Additional context:**
  - Container logs: `docker logs chatboxai`
  - System logs if relevant
  - Screenshots if applicable

### Issue Templates

Use the appropriate issue template:
- **Bug Report**: For bugs and errors
- **Feature Request**: For new features
- **Support Question**: For help and questions

## Development Guidelines

### Security

- Never commit secrets or API keys
- Follow principle of least privilege
- Test security configurations
- Use official base images
- Keep dependencies updated

### Performance

- Optimize Docker layers
- Use multi-stage builds
- Minimize image size
- Test resource usage
- Consider caching strategies

### Compatibility

- Support multiple architectures
- Test on different OS versions
- Maintain Wayland compatibility
- Consider X11 fallback where appropriate

## Getting Help

- **Documentation**: Check README.md first
- **Issues**: Search existing issues
- **Discussions**: Use GitHub Discussions for questions
- **Community**: Follow community guidelines

## Recognition

Contributors will be recognized in:
- GitHub contributors list
- Release notes for significant contributions
- Documentation acknowledgments

Thank you for contributing to make this project better! 🚀