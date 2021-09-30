<%--
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
        <title>Gerenciamento de gestores e enfermeiros</title>
        <script type="text/javascript" src="javascript/js_geral.js"></script>
    </head>
    <body>
        <form action="usuarioApl.jsp" method="post">
            Código: <input type="text" name="txtNome""/> <br/>
            Nome: <input type="text" name="txtNome""/> <br/>
            CPF: <input type="text" name="txtCPF""/> <br/>
            Tipo de funcionário: G: <input type="radio" name="tipo_user" value="G"/>
            E: <input type="radio" name="tipo_user" value="E"/> <br/><br/>
            <input type="submit" name="b1" value="Cadastrar" onclick="callControlador()"/>&nbsp;&nbsp;
            <input type="submit" name="b1" value="Alterar" onclick="callControlador()"/>&nbsp;&nbsp;
            <input type="submit" name="b1" value="Remover" onclick="callControlador()"/>&nbsp;&nbsp;
            <input type="submit" name="b1" value="Consultar" onclick="callControlador()"/>
        </form>
    </body>
</html>
