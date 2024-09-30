# output public IP of the server.
output "webServer1_public_ip" {
  description = "The public IP address of the Web Server 1 EC2 instance"
  value       = aws_instance.webServer1.public_ip
}