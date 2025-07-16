# # Static Website Hosting on AWS S3 using Terraform (Modular Approach)

This project sets up a static website hosted on AWS S3 using Terraform, following a modular approach. It uses Terraform modules to separate and organize infrastructure components for better maintainability and reusability.

## 🛠️ What It Does

- Creates an S3 bucket configured for static website hosting.
- Sets bucket policies to allow public access for website files.
- Uploads static website content (like `index.html`) to the S3 bucket.
- Outputs the S3 website endpoint for access.

## 🧱 Project Structure
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── modules/
└── s3_bucket/
├── main.tf
├── variables.tf
└── outputs.tf
## 🔐 Credentials Handling

**Important:**  
AWS access credentials (`access_key` and `secret_key`) are **not** included in this repository to follow best security practices.

To run this project, configure your AWS credentials using one of the following methods:

- Use AWS CLI and run `aws configure`
- Export credentials as environment variables:
  ```bash
  export AWS_ACCESS_KEY_ID="your-access-key"
  export AWS_SECRET_ACCESS_KEY="your-secret-key"

🚀 Usage
Clone the repo

Navigate into the project directory

Initialize Terraform using terraform init

Apply the configuration using terraform apply

Terraform will output the S3 static website endpoint once deployed

📂 Website Files
The website files (e.g., index.html) should be placed in a local directory that is referenced in the module for upload to the S3 bucket.

✅ Notes
This project is modular — code related to the S3 bucket creation is kept inside the modules/s3_bucket/ directory.

Reusable and clean Terraform structure.

Access credentials are intentionally excluded from the GitHub repository.
