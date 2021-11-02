<%-- 
    Document   : cadastrar
    Created on : 02/11/2021, 18:15:20
    Author     : Pedro
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="controller.UsuarioJpaController"%>
<%@page import="model.Banco"%>
<%@page import="controller.DAOJPA"%>
<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            request.setCharacterEncoding("UTF-8");
            SimpleDateFormat dF = new SimpleDateFormat("dd/MM/yyyy");
            String c = request.getParameter("txtCPF");
            Usuario obj = new Usuario();
            DAOJPA daoJ = new DAOJPA();
            Banco bb = new Banco();
            obj = (Usuario) daoJ.searchCPF(bb, c, obj.getClass());
            if(obj != null)
                throw new Exception("O CPF informado já está em uso!");
            obj = new Usuario();
            obj.setNome(request.getParameter("txtNome"));
            obj.setCpf(c);
            obj.setDataNascimento(dF.parse(request.getParameter("txtDataNasc")));
            obj.setCidade(request.getParameter("txtCidade"));
            UsuarioJpaController dao = new UsuarioJpaController(Banco.conexao);
            dao.create(obj);
%> 
            <h1>Usuário de nome <%=obj.getNome()%> cadastrado com sucesso. Código: <%=obj.getCodigo()%></h1>Clique <a href="usuario.jsp">aqui</a> para voltar ao formulário CRUD usuário
<%
    Banco.conexao.close();
        %>
    </body>
</html>
