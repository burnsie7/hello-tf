# hello-world

Homework Idea:

Create a highly available "hello-world" type service as follows:

1. Has at least 3 ec2 nodes
2. Has a ALB that round-robin's the nodes
3. The hello-world service should reply differently so you know you're hitting different nodes
4. Accessible only behind appgate :slightly_smiling_face:
5. Create a domain name, like burns01.datadog.me to reach the 3 ec2 nodes
6. As a test, simulate failure by deleting some nodes, delete the load balancer, and restore the whole setup.
7. Create multiple copies of this infra - ex: burns02.datadog.me, burns03.datadog.me, etc....
8. Give the terraform to one of us, and for example, I should be able to create bfung01.datadog.me without doing anything else except running terraform apply and supplying some config (like bfung01 instead of burns01).
9. Finally, delete everything w/o using AWS cli or AWS console.  Spin the stack  up again, and delete it -- all w/o the console or cli.
