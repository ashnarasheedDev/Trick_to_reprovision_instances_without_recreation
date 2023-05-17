##-------creating instance-----------##

resource "aws_instance" "frontend" {

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = "zomato-key"
  vpc_security_group_ids = ["sg-0303cb285b0d5e2c4"]

  tags = {
    Name    = "zomato-wwebserver"
    Project = "zomato"
    Env     = "dev"

  }
}

##--------defining null_resource----------##

resource "null_resource" "provision" {

  triggers = {

    usredata_change = md5(file("userdata.sh"))
  }

  depends_on = [ aws_instance.frontend ]

  provisioner "file" {

    source      = "userdata.sh"
    destination = "/tmp/userdata.sh"

    connection {

      type        = "ssh"
      user        = "ec2-user"
      private_key = file("zomato-key.pem")
      host        = aws_instance.frontend.public_ip

    }

  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/userdata.sh",
      "sudo /tmp/userdata.sh"

    ]

    connection {

      type        = "ssh"
      user        = "ec2-user"
      private_key = file("zomato-key.pem")
      host        = aws_instance.frontend.public_ip

    }


  }
