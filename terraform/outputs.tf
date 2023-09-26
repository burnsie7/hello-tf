#output "ssh_connection_string" {
#  value = "ssh -i ~/.ssh/${aws_launch_template.hello_template.key_name}.pem -o IdentitiesOnly=yes ubuntu@${aws_instance.app_server.public_ip}"
#}

output "hello_app_url" {
  value = "http://${aws_lb.hello_asg_lb.dns_name}:8000"
}
