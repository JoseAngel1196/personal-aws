# AWS Infrastructure Playground

This repository contains Terraform modules that manage a basic AWS infrastructure setup for a personal playground account. It uses separate modules to manage networking, security, and compute resources, allowing flexibility and modularity in the configuration.

### Project Structure

The repository is divided into the following main modules:

* Networking Module (./networking)
Manages VPC, subnets, and other networking-related resources.

* Security Module (./security)
Manages security configurations like key pairs, security groups, etc.

* Compute Module (./compute)
Manages EC2 instances or other compute resources within the configured networking and security infrastructure.