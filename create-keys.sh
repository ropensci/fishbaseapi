openssl genrsa -out es-root.key 2048
openssl req -x509 -new -nodes -key es-root.key -days 10000 -out es-root.crt -subj '/C=US/ST=Oregon/L=Portland/CN=fishbaseapi.info'
openssl genrsa -out es.key 2048
openssl req -new -key es.key -out es.csr -subj '/C=US/ST=Oregon/L=Portland/CN=fishbaseapi.info'
openssl x509 -req -in es.csr -CA es-root.crt -CAkey es-root.key -CAcreateserial -out es.crt -days 10000
