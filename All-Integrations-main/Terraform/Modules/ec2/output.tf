#output variable

output "awsinstanceid"{
  value = aws_instance.terraformwindowsinstance.*.id
}