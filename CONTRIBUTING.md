# Contributing to Terraform Azure Infrastructure

Thank you for your interest in contributing to this project! This guide will help you get started.

## Getting Started

1. **Fork the repository** and clone it locally
2. **Set up your development environment** by following the README instructions
3. **Create a new branch** for your feature or bug fix

## Development Workflow

### 1. Making Changes

- Make your changes in the `terraform/` directory
- Follow Terraform best practices and naming conventions
- Update documentation if necessary

### 2. Testing Changes

Before submitting a pull request:

1. **Validate Terraform configuration:**
   ```bash
   cd terraform
   terraform init
   terraform validate
   terraform fmt -check
   ```

2. **Test your changes:**
   - Create a test environment if possible
   - Verify the infrastructure deploys correctly
   - Test any new functionality

### 3. Submitting Changes

1. **Commit your changes** with clear, descriptive messages
2. **Push to your fork**
3. **Create a pull request** with:
   - Clear title and description
   - Reference to any related issues
   - Details about what was changed and why

## Pull Request Process

1. **Automated Checks**: The PR will trigger GitHub Actions that will:
   - Run `terraform fmt -check`
   - Run `terraform validate`
   - Run `terraform plan` and comment the results

2. **Review Process**: 
   - Maintainers will review your code
   - Address any feedback or requested changes
   - Once approved, the PR can be merged

3. **Deployment**: 
   - Merging to main will trigger the deployment workflow
   - Monitor the deployment for any issues

## Code Standards

### Terraform

- Use consistent naming conventions (kebab-case for resources)
- Include appropriate tags on all resources
- Add comments for complex logic
- Follow the principle of least privilege for IAM
- Use variables for configurable values

### Documentation

- Update README.md for any new features
- Document any new variables in variables.tf
- Include examples where helpful

### GitHub Actions

- Test workflow changes in your fork first
- Use appropriate permissions (principle of least privilege)
- Include proper error handling

## Issue Reporting

When reporting issues, please include:

- **Environment details** (Terraform version, Azure CLI version, etc.)
- **Steps to reproduce** the issue
- **Expected vs actual behavior**
- **Relevant logs or error messages**
- **Screenshots** if applicable

## Security

- **Never commit secrets** or sensitive information
- Use GitHub secrets for all credentials
- Report security vulnerabilities privately to maintainers

## Questions?

If you have questions about contributing:
- Check existing issues and discussions
- Create a new issue with the "question" label
- Reach out to maintainers

Thank you for contributing! 🚀
