#### provisioner-through-null_resource

 Recently one of my clients needs to provision his instance without using userdata and he wanted to make frequent and dynamic changes in script without recreating the instance. So I came to the below solution where I defined provisioners through null_resource.

#### Decsription

	In Terraform, the null_resource is a resource type that allows you to define a resource block without actually creating any infrastructure.
	Using null_resources with provisioners is a valid approach to apply frequent and dynamic changes to an instance without using user data and without recreating the instance. 
 
### Features
- Fully Automated
- Can apply back to back changes in userdata scripts without recreatng the instance

#### Here's how it works:

> Create a null_resource

• By specifying depends_on with the appropriate resource dependency, you ensure that the null_resource provisioner is executed after the associated resource, such as an AWS instance, has been created as I mentioned in above code.

• The triggers block specifies that the userdata_change trigger is set to the MD5 checksum of the userdata.sh file. If the contents of the file change, the checksum will change, and Terraform will recognize this as a trigger to update the null_resource.provision

```
resource "null_resource" "provision" { 
triggers = { 
usredata_change = md5(file("userdata.sh"))    
    }                                                              
depends_on = [ aws_instance.frontend ]          
}
```
> Add provisioners to the null_resource block

•	The "file" provisioner copies a file named "userdata.sh" from the local machine to the instance at the path "/tmp/userdata.sh". The provisioner uses SSH to connect to the instance and authenticate with a private key. The connection details are specified using the "connection" block.
•	The "remote-exec" provisioner runs two commands on the instance using SSH. The commands make the "/tmp/userdata.sh" file executable and then execute it. The "inline" parameter specifies the list of commands to execute. Like the "file" provisioner, the "remote-exec" provisioner uses the "connection" block to specify the connection details.
•	If you need to make changes to the provisioners, you can simply update the userdata script and apply it again. Terraform will detect the changes and execute the new provisioners

```
provisioner "file"  {  
source = "userdata.sh”
destination = "/tmp/userdata.sh”
   connection { 
      type = "ssh"                                                       
      user = "ec2-user" 
      private_key = file("my-key.pem") 
      host = aws_instance.frontend.public_ip 
    } 
 }  
provisioner "remote-exec" { 
inline = [ 
"sudo chmod +x /tmp/userdata.sh", 
"sudo /tmp/userdata.sh"                                           
] 
  connection  {  
      type = "ssh" 
      user = "ec2-user" 
      private_key = file("my-key.pem") 
      host = aws_instance.frontend.public_ip 
    } 
 } 
```
