# hello-world

Homework Idea:

Ok - I got a good homework/exploratory type exercise idea then:

Create a highly available "hello-world" type service as follows:

- has at least 3 ec2 nodes
- has a ALB that round-robin's the nodes
- the hello-world service should reply differently so you know you're hitting different nodes
- accessible only behind appgate :slightly_smiling_face:
- create a domain name, like burns01.datadog.me to reach the 3 ec2 nodes
- As a test, simulate failure by deleting some nodes, delete the load balancer, and restore the whole setup.
- Then, create multiple copies of this infra - ex: burns02.datadog.me, burns03.datadog.me, etc....
- Then give the terraform to one of us, and for example, I should be able to create bfung01.datadog.me without doing anything else except running terraform apply and supplying some config (like bfung01 instead of burns01).
- Finally, delete everything w/o using AWS cli or AWS console.  Spin the stack  up again, and delete it -- all w/o the console or cli. (edited) 

## remote-exec

      "sudo apt update -y",
      "sudo apt install git -y",
      "sudo git clone https://github.com/burnsie7/hello-world /home/ubuntu",
      "sudo chmod +x /home/ubuntu/assets/setup-web.sh"
      "sudo sh /home/ubuntu/assets/setup-web.sh"
