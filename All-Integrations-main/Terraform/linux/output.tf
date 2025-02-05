output "ips" {
  value=aws_instance.ubuntuinstance.*.public_ip
  
}