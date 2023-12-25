# docker run -it --name cent centos:latest
FROM centos:latest

# C1 >> yum update -y
RUN yum update -y
# C1 >> yum install httpd httpd-tools -y
RUN yum install httpd httpd-tools -y
# C1 >> yum install vim -y
RUN yum install vim -y
# C1 >> yum install epel-release -y
RUN yum install epel-release -y
# C1 >> yum update -y
RUN yum update -y
# C1 >> yum install htop -y
RUN yum install htop -y

# Thiết lập thư mục làm việc mặc định
WORKDIR /var/www/html

# Cho biết image hoạt động hoặc lắng nghe trên cổng nào
EXPOSE 80

# docker cp /mycode/myimage/test.html cent:/var/www/html
ADD ./test.html /var/www/html

# Khi 1 container tạo ra từ image này thì mặc định nó sẽ chạy tiến trình nào
ENTRYPOINT [ "httpd" ]
# Thiết lập tham số cho ENTRYPOINT
CMD ["-D", "FORCEGROUND"]