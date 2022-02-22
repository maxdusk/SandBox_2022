# VPC | Internet Gateway | Subnet | Route Tables #
Created VPC 10.15.0.0/16
Created Internet Gateway and attached to VPC to allow instances in VPC's scope to have global or some specific ip access 
Created Subnet for VPC in avaliability zone a 10.15.0.0/24
Attached default Route table created by VPC to subnet  

# EC2_Instances | Security groups | #
Created 2 instances with different OS systems Ubuntu/Amazon-linux in two different VPC 
One of instanceses launched with "user data" 
For every instance created Security Group in two VPC's
Added inbound rules for external and internal connection , ICMP connection rule, HTTP/HTTPS rules
