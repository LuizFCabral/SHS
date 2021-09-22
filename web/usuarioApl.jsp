<%-- 
    Document   : usuarioApl
    Created on : 21/09/2021, 21:29:51
    Author     : catar
create table usuario_apl(
	codigo serial primary key,
	cpf varchar(14),
	nome varchar(40),
	tipo_pessoa varchar(1)
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
        <form action="usuarioApl.jsp" method="post">
            Nome: <input type="text" name="txtNome" onblur="validaCampo()"/> <br/>
            CPF: <input type="text" name="txtCPF" onblur="validaCampo()"/> <br/>
            Tipo de funcionário: <input type="text" name="txtTipo" onblur="validaCampo()"/> <br/>
            <input type="submit" name="b1" value="Cadastrar" onclick="callControlador()"/>&nbsp;&nbsp;
            <input type="submit" name="b1" value="Alterar" onclick="callControlador()"/>&nbsp;&nbsp;
            <input type="submit" name="b1" value="Remover" onclick="callControlador()"/>&nbsp;&nbsp;
            <input type="submit" name="b1" value="Consultar" onclick="callControlador()"/>
        </form>
    </body>
</html>
