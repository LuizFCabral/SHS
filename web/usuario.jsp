<%-- 
    Document   : usuario
    Created on : 09/09/2021, 11:31:16
    Author     : Vinicius
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        
        <script type="text/javascript">
            
        </script>
        
    </head>
    <body>
        <form action="usuario.jsp" method="post">
            Nome: <input type="text" name="txtNome" required/> <br/>
            CPF: <input type="text" name="txtCPF" required/> <br/>
            Data de nascimento: <input type="text" name="txtDataNasc" required/> <br/>
            Cidade: <input type="text" name="txtCidade" required/><br/><br/>
            <input type="submit" name="b1" value="Cadastrar"/>&nbsp;&nbsp;
            <input type="submit" name="b1" value="Alterar"/>&nbsp;&nbsp;
            <input type="submit" name="b1" value="Remover"/>&nbsp;&nbsp;
            <input type="submit" name="b1" value="Consultar"/>
        </form>
    </body>
</html>
