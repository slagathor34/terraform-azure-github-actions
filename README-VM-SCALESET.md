# VM-to-Scale-Set Pipeline with Terraform and Ansible

This repository provides a complete infrastructure-as-code solution for creating VM images with Ansible configuration and deploying them using Azure VM Scale Sets.

## 🏗️ **Architecture Overview**

```
┌─────────────────────────────────────────────────────────────────────┐
│                    VM Image Creation Pipeline                        │
├─────────────────────────────────────────────────────────────────────┤
│  1. Terraform creates VM + Infrastructure                            │
│  2. Ansible configures VM (installs software, security hardening)   │
│  3. VM is generalized and captured as image                         │
│  4. Image stored in Azure Compute Gallery                           │
│  5. VM resources cleaned up (optional)                              │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                   Scale Set Deployment Pipeline                      │
├─────────────────────────────────────────────────────────────────────┤
│  1. Terraform creates networking and load balancer                  │
│  2. VM Scale Set deployed using custom image                        │
│  3. Auto-scaling rules configured                                   │
│  4. Health probes and monitoring enabled                            │
│  5. Application accessible via public load balancer                 │
└─────────────────────────────────────────────────────────────────────┘
```

## 📁 **Repository Structure**

```
├── .github/workflows/           # GitHub Actions workflows
│   ├── terraform-deploy.yml     # Main infrastructure deployment
│   ├── terraform-plan.yml       # Infrastructure planning
│   ├── vm-image-creation.yml    # VM image creation pipeline
│   └── vm-scale-set-deploy.yml  # Scale set deployment
├── terraform/                   # Terraform configurations
│   ├── modules/                 # Reusable Terraform modules
│   │   ├── virtual-network/     # Network infrastructure
│   │   ├── virtual-machine/     # VM resources
│   │   ├── compute-gallery/     # Image gallery
│   │   ├── private-endpoint/    # Private connectivity
│   │   ├── vm-scale-set/        # Scale set with load balancer
│   │   ├── resource-group/      # Resource group management
│   │   ├── storage-account/     # Storage resources
│   │   ├── key-vault/          # Key vault for secrets
│   │   ├── sql-database/       # Database resources
│   │   └── app-service/        # App service resources
│   ├── environments/           # Environment-specific configs
│   │   ├── dev/               # Development environment
│   │   ├── staging/           # Staging environment
│   │   └── prod/              # Production environment
│   ├── main.tf               # Main Terraform configuration
│   ├── variables.tf          # Variable definitions
│   ├── outputs.tf            # Output definitions
│   └── terraform.tf          # Provider configurations
├── ansible/                   # Ansible automation
│   ├── playbooks/            # Ansible playbooks
│   │   ├── configure-vm.yml  # VM configuration
│   │   └── generalize-vm.yml # VM generalization
│   ├── templates/            # Jinja2 templates
│   │   ├── nginx.conf.j2     # Nginx configuration
│   │   └── index.html.j2     # Web page template
│   ├── ansible.cfg          # Ansible configuration
│   └── inventory            # Inventory file (auto-generated)
└── docs/                    # Documentation
    └── COMPONENT_GUIDE.md   # Guide for adding components
```

## 🚀 **Quick Start**

### Prerequisites

1. **Azure Account** with appropriate permissions
2. **GitHub Repository** with the following secrets configured:
   - `AZURE_CLIENT_ID` - Service Principal App ID
   - `AZURE_CLIENT_SECRET` - Service Principal Secret
   - `AZURE_TENANT_ID` - Azure Tenant ID
   - `AZURE_SUBSCRIPTION_ID` - Azure Subscription ID
   - `VM_SSH_PRIVATE_KEY` - SSH private key for VM access
   - `VM_SSH_PUBLIC_KEY` - SSH public key for VM access

### Step 1: Generate SSH Keys

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/azure_vm_key -N ""
```

Add the private key (`~/.ssh/azure_vm_key`) as `VM_SSH_PRIVATE_KEY` secret and public key (`~/.ssh/azure_vm_key.pub`) as `VM_SSH_PUBLIC_KEY` secret.

### Step 2: Create VM Image

1. Go to **Actions** → **VM Image Creation Pipeline**
2. Click **Run workflow**
3. Configure parameters:
   - **VM Name**: `template-vm`
   - **Image Version**: `1.0.0`
   - **Cleanup VM**: `true`
4. Wait for completion (~15-20 minutes)

### Step 3: Deploy Scale Set

1. Go to **Actions** → **Deploy VM Scale Set**
2. Click **Run workflow**
3. Configure parameters:
   - **Image Version**: `1.0.0` (from Step 2)
   - **Scale Set Name**: `web-scale-set`
   - **Initial Instances**: `2`
   - **Max Instances**: `10`
4. Wait for completion (~10-15 minutes)

### Step 4: Access Application

After deployment, the application will be accessible at:
- **Main Application**: `http://[Load-Balancer-IP]/`
- **Health Check**: `http://[Load-Balancer-IP]/health`

