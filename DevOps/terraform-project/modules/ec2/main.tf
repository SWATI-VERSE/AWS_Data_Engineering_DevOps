
# -----------------------------
# Frontend EC2
# -----------------------------
resource "aws_instance" "frontend" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [
    var.frontend_sg_id
  ]

  user_data = <<-EOF
#!/bin/bash
dnf update -y
dnf install -y httpd

systemctl enable httpd
systemctl start httpd

echo "<h1>Frontend Server - Apache HTTPD</h1>" > /var/www/html/index.html
EOF

  tags = {
    Name = "frontend-server"
  }
}

# -----------------------------
# Backend EC2
# -----------------------------
resource "aws_instance" "backend" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = false

  vpc_security_group_ids = [
    var.backend_sg_id
  ]

  user_data = <<-EOF
#!/bin/bash
dnf update -y

cat > /etc/yum.repos.d/mongodb-org.repo <<EOT
[mongodb-org-8.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/8.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-8.0.asc
EOT

dnf install -y mongodb-org

systemctl enable mongod
systemctl start mongod

sed -i 's/^  bindIp: .*/  bindIp: 0.0.0.0/' /etc/mongod.conf

systemctl restart mongod
EOF

  tags = {
    Name = "backend-server"
  }
}