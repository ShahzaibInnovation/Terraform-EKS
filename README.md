
```markdown
# Terraform EKS Cluster Project

This repository contains a **Terraform project to deploy an Amazon EKS cluster** with a Free-Tier friendly node group.  
It includes a production-ready setup with **remote state in S3** and **state locking in DynamoDB**.

---

## 📁 Project Structure

```

terraform-eks/
│
├── backend.tf           # S3 backend + DynamoDB for remote state
├── provider.tf          # AWS provider configuration
├── variables.tf         # Variables used in the project
├── vpc.tf               # VPC, subnets, IGW, route tables
├── iam.tf               # IAM roles for EKS cluster & node group
├── eks-cluster.tf       # EKS cluster definition
├── nodegroup.tf         # Managed node group definition
├── outputs.tf           # Outputs like cluster endpoint and name
└── .gitignore           # Ignore Terraform state, secrets, etc.

````

---

## ⚙ Prerequisites

Before running this project, ensure:

- Terraform >= 1.5.0
- AWS CLI installed
- kubectl installed
- An AWS Free-Tier account (or any account)
- AWS credentials configured:

```bash
aws configure
````

Enter:

* AWS Access Key ID
* AWS Secret Access Key
* Default region (`us-east-1` recommended)
* Default output (`json`)

---

## 📝 `.gitignore`

The following files/folders are **ignored**:

```
*.tfstate
*.tfstate.backup
.terraform/
terraform.tfvars
crash.log
*.log
```

> **Reason:** State files and variables can contain sensitive info (AWS credentials, ARNs).

---

## 🔧 Setup Steps

### 1. Clone Repository

```bash
git clone git@github.com:shahzaib/terraform-eks.git
cd terraform-eks
```

---

### 2. Configure Backend (S3 + DynamoDB)

Terraform uses remote backend for **state storage and locking**:

* Create an S3 bucket:

```bash
aws s3api create-bucket --bucket <your-tfstate-bucket> --region us-east-1
aws s3api put-bucket-versioning --bucket <your-tfstate-bucket> --versioning-configuration Status=Enabled
```

* Create a DynamoDB table for locks:

```bash
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

* Update `backend.tf` with your bucket and table names.

---

### 3. Initialize Terraform

```bash
terraform init
```

✅ This will:

* Download AWS provider
* Configure remote backend

---

### 4. Plan Terraform Changes

```bash
terraform plan
```

* Review the resources Terraform will create.

---

### 5. Apply Terraform Changes

```bash
terraform apply
```

* Type `yes` when prompted
* This will create:

  * VPC, subnets, IGW, route tables
  * IAM roles for cluster & nodes
  * EKS cluster
  * Managed node group (Free-Tier t3.micro)

> Takes ~10-15 minutes.

---

### 6. Configure kubectl

```bash
aws eks update-kubeconfig --region us-east-1 --name <cluster-name>
kubectl get nodes
```

* You should see your node in `Ready` state.

---

### 7. Deploy a Test Pod (NGINX)

```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --type=NodePort --port=80
kubectl get pods -o wide
kubectl get svc
```

> **Tip:** On Free-Tier nodes, if the pod stays Pending, apply small resource requests:

```bash
kubectl delete deployment nginx

kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        resources:
          requests:
            cpu: 50m
            memory: 64Mi
          limits:
            cpu: 100m
            memory: 128Mi
---
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
EOF
```

---

### 8. Destroy Resources

```bash
terraform destroy
```

* Type `yes` to remove all resources.
* Recommended to save costs on Free-Tier.

---

## 📌 Notes

* **Control plane** is managed by AWS, not visible as EC2.
* Use **t3.micro** for Free-Tier nodes, **scale node group carefully**.
* All resources are tagged automatically via `default_tags` in `provider.tf`.
* Remote state ensures **team collaboration safety**.

---

### 📖 References

* [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* [EKS Terraform Module Guide](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
* [AWS EKS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)

---

✅ **Now anyone can clone this project, configure backend, and deploy a Free-Tier EKS cluster easily.**

```

---

I can also create a **shorter “copy-paste ready” version** with **all commands at the bottom** so someone can literally run the project in **5 minutes**.  

Do you want me to do that?
```
