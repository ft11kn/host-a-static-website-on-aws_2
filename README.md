Project Title Static Website Hosting on AWS 3-Tier VPC Architecture
Infrastructure Overview
You're hosting a static website with high availability, autoscaling, and secure access using a full VPC setup.

✅ Component-by-Component Breakdown
Component	Purpose
GitHub	Source repository for your static website code (HTML/CSS/JS)
IAM User	Secure user account with permissions to deploy AWS resources via CLI
Amazon Route 53	DNS service – maps your domain name to the ALB (e.g., www.example.com)
AWS Certificate Manager (ACM)	Issues SSL/TLS certificates for HTTPS
EC2 Instance Connect Endpoint	Secure access to EC2s in private subnets without using SSH keys

🏗️ VPC Layout
🔸 Availability Zones (AZ-a, AZ-b)
Ensures high availability by distributing resources across multiple data centers.

🔹 Public Subnets
Host:

NAT Gateways – allow outbound internet access for private instances

ALB (Application Load Balancer) – receives HTTP requests and routes to EC2s

🔹 Private Subnets
App Subnets: Run EC2 web servers as part of an Auto Scaling Group

Data Subnets: Reserved for future databases or backend resources

🚀 Core Services in the Workflow
Service	Role
Auto Scaling Group (ASG)	Automatically launches/terminates EC2s based on load
Application Load Balancer	Distributes traffic across multiple EC2 instances
EC2 Instances	Run Apache to serve your static site cloned from GitHub
NAT Gateways	Allow private subnets to access the internet (for updates/git clone)

🌐 Flow Summary
End users visit your domain (Route 53) which maps to your ALB

ALB routes traffic to healthy EC2 instances in private subnets

EC2s clone and serve static website from GitHub using Apache

Auto Scaling maintains instance count based on traffic

Admins access private EC2s using EC2 Instance Connect Endpoint

HTTPS (if ACM enabled) secures the connection

