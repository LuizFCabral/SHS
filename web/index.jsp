<%-- 
    Document   : index
    Created on : 09/09/2021, 11:41:01
    Author     : Vinicius

create table usuario(
    codigo serial primary key,
    cpf varchar(14),
    nome varchar (40),
    data_nascimento date,
    cidade varchar(30)
);
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <form action="index.jsp" method="post">
             
        </form>
        <a href="usuario.jsp">Usuário</a>
    </body>
</html>
