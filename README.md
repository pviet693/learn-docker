Link youtube: [Sử dụng docker](https://www.youtube.com/watch?v=9Gf4vRYSkK8&list=PLwJr0JSP7i8At14UIC-JR4r73G4hQ1CXO&index=2) 

# D02 - Tìm hiểu Docker Image, chạy một Container

- Image trong docker là những phần mềm được đóng gói và quản lí bởi docker, image chỉ có thể đọc không thể sửa đổi

- Khi image được docker khởi chạy, thì phiên bản thực thi của image được gọi là container, các container có thể ghi được dữ liệu vào trong nó

- Liệt kê các image: ```docker images```
    - REPOSITORY: tên của image
    - TAG: phiên bản của image
    - IMAGE ID: mã hash của image
    - CREATED: ngày tạo ra image
    - SIZE: kích thước của image

- Tìm kiếm image:  ```docker search [ubuntu]```

- Tải image: ```docker pull [ubuntu:16.04]```

- Tải phiên bản cuối cùng của image: ```docker pull [ubuntu:latest]```, ```docker pull [ubuntu]```

- Xoá image: ```docker image rm [ubuntu:16.04]```, ```docker image rm [IMAGE ID]```

- Chạy container từ image: ```docker run -it [ubuntu:latest]```, ```docker run -it [IMAGE ID]```
    - Tham số '-t': container sẽ kết nối với terminal
    - Tham số '-i': container tạo ra sẽ nhận tương tác
    - Tham số '--name': đặt tên cho container, ```docker run --name [tên container] [image]```
    - Tham số '-h': đặt hostname, ```docker run --name [tên container] -h [tên host] [image]```

- Kiểm tra những container nào đang chạy: ```docker ps```

- Liệt kế tất cả các container kể cả container không chạy: ```docker ps -a```

- Chạy lại 1 container: ```docker start [CONTAINER ID | NAME]```

- Vào lại terminal của container: ```docker attach [CONTAINER ID | NAME]```

- Thoát khỏi terminal của container ra máy host nhưng vẫn muốn container chạy: CTRL + P + Q

- Đứng ngoài máy host muốn dừng container: ```docker stop [CONTAINER ID | NAME]```

- Xoá container đã dừng: ```docker rm [CONTAINER ID]```

- Xoá container đang chạy: ```docker rm -f [CONTAINER ID | NAME]```

### D03 - Lệnh Docker exec, lưu container thành image với commit, xuất image ra file

- Đứng ngoài máy host nhưng muốn chạy lệnh trong container: ```docker exec [CONTAINER ID | NAME] [command]```

```
    docker pull ubuntu latest
    docker run -it --name U1 -h ubuntu1 ubuntu:latest
    >> ls
    >> CTRL + P + Q
    docker attach U1
    >> CTRL + P + Q
    docker exec U1 ls
```

- Lưu container đã dừng thành image: ```docker commit [CONTAINER ID | NAME] [image name]:[tag]```

```
    docker pull ubuntu latest
    docker run -it --name U1 -h ubuntu1 ubuntu:latest
    >> apt update
    >> apt install vim
    >> exit
    docker commit U1 ubuntu-vim:v1
    [docker rm U1]
    docker run -it --name UV1 -h uv1 ubuntu-vim:v1
```

- Lưu image ra file: ```docker save --output [tên file xuất ra] [IMAGE ID | NAME]```

```
    docker pull ubuntu:latest
    docker run -it --name U1 -h ubuntu1 ubuntu:latest
    U1 >> apt update
    U1 >> apt install vim
    U1 >> exit
    docker commit U1 ubuntu-vim:v1
    docker rm U1
    docker save --output myimage.tar ubuntu-vim
    [docker image rm -f ubuntu-vim:v1]
```

- Nạp image vào docker từ một file: ```docker load -i [tên file]```

```
    docker pull ubuntu:latest
    docker run -it --name U1 -h ubuntu1 ubuntu:latest
    U1 >> apt update
    U1 >> apt install vim
    U1 >> exit
    docker commit U1 ubuntu-vim:v1
    docker rm U1
    docker save --output myimage.tar ubuntu-vim
    [docker image rm -f ubuntu-vim:v1]
    docker load -i myimage.tar
    docker images
```

- Đặt lại tên cho image vừa nạp vào docker từ file: ```docker tag [IMAGE ID] [image name]:[tag]```

```
    docker pull ubuntu:latest
    docker run -it --name U1 -h ubuntu1 ubuntu:latest
    ubuntu1 >> apt update
    ubuntu1 >> apt install vim
    ubuntu1 >> exit
    docker commit U1 ubuntu-vim:v1
    docker rm U1
    docker save --output myimage.tar ubuntu-vim
    [docker image rm -f ubuntu-vim:v1]
    docker load -i myimage.tar
    docker images
    docker tag ff1212323 ubuntu-vim:v1.1
```

### D04 - Chia sẻ dữ liệu giữa máy host trong các Docker, tạo và quản lý ổ đĩa docker volume

- Ánh xạ thư mục máy host vào container: ```docker run -it -v pathHost:pathContainer [IMAGE ID | NAME]```
    - Ở Desktop có thư mục data, bên trong chứa 1.txt
    - Khi thêm mới dữ liệu trong container thì ngoài host cũng update theo

```
    docker pull ubuntu:latest
    docker run -it --name U1 -h ubuntu1 ubuntu:latest
    ubuntu1 >> apt update
    ubuntu1 >> apt install vim
    ubuntu1 >> exit
    docker commit U1 ubuntu-vim:v1
    docker rm U1
    docker save --output myimage.tar ubuntu-vim
    docker image rm -f ubuntu-vim:v1
    docker load -i myimage.tar
    docker images
    docker tag ff123123 ubuntu-vim:v1.1
    docker run -it -v /Users/vietpham/Desktop/data:/home/data ubuntu-vim:v1.1 --name U1.1 -h ubuntu1.1
    ubuntu1.1 >> cd home
    ubuntu1.1 >> ls
    ubuntu1.1 >> cd data
    ubuntu1.1 >> vim 1.txt
    ubuntu1.1 >> echo "Hello" > 2.txt
    ubuntu1.1 >> exit
    docker rm U1.1
```

- Chia sẻ dữ liệu giữa các container:
    - Có 1 container U1.1 đang chạy dùng dữ liệu share từ host
    - Container U1.2 cũng dùng dữ liệu từ host nhưng được U1.1 share cho

```
    ...
    docker run -it -v /Users/vietpham/Desktop/data:/home/data ubuntu-vim:v1.1 --name U1.1 -h ubuntu1.1
    docker run -it -v --volumes-from U1.1 --name U1.2 ubuntu:latest
```

- Tạo ổ đĩa riêng để lưu dữ liệu cho các container, chỉ mất khi người dùng xoá đi

- Kiểm tra danh sách ổ đĩa: ```docker volume ls```

- Tạo ổ đĩa: ```docker volume create [VOLUME NAME]```

```
    docker volume create D1
```

- Kiểm tra thông tin ổ đĩa đã tạo: ```docker volume inspect [VOLUME NAME]```

```
    docker volume inspect D1
```

- Xoá ổ đĩa: ```docker volume rm [VOLUME NAME]```

```
    docker volume rm D1
```

- Gắn ổ đĩa volume vào container: ```docker run -it --mount source=[VOLUME NAME],target=[pathContainer] [IMAGE ID | NAME]```

```
    docker run -it --mount source=D1,target=/home/disk1 ubuntu:latest --name U1 -h ubuntu1
    ubuntu1 >> cd home
    ubuntu1 >> cd disk1
    ubuntu1 >> touch 1.txt
    ubuntu1 >> touch 2.txt
    ubuntu1 >> ls
    ubuntu1 >> exit
    docker rm U1
    docker run -it --mount source=D1,target=/home/disk1 ubuntu:latest --name U2 -h ubuntu2 
    ubuntu2 >> cd home
    ubuntu2 >> cd disk1
    ubuntu1 >> ls
    ubuntu1 >> exit
```

- Tạo ổ đĩa ánh xạ vào thư mục máy host: ```docker volume create --opt device=[pathHost] --opt type=none --opt o=bind [VOLUME NAME]```

```
    docker volume create --opt device=/Users/vietpham/Desktop/data --opt type=none --opt o=bind D1
    docker volume inspect D1
    decker run -it -v D1:/home/data ubuntu:latest --name U1 -h ubuntu1
    ubuntu1 >> cd home/data
    ubuntu1 >> ls
    ubuntu1 >> touch 3.txt
    ubuntu1 >> rm 1.txt
    ubuntu1 >> rm 2.txt
    ubuntu1 >> exit
    docker ps -a
    docker rm U1
```

### D05 - Mạng | Networking trong Docker, tạo và quản lý network trong container Docker

- Image busybox chứa các command của linux thông dụng

- Có 3 loại network mặc định:
    NETWORK ID     NAME      DRIVER    SCOPE
    8fa1fdf31105   bridge    bridge    local
    15069925741e   host      host      local
    d0d2cf5cbd68   none      null      local

- Thêm '--rm' vào lệnh docker run, sau khi container chạy kết thúc, docker sẽ remove container đó ra khỏi hệ thống

```
    docker run -it --rm ubuntu:latest
```

- Kiểm tra danh sách network: ```docker network ls```

- Mạng bridge là mạng mặc định mà các container kết nối vào

- Kiểm tra 1 network nào đó: ```docker network inspect [NETWORK NAME]```

```
    docker network inspect bridge
    docker run -it --name B1 busybox
    docker network inspect bridge
```

- Kiểm tra thông tin của container: ```docker inspect [CONTAINER ID | NAME]```

```
    docker inspect B1
```

- Ánh xạ cổng 80 của container vào 1 cổng bất kì của máy host:

```
    docker run -it --name B2 -p 8888:80 busybox
```

- Tạo network: ```docker network create --driver [DRIVER] [NAME]```

```
    docker network create --driver bridge network1
    docket network ls
```

- Xoá network: ```docker network rm [NAME]```

```
    docker network rm network1
```

- Chạy container với network chỉ định (mặc định là network bridge): ```docker run -it --network [NETWORK NAME] [IMAGE ID]```

```
    docker run -it --name U1 --network network1 busybox
```

- Kết nối thêm network cho container đang chạy: ```docker network connect [NETWORK NAME] [CONTAINER NAME | ID]```

```
    docker run -it --name U1 --network network1 busybox
    docker network connect bridge U1
```

### D06 - Cài đặt, tạo và chạy PHP, phiên bản có PHP-FPM bằng Docker
### D07 - Cài đặt, chạy Apache HTTPD bằng Docker
### D08 - Cài đặt, chạy MySQL bằng Docker
### D09 - Cài đặt và chạy WordPress trên Docker

- Đề bài: Tạo mạng bridge có tên là www-net, có 3 container: c-myql (cổng 3306), c-php (cổng 9000), c-httpd (cổng 443, 80), máy host access vào các container qua cổng 9999

```
    /** Tải php:7.3-fpm về, image php:7.3-fpm, dịch vụ fpm lắng nghe vào tạo nhiều tiến trình php ở cổng 9000, chờ cho web server vd như nginx hoặc http kết nối vào để chạy php thông qua proxy */
    docker pull php:7.3-fpm
    docker images
    docker network create --driver bridge www-net
    docker network ls
    /** Thư mục mycode/www trong máy host chứa file index.html, dùng để chia sẽ dữ liệu giữa các container */
    /** Tạo container c-php chạy ngầm, thêm tham số '-d' */
    /** Phải thêm thư mục mycode ở host vào Settings>Resources>File sharing để có thể share với các container */
    docker run -d --name c-php -h php -v /mycode/:/home/mycode --network www-net php:7.3-fpm
    docker exec -it c-php bash
    php >> cd /home/mycode
    php >> cd www
    [/** Thêm code php vào thư mục mycode/wwww/test.php */]
    /** Tải image Apache httpd */
    docker pull httpd
    /** Chạy container từ httpd, khi nó chạy thì nó thi hành luôn một lệnh nào đó */
    /** Copy file httpd.conf */
    docker rn --rm -v /mycode/:/home/mycode/ httpd cp /usr/local/apache2/conf/httpd.conf /home/mycode/
    /** Sửa file httpd.conf từ máy host */
    /**
        Bỏ comment: LoadModule proxy_module modules/mod_proxy.so
        Bỏ comment: LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so
        Thêm dòng mới cuối file: AddHandler "proxy:fcgi://c-php:9000" .php
        Chỉnh sửa đường dẫn: DocumentRoot "/home/mycode/www"
        Chỉnh sửa đường dẫn: <Directory "/home/mycode/www">
    */
    docker run -it --network www-net --name c-httpd -h http -p 9999:80 -p 443:443 -v /mycode/:/home/mycode/ -v /mycode/httpd.conf:/usr/local/apache2/conf/httpd.conf httpd

    /** Chạy container có thiết lặp biến môi trường */
    docker run -it --rm -e VAR_1=value1 -e VAR_2=value2 busybox -h busybox1 --name B1
    busybox1 >> echo $VAR_1

    /** Tải image mysql */
    docker pull mysql

    /** Trích xuất file config của mysql ra máy host */
    docker run -it --rm -v /mycode/:/home/mycode mysql cp /etc/mysql/my.cnf /home/mycode

    /** Sửa file my.cnf từ máy host */
    /**
        Thêm vào cuối file: default-authentication-plugin=mysql_native_password
        Tạo thư mục /mycode/db => lưu csdl
    */

    docker run --network www-net -e MYSQL_ROOT_PASSWORD=abc123 -v /mycode/my.cnf:/etc/mysql/my.cnf -v /mycode/db:/var/lib/mysql --name c-mysql mysql

    docker exec -it c-mysql bash
    root@46ffa4eaea5b >> mysql -u root -pabc123
    root@46ffa4eaea5b >> mysql >> show databases;
    root@46ffa4eaea5b >> mysql >> use mysql;
    root@46ffa4eaea5b >> mysql >> show tables;
    /** Tạo một user tên testuser với password là testpass */
    root@46ffa4eaea5b >> mysql >> CREATE USER 'testuser'@'%' IDENTIFIED BY 'testpass';
    root@46ffa4eaea5b >> mysql >> create database db_testdb;
    root@46ffa4eaea5b >> mysql >> create database wp_wordpress;
    root@46ffa4eaea5b >> mysql >> GRANT ALL PRIVILEGES ON wp_wordpress.* TO 'testuser'@'%';
    root@46ffa4eaea5b >> mysql >> flush privileges;
    root@46ffa4eaea5b >> mysql >> show databases;
    root@46ffa4eaea5b >> mysql >> select User from user;
    root@46ffa4eaea5b >> mysql >> exit
    root@46ffa4eaea5b >> mysql -u testuser -ptestpass
    root@46ffa4eaea5b >> mysql >> show databases;
    root@46ffa4eaea5b >> mysql >> exit

    /** Tải wordpress: https://wordpress.org/download, xong giải nén và copy vào mã thư mục /mycode/www */
    /** Chạy http://localhost:9999 chọn file index.php */
    /** Chọn ngôn ngữ */
    /** Thiết lập DB: Database Name là wordpress, Username là testuser, Password là testpass, Database Host lad c-mysql, Table Prefix là wp_ */
    /** Bấm submit */

    /** Kiểm tra log của container */
    docker logs c-php

    docker exec -it c-php bash
    /** Kiểm tra những extension đã cài đặt cùng với php */
    root@php >> php -m
    root@php >> docker-php-ext-install mysqli
    root@php >> docker-php-ext-install pdo_mysql
    root@php >> exit

    docker restart c-php

    /** Bấm vào Run the installtion */
    /** Nhập thông tin: Site Title là Website Wordpress, Username là admin, Password là amdin, Your Email là email@gmail.com */
    /** Bấm vào Install Wordpress */
    /** Bấm vào Log In */

    /** Thiết lập apche tự động try cập vào file index.php */
    /** Sửa file httpd.conf */
    /**
        Sửa dòng DirectoryIndex index.html index.php
    */

    docker rm -f c-httpd
    docker run -it --network www-net --name c-httpd -h http -p 9999:80 -p 443:443 -v /mycode/:/home/mycode/ -v /mycode/httpd.conf:/usr/local/apache2/conf/httpd.conf httpd
```

### D10 - Tra cứu thông tin Image, Container và giám sát hoạt động container Docker

- Tra Image được hình thành dựa trên những thao tác nào: ```docker image history [IMAGE ID | NAME]```

- Tra cứu thông tin Image: ```docker inspect [IMAGE ID | NAME]```

- Tra cứu thông tin Container: ```docker inspect [CONTAINER ID | NAME]```

- Tra cứu sự khác nhau của Container giữa thời điểm tạo ra với hiện tại: ```docker diff [CONTAINER ID | NAME]```

- Kiểm tra log của Container: ```docker logs [CONTAINER ID | NAME] --tail [NUMBER OF ROWS]```

```
    docker logs c-php --tail 10
```

- Kiểm tra log của Container tại thời gian thực: ```docker logs -f [CONTAINER ID | NAME]```

- Giám sát mức độ sử dụng tài nguyển của các Container chỉ định: ```docker stats [CONTAINER ID | NAME] [CONTAINER ID | NAME] ...```

- Giám sát mức độ sử dụng tài nguyển của tất cả Container: ```docker stats```

### D11 - Biên tập Dockerfile và sử dụng lệnh docker build để tạo các Image

- Đề bài: Tạo một image mới có tên myimage:v1 từ image cơ sở centos:latest trong image mới này có cài đặt:
    - httpd
    - htop
    - vim
    - copy một số file dữ liệu index.html vào thư mục /var/www/html
    - thi hành nền /usr/sbin/http khi container từ image chạy

```
    /** Tạo folder /mycode/myimage/test.html */

    docker pull centos:latest

    docker run -it --name cent -h C1 centos:latest
    C1 >> yum update -y
    C1 >> yum install httpd httpd-tools -y
    C1 >> httpd -v
    C1 >> yum install vim -y
    C1 >> yum install epel-release -y
    C1 >> yum update -y
    C1 >> yum install htop -y
    C1 >> Ctrl + P + Q
    docker ps
    docker cp /mycode/myimage/test.html cent:/var/www/html
    docker attach cent
    C1 >> cd /var/www/html
    C1 >> ls
    C1 >> exit
    docker commit cent myimage:v1
    docker images
    docker rm cent
    /** Chạy nền */
    docker run --rm -p 9876:80 myimage:v1 httpd -D FORCEGROUND
    /** Try cập htttp://localhost:9876, http://localhost:9876/test.html/ */
    docker image rm myimage:v1

    /** Tạo image bằng Dockerfile */
    ![./Dockerfile]
    /** Tạo file /mycode/myimage/Dockerfile */

    docker build -t myimage:v1 -f Dockerfile .
    docker run -p 6789:80 myimage:v1
```

### D12 - Sử dụng lệnh docker-compose chạy và quản lý các dịch vụ Docker

- docker-compose.yml chứa các chỉ thị để docker xây dựng nên những dịch vụ, những thiết lập để chạy ứng dụng

```text
    PHP:7.3-FPM (php product)
        - port: 9000
        - Cài mysqli, pdo_mysql:
            * docker-php-ext-install mysqli
            * docker-php-ext-install pdo_mysql
        - Thư mục làm việc: /home/sites/site1
    APACHE HTTPD: (c-httpd01)
        - port: 80, 443
        - config: /usr/local/apache2/conf/httpd.conf
            * Nạp: mod_proxy, mod_proxy_fcgi
            * Thư mục làm việc: /home/sites/site1
            * index mặc định: index.php hoặc index.html
            * PHPHANDLER: AddHandler "proxy:fcgi://php-product:9000"
    MYSQL: (mysql-product)
        - port: 3304
        - config: /etc/mysql/my.cnf
            * default-authentication-plugin=mysql_native_password
        - database: /var/lib/mysql -> /mycode/db
        - MYSQL_ROOT_PASSWORD: 123abc
        - MYSQL_DATABASE: db_site
        - MYSQL_USER: siteuser
        - MYSQL_PASSWORD: sitepass
    NETWORK:
        - bridge
        - my-network
    VOLUME: dir-site
        - bind, device = /mycode/
```

```
    /** Tạo image cho php:7.3-fpm */
    docker pull php:7.3-fpm
    cd /mycode/
    mkdir php
    touch ./php/Dockerfile
    code ./php/Dockerfile

    /** Tạo image cho httpd */
    docker pull httpd
    docker run --rm -v /mycode/:/home/ httpd cp /usr/local/apache2/conf/httpd.conf /home/
    code ./httpd.conf
    /**
        Bỏ comment: LoadModule proxy_module modules/mod_proxy.so
        Bỏ comment: LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so
        Thêm dòng mới cuối file: AddHandler "proxy:fcgi://c-php:9000" .php
        Chỉnh sửa đường dẫn: DocumentRoot "/home/sites/site1"
        Chỉnh sửa đường dẫn: <Directory "/home/sites/site1">
        Sửa dòng DirectoryIndex index.html index.php
    */
    docker run --rm -v /mycode/:/home/ mysql cp /etc/mysql/my.cnf /home/
    code ./my.cnf
    /**
        Thêm vào cuối file: default-authentication-plugin=mysql_native_password
    */
    mkdir db

    /** Tạo file docker-compose.yml */
```

- Chạy file docker-compose: ```docker-compose up```

- Dừng và xoá các dịch vụ của file docker-compose: ```docker-compose down```

- Dừng nhưng không xoá các dịch vụ của file docker-compose: ```docker-compose stop```

- Chạy lại các dịch vụ đã dừng: ```docker-compose start```

- Khởi động lại các dịch vụ đang chạy: ```docker-compose restart```

- Kiểm tra danh sách các container được chạy bởi docker-compose: ```docker-compose ps```

- Kiểm tra danh sách các container được chạy bởi docker-compose tương ứng với dịch vụ nào: ```docker-compose ps --service```

- Kiểm tra danh sách các service được chạy bởi docker-compose tương ứng với image nào: ```docker-compose images```

- Thi hành lệnh trong các service đang chạy bởi docker-compose: ```docker-compose exec my-php bash```

- Đọc log của các service được chạy bởi docker-compose: ```docker-compose logs```, ```docker-compose logs my-php my-httpd```

### D14 - Sử dụng Haproxy làm server cân bằng tải với Docker

- Chuyển các request đến các Web Server khác nhau

- Image: haproxy

- Refer: [https://xuanthulab.net/su-dung-haproxy-lam-de-can-bang-tai-va-server-trung-gian-voi-docker.html]