## 🔧 **Configuration Options**

### VM Configuration (Ansible)

The VM is configured with:
- **Web Server**: Nginx with custom configuration
- **Security**: UFW firewall enabled
- **Monitoring**: Health check endpoints
- **Optimization**: Package cleanup and system hardening

### Scale Set Configuration

- **Auto-scaling**: CPU-based scaling (scale out at 75%, scale in at 25%)
- **Load Balancer**: Standard SKU with health probes
- **Upgrade Policy**: Manual (configurable to Rolling/Automatic)
- **Instance Types**: Configurable VM sizes

### Network Configuration

- **Virtual Network**: 10.0.0.0/16 with multiple subnets
- **Subnets**: Separate subnets for VMs, Scale Sets, and Private Endpoints
- **Security**: Network Security Groups with least-privilege access
- **Private Endpoints**: Secure connectivity to storage and Key Vault

## 📊 **Monitoring and Scaling**

### Auto-scaling Metrics

The scale set automatically adjusts based on:
- **CPU Utilization**: Scale out when >75%, scale in when <25%
- **Custom Metrics**: Can be extended with additional metrics
- **Schedule-based**: Can be configured for predictable load patterns

### Health Monitoring

- **Load Balancer Probes**: HTTP health checks on `/health`
- **Application Insights**: Can be integrated for detailed monitoring
- **Azure Monitor**: Built-in monitoring for all resources

## 🔐 **Security Features**

### Network Security
- Private endpoints for storage and Key Vault access
- Network Security Groups with restrictive rules
- No public IP addresses on Scale Set instances

### Identity and Access
- User-assigned managed identities
- Role-based access control (RBAC)
- Key Vault integration for secrets management

### VM Security
- SSH key authentication only
- UFW firewall configured
- Regular security updates via Ansible

## 🛠️ **Customization**

### Adding New Software to VM Image

1. Modify `ansible/playbooks/configure-vm.yml`
2. Add required packages to the package installation task
3. Add configuration tasks as needed
4. Run the VM Image Creation Pipeline

### Scaling Configuration

Modify the Scale Set module variables in `terraform/modules/vm-scale-set/variables.tf`:

```hcl
variable "scale_out_cpu_threshold" {
  default = 75  # Change this value
}

variable "max_instance_count" {
  default = 10  # Change this value
}
```

### Network Configuration

Modify CIDR ranges in `terraform/modules/virtual-network/variables.tf`:

```hcl
variable "address_space" {
  default = ["10.0.0.0/16"]  # Change this range
}
```

## 📈 **Cost Optimization**

### VM Sizes
- **Development**: Standard_B2s (2 vCPU, 4GB RAM)
- **Production**: Standard_D2s_v3 (2 vCPU, 8GB RAM)
- **High Performance**: Standard_F4s_v2 (4 vCPU, 8GB RAM)

### Storage
- **Standard_LRS**: Cost-effective for development
- **Premium_LRS**: Better performance for production

### Auto-scaling
- Set appropriate minimum instances to avoid cold starts
- Configure scale-in policies to reduce costs during low usage

## 🔍 **Troubleshooting**

### Image Creation Issues

1. **SSH Connection Failures**: Check NSG rules and SSH key configuration
2. **Ansible Failures**: Review playbook syntax and VM connectivity
3. **Image Generalization**: Ensure VM is properly deallocated before generalization

### Scale Set Issues

1. **Image Not Found**: Verify image version exists in compute gallery
2. **Load Balancer**: Check health probe configuration and VM response
3. **Auto-scaling**: Review metrics and scaling rules

### Common Commands

```bash
# Check Scale Set instances
az vmss list-instances --resource-group scaleset-rg --name web-scale-set

# Test load balancer health
curl -f http://[LB-IP]/health

# View Scale Set metrics
az monitor metrics list --resource [SCALE-SET-ID] --metric "Percentage CPU"
```

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch
3. Make changes and test thoroughly
4. Submit a pull request

## 📚 **Additional Resources**

- [Azure VM Scale Sets Documentation](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Ansible Documentation](https://docs.ansible.com/)
- [Azure Compute Gallery](https://docs.microsoft.com/en-us/azure/virtual-machines/shared-image-galleries)

## 📄 **License**

This project is licensed under the MIT License - see the LICENSE file for details.
