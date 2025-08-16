# VM-to-Scale-Set Setup Instructions

This guide provides step-by-step instructions for setting up the complete VM-to-Scale-Set pipeline.

## 📋 **Prerequisites Checklist**

- [ ] Azure Account with Contributor access
- [ ] GitHub repository access
- [ ] Azure CLI installed locally
- [ ] SSH key pair generated

## 🔑 **Step 1: Create Azure Service Principal**

Run these commands to create a service principal for GitHub Actions:

```bash
# Login to Azure
az login

# Set your subscription (replace with your subscription ID)
az account set --subscription "your-subscription-id"

# Create service principal
az ad sp create-for-rbac --name "github-actions-terraform" \
    --role contributor \
    --scopes /subscriptions/your-subscription-id \
    --sdk-auth

# Get tenant and subscription info
az account show --query "{subscriptionId:id, tenantId:tenantId}"
```

## 🔐 **Step 2: Configure GitHub Secrets**

Add these secrets to your GitHub repository (Settings → Secrets and variables → Actions):

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `AZURE_CLIENT_ID` | Service Principal App ID | From step 1 output (`clientId`) |
| `AZURE_CLIENT_SECRET` | Service Principal Secret | From step 1 output (`clientSecret`) |
| `AZURE_TENANT_ID` | Azure Tenant ID | From step 1 output (`tenantId`) |
| `AZURE_SUBSCRIPTION_ID` | Azure Subscription ID | From step 1 output (`subscriptionId`) |
| `VM_SSH_PRIVATE_KEY` | SSH private key | Generated in step 3 |
| `VM_SSH_PUBLIC_KEY` | SSH public key | Generated in step 3 |

## 🗝️ **Step 3: Generate SSH Keys**

```bash
# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -f ~/.ssh/azure_vm_key -N ""

# Display private key (copy to VM_SSH_PRIVATE_KEY secret)
cat ~/.ssh/azure_vm_key

# Display public key (copy to VM_SSH_PUBLIC_KEY secret)
cat ~/.ssh/azure_vm_key.pub
```

## 🧪 **Step 4: Test the Setup**

### Test 1: Basic Infrastructure
1. Go to **Actions** → **Terraform Deploy**
2. Click **Run workflow** → **apply**
3. Wait for completion

### Test 2: VM Image Creation
1. Go to **Actions** → **VM Image Creation Pipeline**
2. Click **Run workflow**
3. Use default values or customize:
   - VM Name: `test-template-vm`
   - Image Version: `1.0.0`
   - Cleanup VM: `true`
4. Wait ~15-20 minutes

### Test 3: Scale Set Deployment
1. Go to **Actions** → **Deploy VM Scale Set**
2. Click **Run workflow**
3. Use the image version from Test 2
4. Wait ~10-15 minutes

## 🎯 **Step 5: Verification**

After successful deployment, verify:

```bash
# Check resource groups
az group list --query "[?tags.ManagedBy=='terraform']" -o table

# Check compute gallery images
az sig image-version list \
    --resource-group "image-creation-rg" \
    --gallery-name "imageGallery" \
    --gallery-image-definition "ubuntu-web-server" \
    -o table

# Check scale set instances
az vmss list-instances \
    --resource-group "scaleset-rg" \
    --name "web-scale-set" \
    -o table

# Test application (replace with actual load balancer IP)
curl http://[LOAD-BALANCER-IP]/
curl http://[LOAD-BALANCER-IP]/health
```

## 🔧 **Troubleshooting Common Issues**

### Issue: "Service Principal Authentication Failed"
**Solution**: Verify secrets are correctly configured and service principal has contributor role

### Issue: "SSH Connection Timeout"
**Solution**: Check NSG rules allow SSH (port 22) from GitHub Actions runners

### Issue: "Image Not Found"
**Solution**: Ensure VM Image Creation Pipeline completed successfully before Scale Set deployment

### Issue: "Terraform Backend Already Exists"
**Solution**: This is normal - the workflow will use existing backend storage

## 📞 **Getting Help**

1. Check workflow logs in GitHub Actions
2. Review Azure Resource Manager deployment logs in Azure Portal
3. Use Azure CLI to inspect resource states
4. Check the troubleshooting section in README-VM-SCALESET.md

## 🎉 **Success Indicators**

You've successfully set up the pipeline when:

- [ ] VM image creation completes without errors
- [ ] Scale set deploys with healthy instances
- [ ] Application responds at load balancer IP
- [ ] Health check endpoint returns "healthy"
- [ ] Auto-scaling rules are active

## 🚀 **Next Steps**

1. **Customize VM Configuration**: Modify Ansible playbooks for your application
2. **Add Monitoring**: Integrate with Azure Monitor and Application Insights
3. **Enhance Security**: Implement Azure Key Vault integration
4. **Optimize Costs**: Review auto-scaling thresholds and VM sizes
5. **Add CI/CD**: Integrate application deployment workflows
